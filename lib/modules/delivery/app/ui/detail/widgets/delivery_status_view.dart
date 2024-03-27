import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_status.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery_status_log.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class DeliveryStatusView extends StatelessWidget {
  final DeliveryStatusLog statusLog;
  final bool isLastStatus;

  const DeliveryStatusView({
    Key? key,
    required this.statusLog,
    required this.isLastStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (statusLog.status) {
      case DeliveryStatus.completed:
        return _statusView(
          backgroundColor: AppTheme.green,
          statusText: LocaleKeys.delivery_completed.trans(),
          isLastStatus: isLastStatus,
          createdAt: statusLog.createdAt,
        );
      case DeliveryStatus.created:
        return _statusView(
          backgroundColor: AppTheme.blueDark,
          statusText: LocaleKeys.delivery_created.trans(),
          isLastStatus: isLastStatus,
          createdAt: statusLog.createdAt,
        );
      case DeliveryStatus.received:
        return _statusView(
          backgroundColor: AppTheme.orange,
          statusText: LocaleKeys.delivery_received.trans(),
          isLastStatus: isLastStatus,
          createdAt: statusLog.createdAt,
        );
      case DeliveryStatus.sent:
        return _statusView(
          backgroundColor: AppTheme.orange,
          statusText: LocaleKeys.delivery_sent.trans(),
          isLastStatus: isLastStatus,
          createdAt: statusLog.createdAt,
        );
      case DeliveryStatus.receiving:
        return _statusView(
          backgroundColor: AppTheme.blue,
          statusText: LocaleKeys.delivery_receiving.trans(),
          isLastStatus: isLastStatus,
          createdAt: statusLog.createdAt,
        );
      case DeliveryStatus.sending:
        return _statusView(
          backgroundColor: AppTheme.blue,
          statusText: LocaleKeys.delivery_sending.trans(),
          isLastStatus: isLastStatus,
          createdAt: statusLog.createdAt,
        );
      case DeliveryStatus.failed:
        return _statusView(
          backgroundColor: AppTheme.red,
          statusText: LocaleKeys.delivery_failed.trans(),
          isLastStatus: isLastStatus,
          createdAt: statusLog.createdAt,
        );
      case DeliveryStatus.canceled:
        return _statusView(
          backgroundColor: AppTheme.black,
          statusText: LocaleKeys.delivery_cancel.trans(),
          isLastStatus: isLastStatus,
          createdAt: statusLog.createdAt,
        );
      default:
        return _statusView(
          backgroundColor: Colors.transparent,
          statusText: "",
          isLastStatus: isLastStatus,
          createdAt: statusLog.createdAt,
        );
    }
  }
}

Widget _statusView({required Color backgroundColor, required String statusText, required DateTime? createdAt, required bool isLastStatus}) {
  return Opacity(
    opacity: isLastStatus ? 1 : 0.5,
    child: Row(
      children: [
        SizedBox(
          width: 19.w,
        ),
        Container(
          width: 11.w,
          height: 11.h,
          decoration: BoxDecoration(
            color: isLastStatus ? backgroundColor.withOpacity(0.5) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 7.w,
              height: 7.h,
              decoration: BoxDecoration(
                color: isLastStatus ? backgroundColor : AppTheme.grey,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        SizedBox(
          width: 22.w,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.r), color: backgroundColor.withOpacity(isLastStatus ? 1 : 0.7)),
          child: Align(
            child: Text(
              statusText,
              style: AppTheme.white_12w600,
            ),
          ),
        ),
        const Spacer(),
        Text(
          createdAt != null ? FormatHelper.formatDate("dd/MM/yyyy, HH:mm", createdAt) : '',
          style: AppTheme.black_12,
        ),
        SizedBox(
          width: 21.w,
        ),
      ],
    ),
  );
}
