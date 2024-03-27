import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/hrm_payroll/app/ui/result/hrm_payroll_success_page_viewmodel.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class HrmPayrollSuccessPage extends StatefulWidget {
  const HrmPayrollSuccessPage({super.key});

  @override
  State<HrmPayrollSuccessPage> createState() => _HrmPayrollSuccessPageState();
}

class _HrmPayrollSuccessPageState extends BaseViewState<HrmPayrollSuccessPage, HrmPayrollSuccessPageViewmodel> {
  @override
  HrmPayrollSuccessPageViewmodel createViewModel() => locator<HrmPayrollSuccessPageViewmodel>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: Assets.images.imgHrmSuccessBackground.image()),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    LocaleKeys.hrm_payroll_connect_completed.trans(),
                    style: AppTheme.green_24w600,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: GestureDetector(
                onTap: () => viewModel.onGetStartClicked(),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: AppTheme.yellow1,
                  ),
                  child: Center(child: Text(LocaleKeys.hrm_payroll_let_go.trans(), style: AppTheme.white_14w600)),
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
          ],
        ),
      ),
    );
  }
}
