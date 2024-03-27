import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/main/app/events/home_on_refresh_event.dart';
import 'package:santapocket/modules/marketing_campaign/app/ui/marketing_campaign/widgets/marketing_campaign_popup.dart';
import 'package:santapocket/modules/marketing_campaign/domain/models/marketing_campaign.dart';
import 'package:santapocket/modules/marketing_campaign/domain/usecases/click_on_campaign_banner_usecase.dart';
import 'package:santapocket/modules/marketing_campaign/domain/usecases/click_on_campaign_popup_usecase.dart';
import 'package:santapocket/modules/marketing_campaign/domain/usecases/get_running_marketing_campaigns_usecase.dart';
import 'package:santapocket/modules/payment/app/ui/payment_page.dart';
import 'package:santapocket/modules/user/app/ui/app_info/web_view_page.dart';
import 'package:santapocket/modules/user/domain/events/user_language_changed_event.dart';
import 'package:santapocket/storage/spref.dart';
import 'package:suga_core/suga_core.dart';

@injectable
class MarketingCampaignsPageViewModel extends AppViewModel {
  final GetRunningMarketingCampaignsUsecase _getRunningMarketingCampaignsUsecase;
  final ClickOnCampaignPopupUsecase _clickOnCampaignPopupUsecase;
  final ClickOnCampaignBannerUsecase _clickOnCampaignBannerUsecase;
  final EventBus _eventBus;

  MarketingCampaignsPageViewModel(
    this._getRunningMarketingCampaignsUsecase,
    this._clickOnCampaignPopupUsecase,
    this._clickOnCampaignBannerUsecase,
    this._eventBus,
  );

  StreamSubscription? _listenHomeOnRefresh;
  StreamSubscription? _listenLanguageChange;
  final _marketingCampaigns = <MarketingCampaign>[].obs;

  List<MarketingCampaign> get marketingCampaigns => _marketingCampaigns;
  MarketingCampaign? marketingCampaignPopup;

  // SortParams
  String direction = "DESC";
  String attribute = "started_at";

  bool? shouldShowPopup;

  @override
  void initState() {
    registerEvent();
    getRunningMarketingCampaigns();
    super.initState();
  }

  @override
  void disposeState() {
    _listenHomeOnRefresh?.cancel();
    _listenLanguageChange?.cancel();
    super.disposeState();
  }

  Future<Unit> getRunningMarketingCampaigns({bool forceData = true}) async {
    late List<MarketingCampaign> marketingCampaignsLoaded;

    SortParams sortParams = SortParams(
      direction: direction,
      attribute: attribute,
    );
    final success = await run(
      () async => marketingCampaignsLoaded = await _getRunningMarketingCampaignsUsecase.run(sortParams),
    );
    if (success) {
      _marketingCampaigns.value = marketingCampaignsLoaded.where((element) => element.bannerUrl != null).toList();
      if (shouldShowPopup == true && forceData && Get.currentRoute == "/MainPage") {
        marketingCampaignPopup = marketingCampaignsLoaded.firstWhereOrNull((campaign) => campaign.popupUrl != null);
        if (marketingCampaignPopup != null) {
          showMarketingCampaignPopup(marketingCampaignPopup!);
        }
      }
    }
    return unit;
  }

  void registerEvent() {
    _listenHomeOnRefresh = _eventBus.on<HomeOnRefreshEvent>().listen((event) {
      getRunningMarketingCampaigns(forceData: false);
    });
    _listenLanguageChange = _eventBus.on<UserLanguageChangedEvent>().listen((event) {
      getRunningMarketingCampaigns(forceData: false);
    });
  }

  void showMarketingCampaignPopup(MarketingCampaign campaign) {
    Get.dialog(
      MarketingCampaignPopup(
        onClickPopup: () => onClickPopup(campaign.postUrl, campaign.needAccessToken),
        marketingCampaign: campaign,
      ),
    );
  }

  Future<Unit> onClickPopup(String? postUrl, bool? needAccessToken) async {
    Get.back();
    await onClickBanner(postUrl, needAccessToken, marketingCampaignPopup?.id, isClickPopup: true);
    return unit;
  }

  Future<Unit> onClickBanner(String? postUrl, bool? needAccessToken, int? id, {bool isClickPopup = false}) async {
    if (postUrl == null) return unit;
    final processedUrl = (needAccessToken ?? false) ? await processUrl(postUrl) : postUrl;
    isClickPopup ? unawaited(countClickPopup(id)) : unawaited(countClickBanner(id));
    if (processedUrl.contains("/topup")) {
      await Get.to(() => const PaymentPage());
    } else {
      await Get.to(() => WebViewPage(url: processedUrl));
    }
    return unit;
  }

  Future<String> processUrl(String url) async {
    final accessToken = await SPref.instance.getAccessToken();
    return url += "${url.contains("?") ? "&" : "?"}access_token=$accessToken";
  }

  Future<Unit> countClickPopup(int? id) async {
    if (id == null) return unit;
    await run(
      () {
        _clickOnCampaignPopupUsecase.run(id);
      },
      shouldHandleError: false,
    );
    return unit;
  }

  Future<Unit> countClickBanner(int? id) async {
    if (id == null) return unit;
    await run(
      () {
        _clickOnCampaignBannerUsecase.run(id);
      },
      shouldHandleError: false,
    );
    return unit;
  }
}
