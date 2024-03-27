import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/helpers/format_helper.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/pocket_state/guide_step_package_widget.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/shared/pocket_state/pocket_info_widget.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/receive_delivery_authorization/receive_delivery_authorization_state_page_viewmodel.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class ReceiveDeliveryAuthorizationStatePage extends StatefulWidget {
  const ReceiveDeliveryAuthorizationStatePage({Key? key, required this.deliveryAuthorizationId, required this.cabinetInfo, required this.isCharity})
      : super(key: key);

  final int deliveryAuthorizationId;
  final CabinetInfo cabinetInfo;
  final bool isCharity;

  @override
  State<ReceiveDeliveryAuthorizationStatePage> createState() => _ReceiveDeliveryAuthorizationStatePageState();
}

class _ReceiveDeliveryAuthorizationStatePageState
    extends BaseViewState<ReceiveDeliveryAuthorizationStatePage, ReceiveDeliveryAuthorizationStatePageViewModel> {
  @override
  ReceiveDeliveryAuthorizationStatePageViewModel createViewModel() => locator<ReceiveDeliveryAuthorizationStatePageViewModel>();

  @override
  void loadArguments() {
    viewModel.deliveryAuthorizationId = widget.deliveryAuthorizationId;
    viewModel.cabinetInfo = widget.cabinetInfo;
    viewModel.isCharity = widget.isCharity;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          elevation: 4.0,
          backgroundColor: Colors.white,
          title: Obx(
            () => Text(
              FormatHelper.formatId(viewModel.delivery?.id),
              style: AppTheme.black_18w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Obx(
                () => PocketInfoWidget(
                  delivery: viewModel.delivery,
                  pocketIsOpen: viewModel.isPocketOpen,
                  cabinetInfo: widget.cabinetInfo,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: const GuideStepPackageWidget(),
              ),
              SizedBox(
                height: 28.h,
              ),
              Container(
                height: 51.h,
                width: 348.w,
                padding: EdgeInsets.only(left: 26.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    stops: [0.015.w, 0.015.w],
                    colors: const [AppTheme.orange, Color(0xfff2f2f2)],
                  ),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: TapDebouncer(
                    onTap: () async => viewModel.onClickEndProcess(),
                    builder: (BuildContext context, TapDebouncerFunc? onTap) => RichText(
                      text: TextSpan(
                        text: LocaleKeys.delivery_authorization_click.trans(),
                        style: AppTheme.black_14,
                        children: [
                          TextSpan(
                            text: LocaleKeys.delivery_authorization_here.trans().toUpperCase(),
                            style: AppTheme.orange_16w600,
                            recognizer: TapGestureRecognizer()..onTap = onTap,
                          ),
                          TextSpan(text: LocaleKeys.delivery_authorization_finish_receive_description.trans(), style: AppTheme.black_14),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 94.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
