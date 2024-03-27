import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/authorize/authorize_delivery_view_model.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class AuthorizeDeliveryDialog extends StatefulWidget {
  final String cabinetName;
  final Delivery delivery;

  const AuthorizeDeliveryDialog({required this.cabinetName, required this.delivery, Key? key}) : super(key: key);

  @override
  State<AuthorizeDeliveryDialog> createState() => _AuthorizeDeliveryDialogState();
}

class _AuthorizeDeliveryDialogState extends BaseViewState<AuthorizeDeliveryDialog, AuthorizeDeliveryViewModel> {
  @override
  AuthorizeDeliveryViewModel createViewModel() => locator<AuthorizeDeliveryViewModel>();

  @override
  void loadArguments() {
    viewModel.cabinetName = widget.cabinetName;
    viewModel.delivery = widget.delivery;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        backgroundColor: Colors.white,
        insetPadding: EdgeInsets.symmetric(horizontal: 17.w),
        elevation: 0,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 44.h,
              ),
              Assets.images.imgAuthorizeWithBackground.image(
                width: 186.w,
                height: 123.h,
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                LocaleKeys.delivery_authorization_enter_phone_description.trans(),
                style: AppTheme.blackDark_20w600,
              ),
              SizedBox(
                height: 8.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35.w),
                child: Text(
                  LocaleKeys.delivery_authorization_enter_phone_number_authorized.trans(),
                  style: AppTheme.blackDark_16w400,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.delivery_authorization_phone_number.trans(),
                        style: AppTheme.greyRussian_14w700,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      SizedBox(
                        height: 49.h,
                        child: TextField(
                          controller: viewModel.phoneController,
                          focusNode: viewModel.focusNode,
                          keyboardType: TextInputType.phone,
                          onChanged: viewModel.setPhoneNumberAuthorize,
                          onSubmitted: viewModel.onSubmitText,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey, width: 0.5),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            suffixIcon: GestureDetector(
                              onTap: viewModel.onNavigatePhoneNumberPickerPage,
                              child: Padding(
                                padding: EdgeInsets.only(right: 5.w),
                                child: Assets.icons.icDeliveryInfoPerson.image(
                                  color: AppTheme.greyRussian,
                                  width: 22.w,
                                  height: 16.h,
                                ),
                              ),
                            ),
                            isDense: true,
                            suffixIconConstraints: BoxConstraints(
                              maxWidth: 27.w,
                              maxHeight: 16.h,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        LocaleKeys.delivery_authorization_full_name.trans(),
                        style: AppTheme.greyRussian_14w700,
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 13.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppTheme.grey.withOpacity(0.5), width: 0.5),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Text(
                              viewModel.authorizedName,
                              style: AppTheme.greyRussian_14w400,
                            ),
                            const Spacer(),
                            if (viewModel.isLoadingName)
                              SizedBox(
                                height: 24.h,
                                width: 24.h,
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
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 37.h,
              ),
              Divider(
                height: 1.h,
                color: AppTheme.grey.withOpacity(0.5),
                thickness: 1.w,
              ),
              SizedBox(
                height: 68.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: Get.back,
                        child: Center(
                          child: Text(
                            LocaleKeys.delivery_authorization_cancel.trans(),
                            style: AppTheme.blackDark_16w600,
                          ),
                        ),
                      ),
                    ),
                    VerticalDivider(
                      width: 1.w,
                      color: AppTheme.grey.withOpacity(0.5),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: viewModel.confirmAuthorization,
                        child: Center(
                          child: Text(
                            LocaleKeys.delivery_authorization_confirm.trans(),
                            style: AppTheme.orange_16w600,
                          ),
                        ),
                      ),
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
