import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/phone_number_picker/phone_number_picker_page.dart';
import 'package:santapocket/shared/theme/app_theme.dart';

class ReceiverPackageInfoWidget extends StatefulWidget {
  final Function() findUserByPhoneNumber;
  final Function(String) setPhoneNumber;
  final Function(String) setNote;
  final String userName;
  final String cabinetName;
  final bool loadingName;

  const ReceiverPackageInfoWidget({
    Key? key,
    required this.cabinetName,
    required this.findUserByPhoneNumber,
    required this.setPhoneNumber,
    required this.setNote,
    required this.userName,
    required this.loadingName,
  }) : super(key: key);

  @override
  State<ReceiverPackageInfoWidget> createState() => _ReceiverInfoWidgetState();
}

class _ReceiverInfoWidgetState extends State<ReceiverPackageInfoWidget> {
  final TextEditingController _phoneController = TextEditingController(text: "");
  final TextEditingController _noteController = TextEditingController(text: "");
  final FocusNode _focusPhone = FocusNode();

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
    _phoneController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.h),
      decoration: BoxDecoration(
        color: AppTheme.orangeLight,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                LocaleKeys.delivery_receiver_phone_number.trans(),
                style: AppTheme.orange_14bold,
              ),
              Text(
                "*",
                style: AppTheme.red_20,
              ),
            ],
          ),
          TextField(
            controller: _phoneController,
            focusNode: _focusPhone,
            keyboardType: TextInputType.phone,
            onChanged: widget.setPhoneNumber,
            onSubmitted: (phone) async {
              widget.setPhoneNumber(phone);
              widget.findUserByPhoneNumber();
            },
            textInputAction: TextInputAction.done,
            style: AppTheme.blackDark_14,
            decoration: InputDecoration(
              hintText: LocaleKeys.delivery_receiver_phone_number_hint.trans(),
              hintStyle: AppTheme.borderlight_14w400,
              suffixIcon: GestureDetector(
                onTap: () {
                  Get.to(() => PhoneNumberPickerPage(
                        cabinetName: widget.cabinetName,
                        onSelect: (phone, {String? name}) {
                          _phoneController.text = phone;
                          widget.setPhoneNumber(phone);
                          if (phone.isNotEmpty) {
                            widget.findUserByPhoneNumber();
                          }
                        },
                      ));
                },
                child: Padding(
                  padding: EdgeInsets.only(right: 5.w, bottom: 5.h),
                  child: Assets.icons.icDeliveryInfoPerson.image(width: 24.w, height: 24.h),
                ),
              ),
              suffixIconConstraints: BoxConstraints(
                maxWidth: 24.w,
                maxHeight: 24.h,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 5.h),
              isDense: true,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.borderLight, width: 1.w),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppTheme.borderLight, width: 1.w),
              ),
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Text(
            LocaleKeys.delivery_receiver_name.trans(),
            style: AppTheme.orange_14bold,
          ),
          SizedBox(
            height: 5.h,
          ),
          Row(
            children: [
              Text(
                widget.userName,
                style: AppTheme.black_14w400,
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
            LocaleKeys.delivery_note.trans(),
            style: AppTheme.orange_14bold,
          ),
          TextField(
            controller: _noteController,
            onChanged: widget.setNote,
            style: AppTheme.blackDark_14,
            decoration: InputDecoration(
              hintText: LocaleKeys.delivery_place_holder_note.trans(),
              hintStyle: AppTheme.borderlight_14w400,
              contentPadding: EdgeInsets.symmetric(vertical: 5.h),
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
