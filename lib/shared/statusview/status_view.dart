import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_status.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class StatusView extends StatelessWidget {
  final Color backgroundColor;
  final String statusText;

  // ignore: prefer_constructors_over_static_methods
  static StatusView createWithDeliveryStatus(DeliveryStatus? status, BuildContext context) {
    switch (status) {
      case DeliveryStatus.completed:
        return StatusView(backgroundColor: AppTheme.green, statusText: LocaleKeys.shared_completed.trans());
      case DeliveryStatus.created:
        return StatusView(
          backgroundColor: AppTheme.blueDark,
          statusText: LocaleKeys.shared_created.trans(),
        );
      case DeliveryStatus.received:
        return StatusView(
          backgroundColor: AppTheme.orange,
          statusText: LocaleKeys.shared_received.trans(),
        );
      case DeliveryStatus.sent:
        return StatusView(
          backgroundColor: AppTheme.orange,
          statusText: LocaleKeys.shared_sent.trans(),
        );
      case DeliveryStatus.receiving:
        return StatusView(
          backgroundColor: AppTheme.blue,
          statusText: LocaleKeys.shared_receiving.trans(),
        );
      case DeliveryStatus.sending:
        return StatusView(
          backgroundColor: AppTheme.blue,
          statusText: LocaleKeys.shared_sending.trans(),
        );
      case DeliveryStatus.failed:
        return StatusView(
          backgroundColor: AppTheme.red,
          statusText: LocaleKeys.shared_failed.trans(),
        );
      case DeliveryStatus.canceled:
        return StatusView(
          backgroundColor: AppTheme.black,
          statusText: LocaleKeys.shared_cancel.trans(),
        );
      default:
        return const StatusView();
    }
  }

  const StatusView({Key? key, this.backgroundColor = Colors.transparent, this.statusText = ''}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      height: 28,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(14.r), color: backgroundColor),
      child: Align(
        child: Text(
          statusText,
          style: AppTheme.white_12w600,
        ),
      ),
    );
  }
}
