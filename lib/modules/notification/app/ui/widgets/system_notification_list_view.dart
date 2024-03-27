import 'package:flutter/material.dart' hide Notification;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/modules/notification/app/ui/notification_page_viewmodel.dart';
import 'package:santapocket/modules/notification/app/ui/widgets/notification_empty_view.dart';
import 'package:santapocket/modules/notification/app/ui/widgets/system_notification_item.dart';
import 'package:santapocket/modules/notification/domain/models/system_notification.dart';
import 'package:santapocket/modules/shared/loadmore/load_more_view.dart';
import 'package:santapocket/shared/listview/easy_listview.dart';

class SystemNotificationListView extends StatelessWidget {
  final List<SystemNotification> notifications;
  final bool isLoadMoreEnable;
  final VoidCallback? onLoadMore;
  final NotificationPageViewModel viewModel;

  const SystemNotificationListView({
    Key? key,
    required this.notifications,
    required this.viewModel,
    this.isLoadMoreEnable = false,
    this.onLoadMore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyListView(
      padding: EdgeInsets.only(
        bottom: 16.h,
      ),
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      scrollbarEnable: false,
      itemCount: notifications.length,
      itemBuilder: (context, index) => SystemNotificationItem(
        isUnRead: index + 1 <= viewModel.countSystemUnread,
        notification: notifications[index],
        viewModel: viewModel,
      ),
      loadMore: isLoadMoreEnable,
      onLoadMore: () => onLoadMore?.call(),
      placeholderWidget: const NotificationEmptyView(),
      loadMoreItemBuilder: (context) {
        return const LoadMoreView();
      },
    );
  }
}
