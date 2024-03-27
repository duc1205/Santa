import 'package:flutter/material.dart' hide Badge;
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/receive/owner_package/receive_owner_packages_page.dart';
import 'package:santapocket/modules/delivery/app/ui/workflow/receive/receive_packages_page_viewmodel.dart';
import 'package:santapocket/modules/delivery_authorization/app/ui/receive_delivery_authorization/receive_delivery_authorizations_page.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';

class ReceivePackagesPage extends StatefulWidget {
  const ReceivePackagesPage({Key? key, required this.cabinetInfo}) : super(key: key);

  final CabinetInfo cabinetInfo;

  @override
  State<ReceivePackagesPage> createState() => _ReceivePackagesPageState();
}

class _ReceivePackagesPageState extends BaseViewState<ReceivePackagesPage, ReceivePackagesPageViewModel> with TickerProviderStateMixin {
  @override
  void loadArguments() {
    viewModel.cabinetInfo = widget.cabinetInfo;
    super.loadArguments();
  }

  @override
  ReceivePackagesPageViewModel createViewModel() => locator<ReceivePackagesPageViewModel>();

  @override
  void initState() {
    super.initState();
    viewModel.initTabController(this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Obx(
        () => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              LocaleKeys.delivery_my_package.trans(),
              style: AppTheme.blackDark_16w600,
            ),
            iconTheme: const IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 2,
          ),
          body: IndexedStack(
            index: viewModel.currentPage,
            children: [
              Obx(
                () => ReceiveOwnerPackagesPage(
                  deliveries: viewModel.deliveries,
                  deliveryAuthorizations: viewModel.deliveryAuthorizations,
                  listCabinetWithDeliveries: viewModel.listCabinetInfo,
                  bankTransferInfo: viewModel.bankTransferInfo,
                  cabinetInfo: viewModel.cabinetInfo,
                  user: viewModel.user,
                  isFirstLoading: viewModel.isFirstLoading,
                  onSelectedTab: viewModel.onChangeTab,
                  tabController: viewModel.tabController,
                ),
              ),
              Obx(
                () => ReceiveDeliveryAuthorizationsPage(
                  deliveries: viewModel.deliveries,
                  deliveryAuthorizations: viewModel.deliveryAuthorizations,
                  cabinetInfo: viewModel.cabinetInfo,
                  listCabinetWithDeliveries: viewModel.listCabinetInfoWithAuthorizations,
                  bankTransferInfo: viewModel.bankTransferInfo,
                  user: viewModel.user,
                  onSelectedTab: viewModel.onChangeTab,
                  tabController: viewModel.tabController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
