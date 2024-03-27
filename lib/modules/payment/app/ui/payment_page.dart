import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:santapocket/extensions/string_ext.dart';
import 'package:santapocket/gen/assets.gen.dart';
import 'package:santapocket/locale_keys.g.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/payment/app/ui/payment_page_viewmodel.dart';
import 'package:santapocket/modules/payment/app/ui/widgets/payment_method_widget.dart';
import 'package:santapocket/modules/payment/app/ui/widgets/payment_products_widget.dart';
import 'package:santapocket/modules/payment/domain/enums/payment_method.dart';
import 'package:santapocket/shared/theme/app_theme.dart';
import 'package:suga_core/suga_core.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

class PaymentPage extends StatefulWidget {
  final PaymentMethod? paymentMethod;
  const PaymentPage({Key? key, this.paymentMethod}) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends BaseViewState<PaymentPage, PaymentPageViewModel> with WidgetsBindingObserver {
  @override
  PaymentPageViewModel createViewModel() => locator<PaymentPageViewModel>();

  @override
  void loadArguments() {
    viewModel.setDefaultPaymentMethod(widget.paymentMethod ?? PaymentMethod.moMo);
    super.loadArguments();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      viewModel.getPaymentOrder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          LocaleKeys.payment_top_up_xu.trans().toUpperCase(),
          style: AppTheme.blackDark_16,
        ),
        actions: [
          GestureDetector(onTap: () => viewModel.launchPrivacyPolicyUrl(), child: Assets.icons.icTopupPolicy.image()),
        ],
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: AppTheme.blackDark),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => viewModel.refreshData(),
              child: CustomScrollView(
                controller: viewModel.controller,
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                slivers: [
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Obx(
                                () => PaymentProductsWidget(
                                  paymentProducts: viewModel.paymentProducts,
                                  selectedIndex: viewModel.indexItemSelected,
                                  onSelectItem: viewModel.setItemSelected,
                                  getCoinAmount: viewModel.getCoin,
                                  getPrice: viewModel.getAmount,
                                  getCoinPromo: viewModel.getPromoValue,
                                ),
                              ),
                              SizedBox(
                                height: 32.h,
                              ),
                              Text(
                                LocaleKeys.payment_payment_by.trans(),
                                style: AppTheme.blackDark_16w600,
                              ),
                              SizedBox(
                                height: 17.h,
                              ),
                              Obx(
                                () => PaymentMethodWidget(
                                  defaultPaymentMethod: viewModel.defaultPaymentMethod,
                                  onSelectPaymentMethod: viewModel.setDefaultPaymentMethod,
                                  isAppBankTransferEnable: viewModel.isBankTransferEnable,
                                  bankTransferInfo: viewModel.bankTransferInfo,
                                  bankTransferMessage: viewModel.bankTransferMessage,
                                  onVnpayHelpClick: () => viewModel.navigatateToVnpayHelpWebview(),
                                  payrollStatus: viewModel.payrollStatus,
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: 32.w,
              right: 32.w,
              top: 13.h,
              bottom: 18.h,
            ),
            child: TapDebouncer(
              onTap: () async => viewModel.openTopupConfirmDialog(),
              builder: (BuildContext context, TapDebouncerFunc? onTap) {
                return Obx(
                  () => ElevatedButton(
                    onPressed: viewModel.isBankTransfer ? () {} : onTap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: viewModel.isBankTransfer ? AppTheme.yellow4 : AppTheme.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r),
                      ),
                      elevation: 0,
                    ),
                    child: SizedBox(
                      height: 50.h,
                      child: Center(
                        child: Text(
                          LocaleKeys.payment_top_up_xu.trans(),
                          style: AppTheme.white_16w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
