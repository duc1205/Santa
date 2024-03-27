import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/charity/app/ui/charity_history/charity_delivery_history_page.dart';
import 'package:santapocket/modules/charity/app/ui/charity_page_viewmodel.dart';
import 'package:santapocket/modules/charity/app/ui/charity_scan/charity_scan_page.dart';
import 'package:santapocket/modules/user/app/ui/app_info/web_view_page.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class CharityPage extends StatefulWidget {
  static const routeName = "/CharityPage";
  const CharityPage({super.key});

  @override
  State<CharityPage> createState() => _CharityPageState();
}

class _CharityPageState extends BaseViewState<CharityPage, CharityPageViewModel> {
  int _selectedPageIndex = 0;

  late PageController _pageController;

  @override
  CharityPageViewModel createViewModel() => locator<CharityPageViewModel>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedPageIndex);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.pearchBurst,
        title: Text(LocaleKeys.charity_title.trans().toUpperCase(), style: AppTheme.black_16w600),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Obx(
            () => Visibility(
              visible: viewModel.helpCenterUrl.trim().isNotEmpty,
              child: GestureDetector(
                onTap: () => Get.to(() => WebViewPage(url: viewModel.helpCenterUrl)),
                child: Assets.icons.icReferralQuestionMark.image(),
              ),
            ),
          ),
        ],
        automaticallyImplyLeading: true,
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          CharityScanPage(),
          CharityDeliveryHistoryPage(),
        ],
      ),
      bottomNavigationBar: Material(
        elevation: 10,
        child: SizedBox(
          height: Platform.isAndroid ? 62.h : 80.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                minWidth: 40.w,
                onPressed: () => _onTabTapped(0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 7.h,
                    ),
                    if (_selectedPageIndex == 0)
                      Assets.icons.icBottomBarCharityActive.image(
                        height: 25.h,
                      )
                    else
                      Assets.icons.icBottomBarCharity.image(
                        height: 25.h,
                      ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Text(
                      LocaleKeys.charity_donate.trans(),
                      style: _selectedPageIndex == 0 ? AppTheme.orange_12w400 : AppTheme.quickSliver_12w400,
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
                    if (_selectedPageIndex == 1)
                      Assets.icons.icBottomBarCharityHistoryActive.image(
                        height: 25.h,
                      )
                    else
                      Assets.icons.icBottomBarCharityHistory.image(
                        height: 25.h,
                      ),
                    SizedBox(
                      height: 7.h,
                    ),
                    Text(
                      LocaleKeys.charity_donation_history.trans(),
                      style: _selectedPageIndex == 1 ? AppTheme.orange_12w400 : AppTheme.quickSliver_12w400,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
