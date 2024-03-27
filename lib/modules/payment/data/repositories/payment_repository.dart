import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/payment/data/datasources/payment_remote_datasource.dart';
import 'package:santapocket/modules/payment/domain/models/momo_payment.dart';
import 'package:santapocket/modules/payment/domain/models/payment_order.dart';
import 'package:santapocket/modules/payment/domain/models/payment_product.dart';
import 'package:santapocket/modules/payment/domain/models/vnpay_payment.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class PaymentRepository extends Repository {
  final PaymentRemoteDatasource _paymentRemoteDatasource;

  const PaymentRepository(this._paymentRemoteDatasource);

  Future<MomoPayment> createPaymentMomo({
    required String orderInfo,
    required int productId,
  }) =>
      _paymentRemoteDatasource.createPaymentMomo(
        orderInfo: orderInfo,
        productId: productId,
      );

  Future<VnPayPayment> createPaymentVnPay({
    required String orderInfo,
    required int productId,
  }) =>
      _paymentRemoteDatasource.createPaymentVnPay(
        orderInfo: orderInfo,
        productId: productId,
      );

  Future<List<PaymentProduct>> getPaymentProduct(SortParams? params) => _paymentRemoteDatasource.getPaymentProduct(params);

  Future<PaymentOrder> getPaymentOrder({required String orderId}) => _paymentRemoteDatasource.getPaymentOrder(orderId: orderId);

  Future<String> getBankTransferMessage() => _paymentRemoteDatasource.getBankTransferMessage();

  Future<PaymentOrder> topupPayroll({required int paymentProductId}) => _paymentRemoteDatasource.topupPayroll(paymentProductId: paymentProductId);
}
