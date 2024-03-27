import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/firebase/fcm_manager.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/shortcuts_manager.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/app/ui/cabinet_list/cabinet_list_page.dart';
import 'package:santapocket/modules/delivery/app/ui/history/delivery_history_page.dart';
import 'package:santapocket/modules/main/app/enums/action_open_main.dart';
import 'package:santapocket/modules/main/app/ui/home/enums/action_scan.dart';
import 'package:santapocket/modules/main/app/ui/home/home_page.dart';
import 'package:santapocket/modules/main/app/ui/main_page_viewmodel.dart';
import 'package:santapocket/modules/main/app/ui/widgets/qr_scanner_page.dart';
import 'package:santapocket/modules/user/app/ui/profile/profile_page.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/MainPage';
  final ActionOpenMain actionOpenMain;

  const MainPage({Key? key, this.actionOpenMain = ActionOpenMain.openDirectMain}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends BaseViewState<MainPage, MainPageViewModel> {
  int _selectedPageIndex = 0;

  late PageController _pageController;

  @override
  MainPageViewModel createViewModel() => locator<MainPageViewModel>();

  @override
  void initState() {
    super.initState();
    locator<FCMManager>().config(context);
    init();
    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  Future<void> init() async {
    if (await viewModel.checkCompletedTutorial()) {
      ShortcutsManager.instance.initialShortcutActions(viewModel);
    }
    await viewModel.checkAndRequestNotificationPermission();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabTapped(int selectedPageIndex) {
    setState(() {
      _selectedPageIndex = selectedPageIndex;
      _pageController.jumpToPage(selectedPageIndex);
      FocusScope.of(context).unfocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedPageIndex != 0) {
          setState(() {
            _selectedPageIndex = 0;
          });
        }
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            HomePage(
              viewAllDelivery: _onTabTapped,
              firstInitMain: widget.actionOpenMain == ActionOpenMain.openDirectMain,
            ),
            const CabinetListPage(),
            const DeliveryHistoryPage(),
            const ProfilePage(),
          ],
        ),
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
            onPressed: () async {
              final barcode = await Get.to(
                () => const QRScannerPage(),
              );
              if (barcode != null) {
                await viewModel.handleQrCodeData(barcode: barcode as String, scan: ActionScan.scan);
              }
            },
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
                  LocaleKeys.main_scan.trans(),
                  style: AppTheme.white_10w60,
                ),
              ],
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Material(
          elevation: 10,
          child: SizedBox(
            height: Platform.isAndroid ? 55.h : 73.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    MaterialButton(
                      minWidth: 40.w,
                      focusColor: AppTheme.orange,
                      onPressed: () => _onTabTapped(0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 7.h,
                          ),
                          Assets.icons.icBottomBarHome.image(height: 20.h, color: _selectedPageIndex == 0 ? AppTheme.orange : AppTheme.quickSliver),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            LocaleKeys.main_home.trans(),
                            style: _selectedPageIndex == 0 ? AppTheme.orange_12w600 : AppTheme.quickSliver_12w600,
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40.w,
                      onPressed: () => _onTabTapped(1),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 7.h,
                          ),
                          Assets.icons.icBottomBarCabinet
                              .image(height: 20.h, color: _selectedPageIndex == 1 ? AppTheme.orange : AppTheme.quickSliver),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            LocaleKeys.main_cabinets.trans(),
                            style: _selectedPageIndex == 1 ? AppTheme.orange_12w600 : AppTheme.quickSliver_12w600,
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
                      onPressed: () => _onTabTapped(2),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 7.h,
                          ),
                          if (_selectedPageIndex == 2)
                            Assets.icons.icBottomBarDeliveriesActive.image(
                              height: 25.h,
                            )
                          else
                            Assets.icons.icBottomBarDeliveries.image(
                              height: 25.h,
                            ),
                          Text(
                            LocaleKeys.main_deliveries.trans(),
                            style: _selectedPageIndex == 2 ? AppTheme.orange_12w600 : AppTheme.quickSliver_12w600,
                          ),
                        ],
                      ),
                    ),
                    MaterialButton(
                      minWidth: 40.w,
                      onPressed: () => _onTabTapped(3),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 7.h,
                          ),
                          Assets.icons.icBottomBarProfile
                              .image(height: 20.h, color: _selectedPageIndex == 3 ? AppTheme.orange : AppTheme.quickSliver),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            LocaleKeys.main_profile.trans(),
                            style: _selectedPageIndex == 3 ? AppTheme.orange_12w600 : AppTheme.quickSliver_12w600,
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
      ),
    );
  }
}
