import 'package:flutter/material.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/charity/app/ui/charity_detail/charity_delivery_detail_page.dart';
import 'package:santapocket/modules/delivery/app/ui/detail/delivery_detail_page_view_model.dart';
import 'package:santapocket/modules/delivery/app/ui/detail/widgets/delivery_detail_page_ui.dart';
import 'package:suga_core/suga_core.dart';

class DeliveryDetailPage extends StatefulWidget {
  final int deliveryId;
  final bool isCharity;

  const DeliveryDetailPage({
    Key? key,
    required this.deliveryId,
    required this.isCharity,
  }) : super(key: key);

  @override
  State<DeliveryDetailPage> createState() => _DeliveryDetailPageState();
}

class _DeliveryDetailPageState extends BaseViewState<DeliveryDetailPage, DeliveryDetailPageViewModel> {
  @override
  DeliveryDetailPageViewModel createViewModel() => locator<DeliveryDetailPageViewModel>();

  @override
  void loadArguments() {
    viewModel.deliveryId = widget.deliveryId;
    viewModel.isCharity = widget.isCharity;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isCharity
        ? CharityDeliveryDetailPage(
            deliveryId: viewModel.deliveryId,
            viewModel: viewModel,
          )
        : DeliveryDetailPageUI(
            deliveryId: viewModel.deliveryId,
            viewModel: viewModel,
          );
  }
}
