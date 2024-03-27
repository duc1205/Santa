import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/modules/charity/app/ui/charity_history/widgets/charity_delivery_history_item_view.dart';
import 'package:santapocket/modules/delivery/app/ui/detail/delivery_detail_page.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/delivery_authorization_detail/delivery_authorization_detail_page.dart';
import 'package:santapocket/modules/shared/loadmore/load_more_view.dart';
import 'package:santapocket/shared/listview/easy_listview.dart';

class CharityDeliveryHistoryListView extends StatefulWidget {
  final List<Delivery> deliveries;
  final bool isLoadMoreEnable;
  final VoidCallback onLoadMore;
  final int userId;
  final ScrollController scrollController;

  const CharityDeliveryHistoryListView({
    required this.deliveries,
    required this.userId,
    this.isLoadMoreEnable = false,
    required this.onLoadMore,
    required this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  State<CharityDeliveryHistoryListView> createState() => _DeliveryHistoryListViewState();
}

class _DeliveryHistoryListViewState extends State<CharityDeliveryHistoryListView> {
  @override
  Widget build(BuildContext context) {
    return EasyListView(
      controller: widget.scrollController,
      padding: EdgeInsets.only(bottom: 16.h),
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      scrollbarEnable: false,
      itemCount: widget.deliveries.length,
      itemBuilder: (BuildContext context, int index) {
        return CharityDeliveryHistoryItemView(
          delivery: widget.deliveries[index],
          isReceiver: widget.userId == (widget.deliveries[index].receiverId),
          onItemClick: () {
            Get.to(
              () => widget.deliveries[index].authorization != null && widget.userId == widget.deliveries[index].authorization?.userId
                  ? DeliveryAuthorizationDetailPage(
                      deliveryAuthorizationId: widget.deliveries[index].authorization!.id,
                      isCharity: true,
                    )
                  : DeliveryDetailPage(
                      deliveryId: widget.deliveries[index].id,
                      isCharity: true,
                    ),
            );
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
