import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/hrm_payroll/app/ui/detail/hrm_payroll_detail_page_viewmodel.dart';
import 'package:santapocket/modules/hrm_payroll/app/ui/detail/widgets/hrm_payroll_detail_transaction_item.dart';
import 'package:santapocket/modules/shared/loadmore/load_more_view.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class HrmPayrollDetailPage extends StatefulWidget {
  const HrmPayrollDetailPage({super.key});

  @override
  State<HrmPayrollDetailPage> createState() => _HrmPayrollDetailPageState();
}

class _HrmPayrollDetailPageState extends BaseViewState<HrmPayrollDetailPage, HrmPayrollDetailPageViewmodel> {
  @override
  HrmPayrollDetailPageViewmodel createViewModel() => locator<HrmPayrollDetailPageViewmodel>();

  @override
  void loadArguments() {
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(LocaleKeys.hrm_payroll_santa_payroll.trans().toUpperCase()),
        backgroundColor: AppTheme.goldishOrange,
        actions: [
          GestureDetector(
            onTap: () => viewModel.showBottomSheetBalanceNotEnoughReceive(),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 15.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                height: 15,
                decoration: BoxDecoration(color: AppTheme.appleChocolateOrange, borderRadius: BorderRadius.circular(20.r)),
                child: const Icon(Icons.more_horiz),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => viewModel.refreshPayrolls(),
        child: CustomScrollView(
          controller: viewModel.scrollController,
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: [
                    Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 161.h,
                          child: Assets.images.imgHrmDetailBackground.image(fit: BoxFit.cover),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 71.h),
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 15.w),
                            padding: EdgeInsets.all(15.sp),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.r),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.grey.withOpacity(0.15),
                                  blurRadius: 1,
                                  offset: const Offset(0, 1),
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      LocaleKeys.hrm_payroll_your_balance.trans(),
                                      style: AppTheme.windsorGrey_14w400,
                                    ),
                                    SizedBox(
                                      width: 6.w,
                                    ),
                                    Obx(
                                      () => GestureDetector(
                                        onTap: () => viewModel.onRevealWalletClicked(),
                                        child: Icon(
                                          viewModel.isRevealWallet ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                          color: AppTheme.windsorGrey,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    Obx(
                                      () => Container(
                                        padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 8.w),
                                        decoration: BoxDecoration(
                                          color: AppTheme.radiantGlow,
                                          borderRadius: BorderRadius.circular(20.r),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(FormatHelper.formatCurrency(viewModel.userCoin, unit: ''), style: AppTheme.goldishOrange_14w600),
                                            SizedBox(
                                              width: 2.w,
                                            ),
                                            Assets.icons.icSantaCoin.image(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Obx(
                                  () => Text(
                                    viewModel.isRevealWallet
                                        ? "**********"
                                        : FormatHelper.formatCurrency(
                                            viewModel.userSalary,
                                          ).removeWhitespaces(),
                                    style: AppTheme.blackDark_24w600,
                                  ),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                GestureDetector(
                                  onTap: () => viewModel.getToTopupPage(),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 15.h),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.r),
                                      color: AppTheme.yellow1,
                                    ),
                                    child: Center(
                                      child: Text(
                                        LocaleKeys.hrm_payroll_top_up.trans(),
                                        style: AppTheme.white_14w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 21.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          LocaleKeys.hrm_payroll_recent_transaction.trans(),
                          style: AppTheme.black_16w600,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Obx(
                      () => viewModel.payrollLogs.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) => HrmPayrollDetailTransactionItem(payrollLog: viewModel.payrollLogs[index]),
                              itemCount: viewModel.payrollLogs.length,
                            )
                          : Padding(
                              padding: EdgeInsets.only(top: 39.h),
                              child: Assets.images.imgEmptyTransactionHistory.image(width: 115.w, height: 138.h),
                            ),
                    ),
                  ],
                ),
              ]),
            ),
            Obx(
              () => SliverToBoxAdapter(
                child: viewModel.isLoadingMore ? const LoadMoreView() : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
