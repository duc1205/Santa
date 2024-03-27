import 'package:flutter/material.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/delivery_authorization_detail/delivery_authorization_detail_page_viewmodel.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/delivery_authorization_detail/widgets/charity_delivery_authorization_detail_page_ui.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/delivery_authorization_detail/widgets/delivery_authorization_detail_page_ui.dart';
import 'package:suga_core/suga_core.dart';

class DeliveryAuthorizationDetailPage extends StatefulWidget {
  final int deliveryAuthorizationId;
  final bool isCharity;

  const DeliveryAuthorizationDetailPage({Key? key, required this.deliveryAuthorizationId, this.isCharity = false}) : super(key: key);

  @override
  State<DeliveryAuthorizationDetailPage> createState() => _DeliveryAuthorizationDetailPageState();
}

class _DeliveryAuthorizationDetailPageState extends BaseViewState<DeliveryAuthorizationDetailPage, DeliveryAuthorizationDetailPageViewModel> {
  @override
  DeliveryAuthorizationDetailPageViewModel createViewModel() => locator<DeliveryAuthorizationDetailPageViewModel>();

  @override
  void loadArguments() {
    viewModel.deliveryAuthorizationId = widget.deliveryAuthorizationId;
    viewModel.isCharity = widget.isCharity;
    super.loadArguments();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isCharity
        ? CharityDeliveryAuthorizationDetailPageUI(
            viewModel: viewModel,
          )
        : DeliveryAuthorizationDetailPageUI(
            viewModel: viewModel,
          );
  }
}
