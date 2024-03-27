import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/charity/app/ui/charity_cancel/cancel_charity_delivery_state_page_view.dart';
import 'package:santapocket/modules/delivery/app/ui/cancel/cancel_delivery_state_page_view_model.dart';
import 'package:santapocket/modules/delivery/app/ui/cancel/widgets/cancel_delivery_state_page_view.dart';
import 'package:santapocket/modules/delivery/domain/enums/delivery_type.dart';
import 'package:suga_core/suga_core.dart';

class CancelDeliveryStatePage extends StatefulWidget {
  const CancelDeliveryStatePage({Key? key, required this.deliveryId, required this.cabinetInfo}) : super(key: key);

  final int deliveryId;
  final CabinetInfo cabinetInfo;

  @override
  State<CancelDeliveryStatePage> createState() => _CancelDeliveryStatePageState();
}

class _CancelDeliveryStatePageState extends BaseViewState<CancelDeliveryStatePage, CancelDeliveryStatePageViewModel> {
  @override
  void loadArguments() {
    viewModel.cabinetInfo = widget.cabinetInfo;
    viewModel.deliveryId = widget.deliveryId;
    super.loadArguments();
  }

  @override
  CancelDeliveryStatePageViewModel createViewModel() => locator<CancelDeliveryStatePageViewModel>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => viewModel.delivery?.type == DeliveryType.charity
        ? CancelCharityDeliveryStatePageView(viewModel: viewModel)
        : CancelDeliveryStatePageView(viewModel: viewModel));
  }
}
