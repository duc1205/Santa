import 'dart:async';

import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/utils.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/charity/app/ui/charity_page.dart';
import 'package:santapocket/modules/delivery/app/ui/detail/delivery_detail_page.dart';
import 'package:santapocket/modules/delivery/app/ui/history/widgets/delivery_history_item_view.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_type.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/reminder_delivery_authorization/reminder_delivery_authorization_page.dart';
import 'package:santapocket/modules/main/app/ui/home/enums/action_scan.dart';
import 'package:santapocket/modules/main/app/ui/home/home_page_viewmodel.dart';
import 'package:santapocket/modules/main/app/ui/home/widgets/help_speed_dial.dart';
import 'package:santapocket/modules/main/app/ui/home/widgets/reminder_widget.dart';
import 'package:santapocket/modules/main/app/ui/home/widgets/welcome_widget.dart';
import 'package:santapocket/modules/main/app/ui/widgets/qr_scanner_page.dart';
import 'package:santapocket/modules/marketing_campaign/app/ui/marketing_campaign/marketing_campaigns_page.dart';
import 'package:santapocket/modules/notification/app/ui/notification_page.dart';
import 'package:santapocket/modules/user/app/ui/profile/widget/user_balance_widget.dart';
import 'package:santapocket/modules/version/app/ui/notify_update_view.dart';
import 'package:santapocket/modules/version/domain/enums/version_status.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:santapocket/core/abstracts/base_view_visible_aware_state.dart';
import 'package:santapocket/shared/ui/in_app_web_view_page.dart';
import 'package:santapocket/storage/spref.dart';
import 'package:visibility_aware_state/visibility_aware_state.dart';

class HomePage extends StatefulWidget {
  final Function(int) viewAllDelivery;
  final bool firstInitMain;

  const HomePage({required this.viewAllDelivery, this.firstInitMain = true, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BaseViewVisibleAwareState<HomePage, HomePageViewModel> with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  void onVisibilityChanged(WidgetVisibility visibility) {
    switch (visibility) {
      case WidgetVisibility.VISIBLE:
        if (!viewModel.loadedMainData) {
          viewModel.onRefresh();
        }
        break;
      case WidgetVisibility.INVISIBLE:
      case WidgetVisibility.GONE:
        break;
    }
    super.onVisibilityChanged(visibility);
  }

  @override
  HomePageViewModel createViewModel() => locator<HomePageViewModel>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
      ),
    );
    viewModel.locale = Localizations.localeOf(context).toString();
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: HelpSpeedDial(
        onZaloTap: () => launchUri("http://zalo.me/${viewModel.bankTransferInfo["contacts"]["zalo"]["value"]}"),
        onPhoneTap: () => callHotLine(viewModel.bankTransferInfo["contacts"]["call"]["value"]),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          unawaited(viewModel.onRefresh());
        },
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40.h, left: 15.w, bottom: 18.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: Colors.white,
                    child: Assets.images.imgAppWithoutSlogan.image(
                      height: 40.h,
                      width: 94.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.to(() => const NotificationPage()),
                    child: Container(
                      width: 20.w,
                      height: 20.h,
                      margin: EdgeInsets.only(
                        right: 16.w,
                      ),
                      child: Obx(
                        () => viewModel.hasUnreadNotification
                            ? Assets.icons.icNotificationBadge.image(
                                fit: BoxFit.contain,
                              )
                            : Assets.icons.icNotificationBadgeUnread.image(
                                fit: BoxFit.contain,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(21, 0, 21, 15),
                      child: Obx(
                        () => UserBalanceWidget(
                          coin: viewModel.getGem(),
                          freeUsage: viewModel.getFreeUsage(),
                          cone: viewModel.getCone(),
                        ),
                      ),
                    ),
                    // Display list action: send ,receive and rent pocket
                    Padding(
                      padding: EdgeInsets.only(left: 45.w, right: 45.w, bottom: 15.h),
                      child: _listActionButton(viewModel, context),
                    ),
                    // Display marketing campaigns banner
                    MarketingCampaignsPage(
                      shouldShowPopup: (widget.firstInitMain),
                    ),
                    // Display receivable DeliveryAuthorization
                    Obx(() => ReminderDeliveryAuthorizationPage(deliveryAuthorizations: viewModel.deliveryAuthorizations)),
                    // Display reminder
                    Obx(() {
                      if (viewModel.hasReminder()) {
                        return CarouselSlider.builder(
                          options: CarouselOptions(
                            aspectRatio: 343 / 117,
                            viewportFraction: 1,
                            enableInfiniteScroll: false,
                            onPageChanged: (index, reason) {
                              viewModel.setPageReminder(index);
                            },
                          ),
                          itemBuilder: (context, index, realIdx) {
                            return ReminderWidget(
                              delivery: viewModel.receivableDeliveries[index],
                            );
                          },
                          itemCount: viewModel.receivableDeliveries.length,
                        );
                      }
                      return const SizedBox();
                    }),

                    Obx(() {
                      if (viewModel.receivableDeliveries.length > 1) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: viewModel.receivableDeliveries.asMap().entries.map((e) {
                            return Container(
                              width: 8.w,
                              height: 8.w,
                              margin: EdgeInsets.only(left: 4.w, right: 4.w, top: 8.h, bottom: 15.h),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: viewModel.current == e.key ? AppTheme.orange.withOpacity(0.8) : AppTheme.grey.withOpacity(0.5),
                              ),
                            );
                          }).toList(),
                        );
                      } else if (viewModel.receivableDeliveries.length == 1) {
                        return SizedBox(
                          height: 15.h,
                        );
                      }
                      return const SizedBox();
                    }),

                    // show version status app
                    Obx(() => _showStatusVersion(viewModel.versionStatus)),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                        child: Text(
                          LocaleKeys.main_services.trans(),
                          style: AppTheme.blackDark_16w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.5.w),
                      child: Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ..._listServiceButton(viewModel),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    //Display welcome when no delivery
                    Obx(() {
                      return viewModel.deliveries.isEmpty ? const WelcomeWidget() : const SizedBox();
                    }),
                    SizedBox(
                      height: 15.h,
                    ),
                    Obx(
                      () => Visibility(
                        visible: viewModel.deliveries.isNotEmpty,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 8.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(
                                      LocaleKeys.main_delivery_history.trans(),
                                      style: AppTheme.black_18w600,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => widget.viewAllDelivery(2),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 8.w, top: 4.h, bottom: 4.h),
                                      child: Text(
                                        LocaleKeys.main_view_all.trans(),
                                        style: AppTheme.orange_14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: List.generate(viewModel.deliveries.length, (index) {
                                final delivery = viewModel.deliveries[index];
                                return DeliveryHistoryItemView(
                                  isReceiver: viewModel.isReceiver(index),
                                  delivery: delivery,
                                  onItemClick: () {
                                    Get.to(
                                      () => DeliveryDetailPage(
                                        deliveryId: delivery.id,
                                        isCharity: delivery.type == DeliveryType.charity,
                                      ),
                                    );
                                  },
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _showStatusVersion(VersionStatus versionStatus) {
  switch (versionStatus) {
    case VersionStatus.upToDate:
    case VersionStatus.outdated:
    case VersionStatus.unknown:
      return const SizedBox();
    case VersionStatus.updatable:
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: NotifyUpdateView(
          image: AssetImage(Assets.icons.icHomeNotifyGreen.path),
          text: LocaleKeys.main_notice_version_updatable.trans(),
          color: const Color(0xffEBFBF6),
        ),
      );
    case VersionStatus.deprecated:
      return Padding(
        padding: EdgeInsets.only(bottom: 15.h),
        child: NotifyUpdateView(
          image: AssetImage(Assets.icons.icHomeNotifyOrange.path),
          text: LocaleKeys.main_notice_version_deprecated.trans(),
          color: const Color(0xffFFE0A6),
        ),
      );
  }
}

Row _listActionButton(HomePageViewModel viewModel, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Obx(
        () => _actionButton(
          text: LocaleKeys.main_send.trans(),
          imageAction: Assets.icons.icHomeDriver.path,
          quantityPackage: viewModel.quantityRentDeliveries,
          action: () async {
            final barcode = await Get.to(
              () => const QRScannerPage(),
            );
            if (barcode != null) {
              await viewModel.handleQrCodeData(barcode: barcode as String, scan: ActionScan.send);
            }
          },
        ),
      ),
      Obx(
        () => _actionButton(
          text: LocaleKeys.main_receive.trans(),
          imageAction: Assets.icons.icHomeReceive.path,
          quantityPackage: viewModel.quantityPackageReceive,
          action: () async {
            final barcode = await Get.to(
              () => const QRScannerPage(),
            );
            if (barcode != null) {
              await viewModel.handleQrCodeData(barcode: barcode as String, scan: ActionScan.receive);
            }
          },
        ),
      ),
      _actionButton(
        text: LocaleKeys.main_rent.trans(),
        imageAction: Assets.icons.icHomeRent.path,
        action: () async {
          final barcode = await Get.to(
            () => const QRScannerPage(),
          );
          if (barcode != null) {
            await viewModel.handleQrCodeData(barcode: barcode as String, scan: ActionScan.selfRent);
          }
        },
      ),
    ],
  );
}

List<Widget> _listServiceButton(HomePageViewModel viewModel) {
  return List.generate(4, (index) {
    String url = "";
    String label = LocaleKeys.main_surprise.trans();
    AssetGenImage icon = Assets.icons.icHomeServiceMarket;
    Function()? onItemClick;
    switch (index) {
      case 0:
        label = LocaleKeys.main_surprise.trans();
        url = viewModel.surpriseServiceUrl;
        icon = Assets.icons.icHomeSurpriseService;
        onItemClick = () => viewModel.onExternalCLickServiceCLick(url);
        break;
      case 1:
        label = LocaleKeys.main_market.trans();
        url = viewModel.marketServiceUrl;
        icon = Assets.icons.icHomeServiceMarketEvent;
        onItemClick = () async {
          final accessToken = await SPref.instance.getAccessToken();
          url += "${url.contains("?") ? "&" : "?"}access_token=$accessToken";
          await Get.to(() => InAppWebViewPage(url: url));
        };
        break;
      case 2:
        label = LocaleKeys.main_parking.trans();
        url = viewModel.parkingServiceUrl;
        icon = Assets.icons.icHomeServiceParking;
        onItemClick = () => viewModel.onExternalCLickServiceCLick(url);
        break;
      case 3:
        label = LocaleKeys.main_charity.trans();
        icon = Assets.icons.icHomeServiceCharity;
        onItemClick = () => Get.to(() => const CharityPage());
        break;
    }
    return Expanded(
      child: InkWell(
        onTap: () => onItemClick?.call(),
        child: Column(
          children: [
            icon.image(width: 60.w, height: 74.h),
            SizedBox(
              height: 5.h,
            ),
            Text(
              label,
              style: AppTheme.blackDark_14,
            ),
          ],
        ),
      ),
    );
  });
}

Widget _actionButton({
  required String text,
  required String imageAction,
  required VoidCallback action,
  int quantityPackage = 0,
}) {
  return InkWell(
    onTap: action,
    child: SizedBox(
      width: 85.w,
      child: Column(
        children: [
          Badge(
            position: BadgePosition.topEnd(top: -4, end: -8),
            animationDuration: const Duration(milliseconds: 300),
            animationType: BadgeAnimationType.fade,
            showBadge: quantityPackage > 0,
            badgeContent: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: FittedBox(
                child: Text(
                  quantityPackage.toString(),
                  style: AppTheme.white_14w600,
                ),
              ),
            ),
            badgeColor: AppTheme.red,
            child: Image.asset(
              imageAction,
              height: 62.h,
              width: 62.w,
            ),
          ),
          SizedBox(
            height: 7.h,
          ),
          Text(
            text,
            style: AppTheme.orange_14w600,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
