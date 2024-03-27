import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/modules/notification/app/ui/notification_page_viewmodel.dart';
import 'package:santapocket/modules/notification/app/ui/widgets/notification_empty_view.dart';
import 'package:santapocket/modules/notification/app/ui/widgets/notification_item.dart';
import 'package:santapocket/modules/notification/domain/models/notification.dart';
import 'package:santapocket/modules/shared/loadmore/load_more_view.dart';
import 'package:santapocket/shared/listview/easy_listview.dart';

class NotificationListView extends StatefulWidget {
  final List<Notification> notifications;
  final bool isLoadMoreEnable;
  final VoidCallback? onLoadMore;
  final NotificationPageViewModel viewModel;

  const NotificationListView({
    Key? key,
    required this.notifications,
    required this.viewModel,
    this.isLoadMoreEnable = false,
    this.onLoadMore,
  }) : super(key: key);

  @override
  State<NotificationListView> createState() => _NotificationListViewState();
}

class _NotificationListViewState extends State<NotificationListView> {
  @override
  Widget build(BuildContext context) {
    return EasyListView(
      padding: EdgeInsets.only(
        bottom: 16.h,
      ),
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      scrollbarEnable: false,
      itemCount: widget.notifications.length,
      itemBuilder: (context, index) => NotificationItem(
        notification: widget.notifications[index],
        viewModel: widget.viewModel,
      ),
      loadMore: widget.isLoadMoreEnable,
      onLoadMore: () {
        if (widget.onLoadMore != null) {
          widget.onLoadMore!();
        } else {}
      },
      placeholderWidget: const NotificationEmptyView(),
      loadMoreItemBuilder: (context) {
        return const LoadMoreView();
      },
    );
  }
}
