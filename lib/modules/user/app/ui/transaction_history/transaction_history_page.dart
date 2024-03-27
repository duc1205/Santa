import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/shared/loadmore/load_more_view.dart';
import 'package:santapocket/modules/user/app/ui/transaction_history/transaction_history_page_view_model.dart';
import 'package:santapocket/modules/user/app/ui/transaction_history/widget/coin_balance_widget.dart';
import 'package:santapocket/modules/user/app/ui/transaction_history/widget/coin_history_listview.dart';
import 'package:santapocket/modules/user/app/ui/transaction_history/widget/cone_balance_widget.dart';
import 'package:santapocket/modules/user/app/ui/transaction_history/widget/cone_history_listview.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class TransactionHistoryPage extends StatefulWidget {
  final bool isConeTab;

  const TransactionHistoryPage({
    Key? key,
    this.isConeTab = false,
  }) : super(key: key);

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends BaseViewState<TransactionHistoryPage, TransactionHistoryPageViewModel> {
  @override
  void loadArguments() {
    viewModel.initIsConeTab = widget.isConeTab;
    super.loadArguments();
  }

  @override
  TransactionHistoryPageViewModel createViewModel() => locator<TransactionHistoryPageViewModel>();

  List<Widget> _buildFilterTab(int selectedTab, Function(int index) onTap) {
    return List.generate(3, (index) {
      String label = LocaleKeys.user_all.trans();
      switch (index) {
        case 0:
          label = LocaleKeys.user_all.trans();
          break;
        case 1:
          label = LocaleKeys.user_earnings.trans();
          break;
        case 2:
          label = LocaleKeys.user_spending.trans();
          break;
      }
      return Expanded(
        child: InkWell(
          onTap: () {
            if (index != selectedTab) {
              onTap(index);
            }
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selectedTab == index ? AppTheme.orange : AppTheme.line2,
                  width: 2.h,
                ),
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: selectedTab == index ? AppTheme.orange_14w600 : AppTheme.grey_14w600,
              ),
            ),
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          LocaleKeys.user_transactions.trans().toUpperCase(),
          style: AppTheme.black_16w600,
        ),
        elevation: 0.5,
        centerTitle: true,
        backgroundColor: AppTheme.yellow1,
        iconTheme: const IconThemeData(color: AppTheme.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 14.h,
          ),
          Container(
            width: 186.w,
            padding: EdgeInsets.all(2.w),
            decoration: BoxDecoration(
              color: AppTheme.commercialWhite,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Obx(
                  () => Expanded(
                    child: InkWell(
                      onTap: (viewModel.isConeTab) ? () => viewModel.setIsConeTab = false : null,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        alignment: Alignment.center,
                        decoration: viewModel.isConeTab ? null : BoxDecoration(color: AppTheme.white, borderRadius: BorderRadius.circular(8.r)),
                        child: Text(
                          "Xu",
                          style: AppTheme.blackDark_14w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => Expanded(
                    child: InkWell(
                      onTap: (!viewModel.isConeTab) ? () => viewModel.setIsConeTab = true : null,
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        decoration: viewModel.isConeTab ? BoxDecoration(color: AppTheme.white, borderRadius: BorderRadius.circular(8.r)) : null,
                        alignment: Alignment.center,
                        child: Text(
                          LocaleKeys.user_cone.trans(),
                          style: AppTheme.blackDark_14w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h),
            child: Obx(
              () => viewModel.isConeTab
                  ? ConeBalanceWidget(
                      coin: viewModel.user?.cone ?? 0,
                    )
                  : CoinBalanceWidget(
                      balance: viewModel.user?.gem ?? 0,
                    ),
            ),
          ),
          Obx(
            () => Row(
              children: _buildFilterTab(viewModel.filterTabIndex, viewModel.onChangeTap),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await viewModel.onRefresh();
              },
              child: Obx(
                () => CustomScrollView(
                  controller: viewModel.scrollController,
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  shrinkWrap: true,
                  slivers: [
                    viewModel.isConeTab
                        ? ConeHistoryListView(
                            logs: viewModel.coneLogs,
                            user: viewModel.user,
                          )
                        : CoinHistoryListView(
                            logs: viewModel.balanceLogs,
                            user: viewModel.user,
                          ),
                    SliverToBoxAdapter(
                      child: viewModel.isLoadingMore ? const LoadMoreView() : Container(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
