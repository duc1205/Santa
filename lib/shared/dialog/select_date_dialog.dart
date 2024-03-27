import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class SelectDateDialog extends StatefulWidget {
  final DateTime selectedDate;
  final Function(DateTime selectedDate) onDoneButtonClicked;
  final Function() onCancelButtonClicked;

  const SelectDateDialog({Key? key, required this.selectedDate, required this.onDoneButtonClicked, required this.onCancelButtonClicked})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<SelectDateDialog> createState() => _SelectDateDialogState(selectedDate);
}

class _SelectDateDialogState extends State<SelectDateDialog> {
  DateTime selectedDate;
  DateTime _currentDateTable = DateTime.now();

  _SelectDateDialogState(this.selectedDate);

  @override
  void initState() {
    super.initState();
    _currentDateTable = selectedDate;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.r),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: CalendarCarousel(
              isScrollable: false,
              customGridViewPhysics: const NeverScrollableScrollPhysics(),
              weekFormat: false,
              height: 375.h,
              onDayPressed: (DateTime date, List<Event> events) {
                if (date.year == _currentDateTable.year && date.month == _currentDateTable.month) {
                  setState(() => selectedDate = date);
                }
              },
              onCalendarChanged: (datetime) {
                _currentDateTable = datetime;
              },
              firstDayOfWeek: 1,
              iconColor: AppTheme.blackDark,
              selectedDateTime: selectedDate,
              daysHaveCircularBorder: true,
              weekendTextStyle: AppTheme.black_14,
              daysTextStyle: AppTheme.black_14,
              weekdayTextStyle: AppTheme.orange_14w600,
              todayTextStyle: AppTheme.black_14,
              todayBorderColor: Colors.transparent,
              todayButtonColor: Colors.transparent,
              headerTextStyle: AppTheme.black_18,
              selectedDayTextStyle: AppTheme.white_14,
              selectedDayBorderColor: AppTheme.orange,
              selectedDayButtonColor: AppTheme.orange,
            ),
          ),
          Container(
            width: double.infinity,
            height: 1.h,
            color: const Color(0xFFE3EBF6),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextButton(
                  onPressed: () {
                    widget.onCancelButtonClicked();
                  },
                  child: Text(
                    "Cancel",
                    style: AppTheme.black_16w600,
                  ),
                ),
              ),
              Container(
                width: 1.w,
                height: 65.h,
                color: const Color(0xFFE3EBF6),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    widget.onDoneButtonClicked(selectedDate);
                  },
                  child: Text(
                    "Done",
                    style: AppTheme.orange_16w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
