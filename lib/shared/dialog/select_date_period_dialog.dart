import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/shared/dialog/sg_alert_dialog.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class SelectDatePeriodDialog extends StatefulWidget {
  final DatePeriod selectedPeriod;
  final Function(DatePeriod) onSaveDateRange;
  final Function(DatePeriod)? onChangeDateRange;
  final Function()? onCancel;

  const SelectDatePeriodDialog({
    Key? key,
    required this.selectedPeriod,
    required this.onSaveDateRange,
    this.onChangeDateRange,
    this.onCancel,
  }) : super(key: key);

  @override
  State<SelectDatePeriodDialog> createState() => _SelectDateDialogState();
}

class _SelectDateDialogState extends State<SelectDatePeriodDialog> {
  DatePeriod datePeriod = DatePeriod(DateTime.now().subtract(const Duration(days: 1)), DateTime.now());

  final DatePickerRangeStyles styles = DatePickerRangeStyles(
    dayHeaderStyle: DayHeaderStyle(textStyle: AppTheme.yellow1_14w600),
    dayHeaderTitleBuilder: (date, _) {
      switch (date) {
        case 0:
          return "Sun";
        case 1:
          return "Mon";
        case 2:
          return "Tue";
        case 3:
          return "Wed";
        case 4:
          return "Thu";
        case 5:
          return "Fri";
        case 6:
          return "Sat";
        default:
          return "Sun";
      }
    },
    displayedPeriodTitle: AppTheme.blackDark_16w600,
    selectedPeriodLastDecoration: BoxDecoration(
      color: AppTheme.yellow1,
      borderRadius: BorderRadius.only(topRight: Radius.circular(20.r), bottomRight: Radius.circular(20.r)),
    ),
    selectedPeriodStartDecoration: BoxDecoration(
      color: AppTheme.yellow1,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r), bottomLeft: Radius.circular(20.r)),
    ),
    selectedSingleDateDecoration: BoxDecoration(
      color: AppTheme.yellow1,
      borderRadius: BorderRadius.all(Radius.circular(20.r)),
    ),
    selectedPeriodMiddleDecoration: const BoxDecoration(color: AppTheme.lumberOrange),
  );

  @override
  void initState() {
    datePeriod = widget.selectedPeriod;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SGAlertDialog alertDialog = SGAlertDialog(
      bodyViewDistance: 10.h,
      bodyView: RangePicker(
        datePickerStyles: styles,
        firstDate: DateTime.now().add(const Duration(days: -360)),
        lastDate: DateTime.now().add(const Duration(minutes: 1)),
        selectedPeriod: datePeriod,
        onChanged: (period) {
          setState(() {
            widget.onChangeDateRange?.call(period);
            datePeriod = period;
          });
        },
      ),
      cancelButton: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: 15.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          backgroundColor: AppTheme.border,
        ),
        onPressed: () {
          Get.back();
          widget.onCancel?.call();
        },
        child: Text(
          LocaleKeys.shared_cancel.trans(),
          style: AppTheme.white_14w600,
        ),
      ),
      confirmButton: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(
            vertical: 15.h,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          backgroundColor: AppTheme.orange,
        ),
        onPressed: () => widget.onSaveDateRange(datePeriod),
        child: Text(
          LocaleKeys.shared_done.trans(),
          style: AppTheme.white_14w600,
        ),
      ),
    );
    alertDialog.hideTitle();
    return alertDialog;
  }
}
