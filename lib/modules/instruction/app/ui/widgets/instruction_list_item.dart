import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/modules/instruction/app/ui/detail/instruction_detail_page.dart';
import 'package:santapocket/modules/instruction/domain/models/instruction.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class InstructionListItem extends StatelessWidget {
  final Instruction instruction;

  const InstructionListItem({Key? key, required this.instruction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Get.to(() => InstructionDetailPage(
            instruction: instruction,
          )),
      child: Padding(
        padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.w),
            color: AppTheme.orangeLight,
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                Text(
                  instruction.name ?? "",
                  style: AppTheme.blackDark_14,
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.grey,
                  size: 15.sp,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
