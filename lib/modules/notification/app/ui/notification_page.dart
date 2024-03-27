import 'package:badges/badges.dart';
import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/notification/app/ui/notification_page_viewmodel.dart';
import 'package:santapocket/modules/notification/app/ui/widgets/notification_list_view.dart';
import 'package:santapocket/modules/notification/app/ui/widgets/system_notification_list_view.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends BaseViewState<NotificationPage, NotificationPageViewModel> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    viewModel.initTabController(this);
  }

  @override
  NotificationPageViewModel createViewModel() => locator<NotificationPageViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 2.5,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          LocaleKeys.notification_notification.trans().toUpperCase(),
          style: AppTheme.black_16bold,
        ),
        actions: [
          Obx(
            () => Visibility(
              visible: viewModel.isHaveUnread,
              child: GestureDetector(
                onTap: viewModel.readAllNotifications,
                child: Container(
                  margin: EdgeInsets.only(right: 16.w),
                  child: Assets.icons.icNotificationReadAll.image(
                    width: 24.w,
                    height: 24.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.0),
              border: const Border(bottom: BorderSide(color: AppTheme.line2, width: 2)),
            ),
            child: TabBar(
              padding: EdgeInsets.only(top: 8.h),
              controller: viewModel.tabController,
              onTap: viewModel.onChangeTab,
              unselectedLabelColor: AppTheme.grey,
              indicatorColor: AppTheme.orange,
              labelColor: AppTheme.orange,
              labelStyle: AppTheme.yellow1_14w400,
              tabs: [
                Obx(
                  () => Tab(
                    icon: Badge(
                      shape: viewModel.countUnread > 99 ? BadgeShape.square : BadgeShape.circle,
                      position: BadgePosition.topEnd(top: -12.h, end: viewModel.countUnread > 99 ? -35.w : -17.w),
                      badgeColor: AppTheme.red,
                      elevation: 0,
                      showBadge: viewModel.countUnread != 0,
                      badgeContent: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                        child: Text(
                          (viewModel.countUnread > 99 ? "99+" : viewModel.countUnread).toString(),
                          style: AppTheme.white_12,
                        ),
                      ),
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(10.r),
                      animationType: BadgeAnimationType.fade,
                      child: Text(LocaleKeys.notification_personal.trans()),
                    ),
                  ),
                ),
                Obx(
                  () => Tab(
                    icon: Badge(
                      shape: viewModel.countSystemUnread > 99 ? BadgeShape.square : BadgeShape.circle,
                      position: BadgePosition.topEnd(top: -12.h, end: viewModel.countSystemUnread > 99 ? -35.w : -17.w),
                      badgeColor: AppTheme.red,
                      animationType: BadgeAnimationType.fade,
                      elevation: 0,
                      showBadge: viewModel.countSystemUnread != 0,
                      badgeContent: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                        child: Text(
                          (viewModel.countSystemUnread > 99 ? "99+" : viewModel.countSystemUnread).toString(),
                          style: AppTheme.white_12,
                        ),
                      ),
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(10.r),
                      child: Text(LocaleKeys.notification_system.trans()),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() => RefreshIndicator(
                  onRefresh: viewModel.currentPage == 0 ? viewModel.onPersonalRefresh : viewModel.onSystemRefresh,
                  child: viewModel.currentPage == 0
                      ? NotificationListView(
                          notifications: viewModel.notifications,
                          viewModel: viewModel,
                          isLoadMoreEnable: viewModel.canLoadPersonalMore,
                          onLoadMore: viewModel.onLoadMore,
                        )
                      : SystemNotificationListView(
                          notifications: viewModel.systemNotifications,
                          viewModel: viewModel,
                          isLoadMoreEnable: viewModel.canLoadSystemMore,
                          onLoadMore: viewModel.onLoadMore,
                        ),
                )),
          ),
        ],
      ),
    );
  }
}
