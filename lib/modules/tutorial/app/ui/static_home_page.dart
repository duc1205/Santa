import 'dart:io';

import 'package:badges/badges.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/main/app/ui/home/widgets/welcome_widget.dart';
import 'package:santapocket/modules/main/app/ui/main_page.dart';
import 'package:santapocket/modules/notification/app/ui/notification_page.dart';
import 'package:santapocket/modules/payment/app/ui/payment_page.dart';
import 'package:santapocket/modules/tutorial/app/ui/helpers/tutorial_globalkey.dart';
import 'package:santapocket/modules/tutorial/app/ui/static_home_page_view_model.dart';
import 'package:santapocket/modules/tutorial/app/ui/widgets/tutorial_cabinet.dart';
import 'package:santapocket/modules/tutorial/app/ui/widgets/tutorial_delivery.dart';
import 'package:santapocket/modules/tutorial/app/ui/widgets/tutorial_free_usage.dart';
import 'package:santapocket/modules/tutorial/app/ui/widgets/tutorial_main.dart';
import 'package:santapocket/modules/tutorial/app/ui/widgets/tutorial_receive.dart';
import 'package:santapocket/modules/tutorial/app/ui/widgets/tutorial_rent.dart';
import 'package:santapocket/modules/tutorial/app/ui/widgets/tutorial_scan.dart';
import 'package:santapocket/modules/tutorial/app/ui/widgets/tutorial_send.dart';
import 'package:santapocket/modules/tutorial/app/ui/widgets/tutorial_topup.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class StaticHomePage extends StatefulWidget {
  static const routeName = "/StaticHomePage";

  const StaticHomePage({Key? key}) : super(key: key);

  @override
  State<StaticHomePage> createState() => _StaticHomePageState();
}

class _StaticHomePageState extends BaseViewState<StaticHomePage, StaticHomePageViewModel> {
  List<TargetFocus> targets = [];
  bool isDispose = false;

  late TutorialCoachMark tutorialCoachMark;
  bool isShowTutorial = false;

  @override
  StaticHomePageViewModel createViewModel() => locator<StaticHomePageViewModel>();

  void showTutorial(BuildContext context) {
    isShowTutorial = true;
    tutorialCoachMark.show(context: context);
  }

  @override
  void dispose() {
    super.dispose();
    isDispose = true;
    tutorialCoachMark.skip();
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black,
      hideSkip: true,
      alignSkip: Alignment.topLeft,
      skipWidget: Container(color: Colors.amber, child: Text(LocaleKeys.tutorial_skip_all.trans(), style: AppTheme.white_16w600)),
      paddingFocus: 0,
      opacityShadow: 0.8,
      onFinish: completeTutorial,
    );
  }

  void completeTutorial() {
    tutorialCoachMark.skip();
    if (!isDispose) {
      viewModel.completeTutorial();
      Get.until((route) => Get.currentRoute == MainPage.routeName);
    }
  }

  void onNextTutorialClick() {
    tutorialCoachMark.next();
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(tutorialMain(onNext: onNextTutorialClick, onSkip: completeTutorial));
    targets.add(tutorialFreeUsage(onNext: onNextTutorialClick, onSkip: completeTutorial));
    targets.add(tutorialSend(onNext: onNextTutorialClick, onSkip: completeTutorial));
    targets.add(tutorialReceive(onNext: onNextTutorialClick, onSkip: completeTutorial));
    targets.add(tutorialRent(onNext: onNextTutorialClick, onSkip: completeTutorial));
    targets.add(tutorialTopup(onNext: onNextTutorialClick, onSkip: completeTutorial));
    targets.add(tutorialScan(onNext: onNextTutorialClick, onSkip: completeTutorial));
    targets.add(tutorialCabinet(onNext: onNextTutorialClick, onSkip: completeTutorial));
    targets.add(tutorialDelivery(onNext: onNextTutorialClick, onSkip: completeTutorial));
    return targets;
  }

  @override
  void initState() {
    super.initState();
    createTutorial();
    showTutorial(context);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: const Color(0xffD1D1D1), width: 0.05.w),
          boxShadow: const [
            BoxShadow(
              color: Color(0xffFCEFDA),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 5),
            ),
          ],
        ),
        padding: EdgeInsets.all(3.w),
        child: FloatingActionButton(
          key: TutorialGlobalKey.tutorialScan,
          onPressed: () {},
          backgroundColor: AppTheme.orange,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Assets.icons.icHomeScan.image(
                width: 16.w,
                height: 16.h,
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                LocaleKeys.tutorial_scan.trans(),
                style: AppTheme.white_10w60,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Material(
        elevation: 10,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            30.w,
          ),
          topRight: Radius.circular(
            30.w,
          ),
        ),
        child: SizedBox(
          height: Platform.isAndroid ? 55.h : 73.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(
                          30.w,
                        ),
                      ),
                    ),
                    minWidth: 40.w,
                    focusColor: AppTheme.orange,
                    onPressed: () {},
                    child: Column(
                      children: [
                        SizedBox(
                          height: 7.h,
                        ),
                        Assets.icons.icBottomBarHome.image(height: 20.h, color: AppTheme.quickSliver),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          LocaleKeys.tutorial_home.trans(),
                          style: AppTheme.quickSliver_12w600,
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40.w,
                    onPressed: () {},
                    child: Column(
                      key: TutorialGlobalKey.tutorialCabinet,
                      children: [
                        SizedBox(
                          height: 7.h,
                        ),
                        Assets.icons.icBottomBarCabinet.image(height: 20.h, color: AppTheme.quickSliver),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          LocaleKeys.tutorial_cabinets.trans(),
                          style: AppTheme.quickSliver_12w600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  MaterialButton(
                    minWidth: 40.w,
                    onPressed: () {},
                    child: Column(
                      key: TutorialGlobalKey.tutorialDelivery,
                      children: [
                        SizedBox(
                          height: 7.h,
                        ),
                        Assets.icons.icBottomBarDeliveries.image(
                          height: 25.h,
                        ),
                        Text(
                          LocaleKeys.tutorial_deliveries.trans(),
                          style: AppTheme.quickSliver_12w600,
                        ),
                      ],
                    ),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(
                          30.w,
                        ),
                      ),
                    ),
                    minWidth: 40.w,
                    onPressed: () {},
                    child: Column(
                      children: [
                        SizedBox(
                          height: 7.h,
                        ),
                        Assets.icons.icBottomBarProfile.image(height: 20.h, color: AppTheme.quickSliver),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          LocaleKeys.tutorial_profile.trans(),
                          style: AppTheme.quickSliver_12w600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Column(
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
                    child: Assets.icons.icNotificationBadgeUnread.image(
                      fit: BoxFit.contain,
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
                    child: Container(
                      width: 345.w,
                      height: 160.h,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: AssetImage(Assets.images.imgBalanceBackgroundUsage.path), fit: BoxFit.fill),
                      ),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(top: 25.h, left: 21.w),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        width: 120.w,
                                        height: 21.h,
                                        child: FittedBox(
                                          child: Text(
                                            LocaleKeys.tutorial_total_balance.trans(),
                                            style: AppTheme.white_16w600Italic,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 4.h,
                                      ),
                                      SizedBox(
                                        width: 190.w,
                                        height: 36.h,
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: FittedBox(
                                            child: Text(
                                              FormatHelper.formatCurrency(0),
                                              style: AppTheme.white_27bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Get.to(() => const PaymentPage());
                                },
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: 119.w,
                                      height: 80.h,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 13.h, bottom: 6.h),
                                            child: ImageIcon(
                                              AssetImage(Assets.icons.icTopupWallet.path),
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(
                                            LocaleKeys.tutorial_top_up_xu.trans(),
                                            style: AppTheme.white_16,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          key: TutorialGlobalKey.tutorialTopup,
                                          height: 58.h,
                                          width: 50.w,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 19.w),
                            child: DottedLine(
                              lineThickness: 0.75.sp,
                              dashColor: Colors.white,
                            ),
                          ),
                          SizedBox(height: 3.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 19.w),
                            child: Divider(
                              height: 1.h,
                              color: Colors.white,
                            ),
                          ),
                          _freeUsageWidget(3),
                        ],
                      ),
                    ),
                  ),
                  // Display list action: send ,receive and rent pocket
                  Padding(
                    padding: EdgeInsets.only(left: 45.w, right: 45.w, bottom: 15.h),
                    child: _listActionButton(),
                  ),
                  const WelcomeWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Row _listActionButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _actionButton(
        key: TutorialGlobalKey.tutorialSend,
        text: LocaleKeys.tutorial_send.trans(),
        imageAction: Assets.icons.icHomeDriver.path,
        quantityPackage: 0,
        action: () {},
      ),
      _actionButton(
        key: TutorialGlobalKey.tutorialReceive,
        text: LocaleKeys.tutorial_receive.trans(),
        imageAction: Assets.icons.icHomeReceive.path,
        quantityPackage: 0,
        action: () {},
      ),
      _actionButton(
        key: TutorialGlobalKey.tutorialRent,
        text: LocaleKeys.tutorial_rent.trans(),
        imageAction: Assets.icons.icHomeRent.path,
        action: () {},
      ),
    ],
  );
}

Widget _freeUsageWidget(int freeUsage) {
  return Padding(
    padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 9.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          LocaleKeys.tutorial_free_usage_promo.trans(),
          style: AppTheme.white_16w600Italic,
        ),
        Text(
          key: TutorialGlobalKey.tutorialFreeUsage,
          freeUsage.toString(),
          style: AppTheme.white_27bold,
        ),
      ],
    ),
  );
}

Widget _actionButton({
  required String text,
  required String imageAction,
  required VoidCallback action,
  required GlobalKey key,
  int quantityPackage = 0,
}) {
  return InkWell(
    onTap: action,
    child: SizedBox(
      key: key,
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
