import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/hrm_payroll/domain/models/payroll_log.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class HrmPayrollDetailTransactionItem extends StatelessWidget {
  final PayrollLog payrollLog;
  const HrmPayrollDetailTransactionItem({super.key, required this.payrollLog});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 12.h,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Row(
            children: [
              Assets.icons.icHrmPayrollDetailDeduction.image(),
              SizedBox(
                width: 15.w,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      LocaleKeys.hrm_payroll_xu_change_deduction.trans(),
                      style: AppTheme.black_14w600,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      FormatHelper.formatCreatedDate(payrollLog.createdAt),
                      style: AppTheme.grey_14w400,
                    ),
                  ],
                ),
              ),
              Text("-${FormatHelper.formatCurrency(payrollLog.amount, unit: "đ").removeWhitespaces()}", style: AppTheme.black_14w600),
            ],
          ),
        ),
        SizedBox(
          height: 12.h,
        ),
        const Divider(),
      ],
    );
  }
}
