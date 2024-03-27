import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/modules/delivery/app/ui/detail/delivery_detail_page.dart';
import 'package:santapocket/modules/delivery/app/ui/history/widgets/delivery_history_item_view.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_type.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/shared/loadmore/load_more_view.dart';
import 'package:santapocket/shared/listview/easy_listview.dart';

class DeliveryHistoryListView extends StatefulWidget {
  final List<Delivery> deliveries;
  final bool isLoadMoreEnable;
  final VoidCallback onLoadMore;
  final int userId;

  const DeliveryHistoryListView({
    required this.deliveries,
    required this.userId,
    this.isLoadMoreEnable = false,
    required this.onLoadMore,
    Key? key,
  }) : super(key: key);

  @override
  State<DeliveryHistoryListView> createState() => _DeliveryHistoryListViewState();
}

class _DeliveryHistoryListViewState extends State<DeliveryHistoryListView> {
  @override
  Widget build(BuildContext context) {
    return EasyListView(
      padding: EdgeInsets.only(bottom: 16.h),
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      scrollbarEnable: false,
      itemCount: widget.deliveries.length,
      itemBuilder: (BuildContext context, int index) {
        final delivery = widget.deliveries[index];
        return DeliveryHistoryItemView(
          delivery: delivery,
          isReceiver: widget.userId == delivery.receiverId,
          onItemClick: () {
            Get.to(() => DeliveryDetailPage(
                  deliveryId: delivery.id,
                  isCharity: delivery.type == DeliveryType.charity,
                ));
          },
        );
      },
      loadMore: widget.isLoadMoreEnable,
      onLoadMore: () {
        widget.onLoadMore();
      },
      loadMoreItemBuilder: (context) {
        return const LoadMoreView();
      },
    );
  }
}
