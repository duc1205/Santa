import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/phone_number_picker/recent_receivers/widgets/charity_recent_receiver_item.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/phone_number_picker/recent_receivers/widgets/empty_recent_receiver.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/phone_number_picker/recent_receivers/widgets/recent_receiver_item.dart';
import 'package:santapocket/modules/shared/loadmore/load_more_view.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:santapocket/shared/listview/easy_listview.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class RecentReceiversPage extends StatelessWidget {
  const RecentReceiversPage({
    Key? key,
    required this.recentReceivers,
    required this.selectedUser,
    required this.onLoadMore,
    required this.canLoadMore,
    required this.onItemClick,
    required this.isFromCharity,
    required this.onSelect,
  }) : super(key: key);

  final List<User> recentReceivers;
  final User? selectedUser;
  final Function() onLoadMore;
  final bool canLoadMore;
  final Function(User) onItemClick;
  final bool isFromCharity;
  final Function(String, {String? name}) onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: EasyListView(
            padding: EdgeInsets.only(top: 13.h, bottom: 16.h),
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            scrollbarEnable: false,
            itemCount: recentReceivers.length,
            itemBuilder: (BuildContext context, int index) {
              return isFromCharity
                  ? CharityRecentReceiverItem(
                      user: recentReceivers[index],
                      onItemClick: () => onItemClick(recentReceivers[index]),
                      selected: selectedUser?.id == recentReceivers[index].id,
                    )
                  : RecentReceiverItem(
                      user: recentReceivers[index],
                      onItemClick: () => onItemClick(recentReceivers[index]),
                      selected: selectedUser?.id == recentReceivers[index].id,
                    );
            },
            loadMore: canLoadMore,
            onLoadMore: onLoadMore,
            loadMoreItemBuilder: (context) => const LoadMoreView(),
            placeholderWidget: const EmptyRecentReceiver(),
          ),
        ),
        Visibility(
          visible: selectedUser != null,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 50.h,
              margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
              child: SizedBox.expand(
                child: ElevatedButton(
                  onPressed: () {
                    onSelect(selectedUser?.phoneNumber ?? "");
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      LocaleKeys.delivery_select.trans(),
                      style: AppTheme.white_16w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
