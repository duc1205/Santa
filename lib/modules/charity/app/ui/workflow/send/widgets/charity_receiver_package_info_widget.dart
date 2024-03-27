import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/charity/domain/models/charity.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class CharityReceiverPackageInfoWidget extends StatefulWidget {
  final Function() findUserByPhoneNumber;
  final Function(String) setPhoneNumber;
  final Function(String) setNote;
  final String phoneNumber;
  final String userName;
  final String charityName;
  final String charityCampaignName;
  final String cabinetName;
  final bool loadingName;

  const CharityReceiverPackageInfoWidget({
    Key? key,
    required this.cabinetName,
    required this.findUserByPhoneNumber,
    required this.setPhoneNumber,
    required this.setNote,
    required this.phoneNumber,
    required this.userName,
    required this.charityName,
    required this.charityCampaignName,
    required this.loadingName,
  }) : super(key: key);

  @override
  State<CharityReceiverPackageInfoWidget> createState() => _CharityReceiverInfoWidgetState();
}

class _CharityReceiverInfoWidgetState extends State<CharityReceiverPackageInfoWidget> {
  final TextEditingController _noteController = TextEditingController(text: "");
  final FocusNode _focusPhone = FocusNode();

  Charity? charity;

  @override
  void initState() {
    _focusPhone.addListener(() async {
      if (!_focusPhone.hasFocus) {
        widget.findUserByPhoneNumber();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusPhone.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                LocaleKeys.charity_receiver_phone_number.trans(),
                style: AppTheme.orange_14bold,
              ),
              Text(
                "*",
                style: AppTheme.red_20,
              ),
            ],
          ),
          SizedBox(
            height: 6.h,
          ),
          Row(
            children: [
              Text(
                widget.phoneNumber,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Divider(
            height: 1.h,
            thickness: 1.w,
            color: AppTheme.borderLight,
          ),
          SizedBox(
            height: 16.h,
          ),
          Text(
            LocaleKeys.charity_receiver_name.trans(),
            style: AppTheme.orange_14bold,
          ),
          SizedBox(
            height: 6.h,
          ),
          Row(
            children: [
              Text(
                widget.userName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                ),
              ),
              const Spacer(),
              if (widget.loadingName)
                SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: const FittedBox(
                    child: CircularProgressIndicator(
                      color: AppTheme.orange,
                    ),
                  ),
                )
              else
                const SizedBox(),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Divider(
            height: 1.h,
            thickness: 1.w,
            color: AppTheme.borderLight,
          ),
          SizedBox(
            height: 16.h,
          ),
          Text(
            LocaleKeys.charity_charity_org.trans(),
            style: AppTheme.orange_14bold,
          ),
          SizedBox(
            height: 6.h,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.charityName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.loadingName)
                SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: const FittedBox(
                    child: CircularProgressIndicator(
                      color: AppTheme.orange,
                    ),
                  ),
                )
              else
                const SizedBox(),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Divider(
            height: 1.h,
            thickness: 1.w,
            color: AppTheme.borderLight,
          ),
          SizedBox(
            height: 16.h,
          ),
          Text(
            LocaleKeys.charity_charity_campaign.trans(),
            style: AppTheme.orange_14bold,
          ),
          SizedBox(
            height: 6.h,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.charityCampaignName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.loadingName)
                SizedBox(
                  height: 20.h,
                  width: 20.h,
                  child: const FittedBox(
                    child: CircularProgressIndicator(
                      color: AppTheme.orange,
                    ),
                  ),
                )
              else
                const SizedBox(),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Divider(
            height: 1.h,
            thickness: 1.w,
            color: AppTheme.borderLight,
          ),
          SizedBox(
            height: 16.h,
          ),
          Text(
            LocaleKeys.charity_note.trans(),
            style: AppTheme.orange_14bold,
          ),
          SizedBox(
            height: 6.h,
          ),
          TextField(
            controller: _noteController,
            onChanged: widget.setNote,
            style: AppTheme.blackDark_14,
            decoration: InputDecoration(
              hintText: LocaleKeys.charity_place_holder_note.trans(),
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 13.sp,
              ),
              contentPadding: EdgeInsets.only(bottom: 5.h),
              isDense: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.borderLight, width: 1.w),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.borderLight, width: 1.w),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
