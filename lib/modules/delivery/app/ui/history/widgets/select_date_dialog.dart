import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/shared/dialog/sg_alert_dialog.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class SelectDateDialog extends StatefulWidget {
  final DatePeriod selectedPeriod;
  final Function(DatePeriod) onSaveDateRange;
  final Function(DatePeriod) onChangeDateRange;
  final Function()? onCancel;

  const SelectDateDialog({
    Key? key,
    required this.selectedPeriod,
    required this.onChangeDateRange,
    required this.onSaveDateRange,
    this.onCancel,
  }) : super(key: key);

  @override
  State<SelectDateDialog> createState() => _SelectDateDialogState();
}

class _SelectDateDialogState extends State<SelectDateDialog> {
  DatePeriod datePeriod = DatePeriod(DateTime.now().subtract(const Duration(days: 1)), DateTime.now());

  final DatePickerRangeStyles styles = DatePickerRangeStyles(
    selectedPeriodLastDecoration:
        BoxDecoration(color: AppTheme.orange, borderRadius: BorderRadius.only(topRight: Radius.circular(10.r), bottomRight: Radius.circular(10.r))),
    selectedPeriodStartDecoration: BoxDecoration(
      color: AppTheme.orange,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), bottomLeft: Radius.circular(10.r)),
    ),
    selectedSingleDateDecoration: BoxDecoration(
      color: AppTheme.orange,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), bottomLeft: Radius.circular(10.r)),
    ),
    selectedPeriodMiddleDecoration: const BoxDecoration(color: AppTheme.orangeA43),
  );

  @override
  void initState() {
    datePeriod = widget.selectedPeriod;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SGAlertDialog alertDialog = SGAlertDialog(
      bodyView: RangePicker(
        datePickerStyles: styles,
        firstDate: DateTime.now().add(const Duration(days: -360)),
        lastDate: DateTime.now().add(const Duration(minutes: 1)),
        selectedPeriod: datePeriod,
        onChanged: (period) {
          setState(() {
            widget.onChangeDateRange(period);
            datePeriod = period;
          });
        },
      ),
      onConfirmButtonClicked: () {
        widget.onSaveDateRange(datePeriod);
      },
      onCancelButtonClicked: widget.onCancel,
    );
    alertDialog.hideTitle();
    return alertDialog;
  }
}
