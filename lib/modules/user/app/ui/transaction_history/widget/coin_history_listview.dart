import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/modules/user/app/ui/transaction_history/widget/coin_history_item_view.dart';
import 'package:santapocket/modules/user/domain/models/balance_log.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';

class CoinHistoryListView extends StatelessWidget {
  final List<BalanceLog> logs;
  final User? user;

  const CoinHistoryListView({
    Key? key,
    required this.logs,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return logs.isNotEmpty
        ? SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => CoinHistoryItemView(
                balanceLog: logs[index],
                currentUser: user,
              ),
              childCount: logs.length,
            ),
          )
        : SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.w,
              ).copyWith(top: 50.h),
              child: Assets.images.imgEmptyTransactionHistory.image(width: 115.w, height: 138.h),
            ),
          );
  }
}
