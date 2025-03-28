import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/shared/statusview/status_view.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class CharityDeliveryHistoryItemView extends StatelessWidget {
  final VoidCallback onItemClick;
  final Delivery delivery;
  final bool isReceiver;

  const CharityDeliveryHistoryItemView({Key? key, required this.delivery, required this.onItemClick, required this.isReceiver}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppTheme.linghDarkPink),
      child: InkWell(
        onTap: () {
          onItemClick();
        },
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(7.w), color: AppTheme.danger2),
                    padding: EdgeInsets.all(3.w),
                    child: Assets.icons.icCharityHistoryItem.image(fit: BoxFit.contain),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            FormatHelper.formatId(delivery.id),
                            style: AppTheme.black_16w600,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text(
                              FormatHelper.formatDate("dd/MM/yyyy, HH:mm", delivery.createdAt),
                              style: AppTheme.grey_12w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w),
                    child: StatusView.createWithDeliveryStatus(delivery.status, context),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 43.w, top: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "${LocaleKeys.charity_sender.trans()}:",
                        style: AppTheme.grey_14w400,
                        children: [
                          TextSpan(text: " ${delivery.sender?.phoneNumber ?? ""}", style: AppTheme.blackDark_14),
                          delivery.sender?.name != null
                              ? TextSpan(
                                  text: (delivery.sender?.name != null && delivery.sender!.name!.trim().isNotEmpty)
                                      ? " (${delivery.sender?.name})"
                                      : "",
                                  style: AppTheme.blackDark_14,
                                )
                              : const TextSpan(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    RichText(
                      text: TextSpan(
                        text: "${LocaleKeys.charity_receiver.trans()}:",
                        style: AppTheme.grey_14w400,
                        children: [
                          TextSpan(text: " ${delivery.receiver?.phoneNumber ?? ""}", style: AppTheme.blackDark_14),
                          delivery.receiver?.name != null
                              ? TextSpan(
                                  text: (delivery.receiver?.name != null && delivery.receiver!.name!.trim().isNotEmpty)
                                      ? " (${delivery.receiver?.name})"
                                      : "",
                                  style: AppTheme.blackDark_14,
                                )
                              : const TextSpan(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      "${delivery.cabinet?.name}",
                      style: AppTheme.blackDark_14,
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Text(
                      "${LocaleKeys.charity_pocket.trans()} ${delivery.pocket?.localId ?? 0}",
                      style: AppTheme.blackDark_14,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
