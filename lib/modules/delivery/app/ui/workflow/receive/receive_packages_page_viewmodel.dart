import 'dart:async';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:santapocket/core/abstracts/app_view_model.dart';
import 'package:santapocket/core/constants/constants.dart';
import 'package:santapocket/core/helpers/loading_helper.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/helpers/ui_helper.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/auth/domain/enums/language.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/cabinet/domain/usecases/get_list_cabinet_info_usecase.dart';
import 'package:santapocket/modules/cabinet/domain/usecases/get_list_cabinet_info_with_authorizations_usecase.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/dialog/agree_to_term_and_condition_dialog.dart';
import 'package:santapocket/modules/delivery/domain/events/delivery_cancel_event.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery/domain/usecases/get_receivable_deliveries_usecase.dart';
import 'package:santapocket/modules/delivery_authorization/domain/events/delivery_authorization_canceled_event.dart';
import 'package:santapocket/modules/delivery_authorization/domain/events/delivery_authorization_created_event.dart';
import 'package:santapocket/modules/delivery_authorization/domain/models/delivery_authorization.dart';
import 'package:santapocket/modules/delivery_authorization/domain/usecases/get_receivable_delivery_authorizations_usecase.dart';
import 'package:santapocket/modules/main/app/events/user_accept_tos_event.dart';
import 'package:santapocket/modules/setting/domain/usecases/get_setting_usecase.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/modules/user/domain/usecases/agree_tos_usecase.dart';
import 'package:santapocket/modules/user/domain/usecases/get_profile_usecase.dart';
import 'package:suga_core/suga_core.dart';
import 'package:url_launcher/url_launcher.dart';

@injectable
class ReceivePackagesPageViewModel extends AppViewModel {
  final GetProfileUsecase _getProfileUsecase;
  final GetSettingUsecase _getSettingUsecase;
  final GetListCabinetInfoUsecase _getListCabinetInfoUsecase;
  final GetListCabinetInfoWithAuthorizationsUsecase _getListCabinetInfoWithAuthorizationsUsecase;
  final GetReceivableDeliveriesUsecase _getReceivableDeliveriesUsecase;
  final GetReceivableDeliveryAuthorizationsUsecase _getReceivableDeliveryAuthorizationsUsecase;
  final AgreeTosUsecase _agreeTOSUserCase;

  ReceivePackagesPageViewModel(
    this._getProfileUsecase,
    this._getSettingUsecase,
    this._getReceivableDeliveryAuthorizationsUsecase,
    this._getReceivableDeliveriesUsecase,
    this._getListCabinetInfoUsecase,
    this._getListCabinetInfoWithAuthorizationsUsecase,
    this._agreeTOSUserCase,
  );

  StreamSubscription? _listenUserBalanceChanged;
  StreamSubscription? _listenUserFreeUsageChanged;
  StreamSubscription? _listenDeliveryAuthorizationCanceled;
  StreamSubscription? _listenDeliveryAuthorizationCreated;
  StreamSubscription? _listenDeliveryCancel;

  late TabController tabController;
  int tabLength = 2;

  final String sort = "created_at";
  final String dir = "asc";
  late CabinetInfo cabinetInfo;

  final _user = Rx<User?>(null);
  final _deliveries = Rx<List<Delivery>>([]);
  final _deliveryAuthorizations = Rx<List<DeliveryAuthorization>>([]);
  final _selectedDeliveryAuthorization = Rx<DeliveryAuthorization?>(null);
  final _listCabinetInfo = Rx<List<CabinetInfo>>([]);
  final _listCabinetInfoWithAuthorizations = Rx<List<CabinetInfo>>([]);
  final _indexSelectedOwnerPackage = Rx<int>(0);
  final _currentPage = Rx<int>(0);
  final _bankTransferInfo = Rx<Map<String, dynamic>>({});
  final _isFirstLoading = Rx<bool>(true);

  User? get user => _user.value;

  int get currentPage => _currentPage.value;

  int get indexSelectedOwnerPackage => _indexSelectedOwnerPackage.value;

  DeliveryAuthorization? selectedDeliveryAuthorization;

  List<Delivery> get deliveries => _deliveries.value;

  List<DeliveryAuthorization> get deliveryAuthorizations => _deliveryAuthorizations.value;

  List<CabinetInfo> get listCabinetInfo => _listCabinetInfo.value;

  List<CabinetInfo> get listCabinetInfoWithAuthorizations => _listCabinetInfoWithAuthorizations.value;

  bool get canReceiveAnotherPackage => deliveries.isNotEmpty || deliveryAuthorizations.isNotEmpty;

  Map<String, dynamic> get bankTransferInfo => _bankTransferInfo.value;

  bool get isFirstLoading => _isFirstLoading.value;

  void onChangeTab(int index) => _currentPage(index);

  void _initListener() {
    _listenDeliveryAuthorizationCreated = locator<EventBus>().on<DeliveryAuthorizationCreatedEvent>().listen((event) {
      getDeliveryAuthorization();
    });
    _listenDeliveryAuthorizationCanceled = locator<EventBus>().on<DeliveryAuthorizationCanceledEvent>().listen((event) {
      getDeliveryAuthorization();
    });
    _listenDeliveryCancel = locator<EventBus>().on<DeliveryCancelEvent>().listen((event) {
      _fetchData();
    });
  }

  @override
  void initState() {
    _onInit();
    super.initState();
  }

  Future<Unit> _onInit() async {
    _initListener();
    await _fetchData();
    return unit;
  }

  Future<Unit> _launchUri(String uri) async {
    if (await canLaunchUrl(Uri.parse(uri))) {
      await launchUrl(Uri.parse(uri));
    } else {
      showToast("Could not launch url");
    }
    return unit;
  }

  Future<Unit> _onAcceptTOS() async {
    await showLoading();
    final bool result = await run(() => _agreeTOSUserCase.run());
    if (result) {
      locator<EventBus>().fire(const UserAcceptTOSEvent());
    }
    await hideLoading();
    return unit;
  }

  @override
  void disposeState() {
    _listenUserFreeUsageChanged?.cancel();
    _listenUserBalanceChanged?.cancel();
    _listenDeliveryAuthorizationCanceled?.cancel();
    _listenDeliveryAuthorizationCreated?.cancel();
    _listenDeliveryCancel?.cancel();
    tabController.dispose();
  }

  Future<Unit> _fetchData() async {
    late List<Delivery> deliveriesLoaded;
    late List<CabinetInfo> listCabinetInfoLoaded;
    late List<CabinetInfo> listCabinetInfoWithAuthorizationsLoaded;
    late User userLoaded;
    String termsAndConditionsUrl = '';
    String privacyPolicyUrl = '';
    final locale = FormatHelper.getPlatformLocaleName();
    late Map<String, dynamic> bankTransferInfoLoaded;
    final SortParams sortParams = SortParams(
      attribute: sort,
      direction: dir,
    );
    await showLoading();
    final success = await run(
      () async {
        deliveriesLoaded = await _getReceivableDeliveriesUsecase.run(
          sortParams: sortParams,
          cabinetId: cabinetInfo.id,
        );
        listCabinetInfoLoaded = await _getListCabinetInfoUsecase.run();
        listCabinetInfoWithAuthorizationsLoaded = await _getListCabinetInfoWithAuthorizationsUsecase.run();
        userLoaded = await _getProfileUsecase.run();
        final bankTransferInfoFetched = (await _getSettingUsecase.run(Constants.appBankTransferInfo)).value;
        if (bankTransferInfoFetched is Map<String, dynamic>) {
          bankTransferInfoLoaded = bankTransferInfoFetched;
        }
        termsAndConditionsUrl =
            (await _getSettingUsecase.run(locale == Language.vi.getValue() ? Constants.termsAndConditionsUrlVI : Constants.termsAndConditionsUrlEN))
                    .value ??
                '';
        privacyPolicyUrl =
            (await _getSettingUsecase.run(locale == Language.vi.getValue() ? Constants.privacyPolicyUrlVI : Constants.privacyPolicyUrlEN)).value ??
                '';
      },
    );
    if (success) {
      _deliveries.value = deliveriesLoaded;
      _isFirstLoading.value = false;
      _user(userLoaded);
      _listCabinetInfo.value = listCabinetInfoLoaded;
      _listCabinetInfoWithAuthorizations.value = listCabinetInfoWithAuthorizationsLoaded;
      _bankTransferInfo.value = bankTransferInfoLoaded;
      if (userLoaded.tosAgreedAt == null) {
        await locator<LoadingHelper>().clear();
        await Get.dialog(
          AgreeToTermAndConditionDialog(
            onAccept: _onAcceptTOS,
            onPrivacyPolicyTap: () => _launchUri(privacyPolicyUrl),
            onTermAndConditionTap: () => _launchUri(termsAndConditionsUrl),
          ),
          barrierDismissible: false,
        );
      }
    }
    await getDeliveryAuthorization();
    await hideLoading();
    return unit;
  }

  Future<Unit> getDeliveryAuthorization() async {
    List<DeliveryAuthorization> deliveryAuthorizationsTemp = [];
    final bool isSuccess = await run(
      () async {
        deliveryAuthorizationsTemp = await _getReceivableDeliveryAuthorizationsUsecase.run(cabinetId: cabinetInfo.id);
      },
    );
    if (isSuccess) {
      _deliveryAuthorizations.value = deliveryAuthorizationsTemp;
      _selectedDeliveryAuthorization.value = _deliveryAuthorizations.value.isNotEmpty ? _deliveryAuthorizations.value[0] : null;
      if (_deliveryAuthorizations.value.isNotEmpty && _deliveries.value.isEmpty) {
        tabController.animateTo(1);
        _currentPage.value = 1;
      }
    }
    return unit;
  }

  void initTabController(TickerProviderStateMixin providerStateMixin) {
    tabController = TabController(vsync: providerStateMixin, length: tabLength);
    tabController.addListener(() {
      _currentPage.value = tabController.index;
    });
  }
}
