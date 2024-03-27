import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/payment/data/datasources/services/payment_service.dart';
import 'package:santapocket/modules/payment/domain/models/momo_payment.dart';
import 'package:santapocket/modules/payment/domain/models/payment_order.dart';
import 'package:santapocket/modules/payment/domain/models/payment_product.dart';
import 'package:santapocket/modules/payment/domain/models/vnpay_payment.dart';

abstract class PaymentRemoteDatasource {
  Future<MomoPayment> createPaymentMomo({
    required String orderInfo,
    required int productId,
  });

  Future<VnPayPayment> createPaymentVnPay({
    required String orderInfo,
    required int productId,
  });

  Future<List<PaymentProduct>> getPaymentProduct(SortParams? params);

  Future<PaymentOrder> getPaymentOrder({required String orderId});

  Future<String> getBankTransferMessage();

  Future<PaymentOrder> topupPayroll({required int paymentProductId});
}

@LazySingleton(as: PaymentRemoteDatasource)
class PaymentRemoteDatasourceImpl extends PaymentRemoteDatasource {
  final PaymentService _paymentService;

  PaymentRemoteDatasourceImpl(this._paymentService);

  @override
  Future<MomoPayment> createPaymentMomo({
    required String orderInfo,
    required int productId,
  }) =>
      _paymentService.createPaymentMomo({
        'order_info': orderInfo,
        'payment_product_id': productId,
      });

  @override
  Future<VnPayPayment> createPaymentVnPay({required String orderInfo, required int productId}) => _paymentService.createPaymentVnPay({
        'order_info': orderInfo,
        'payment_product_id': productId,
      });

  @override
  Future<List<PaymentProduct>> getPaymentProduct(SortParams? params) => _paymentService.getPaymentProducts(
        params?.attribute,
        params?.direction,
      );

  @override
  Future<PaymentOrder> getPaymentOrder({required String orderId}) => _paymentService.getPaymentOrder(orderId);

  @override
  Future<String> getBankTransferMessage() async {
    final response = await _paymentService.getBankTransferMessage();
    return jsonDecode(response);
  }

  @override
  Future<PaymentOrder> topupPayroll({required int paymentProductId}) => _paymentService.topupPayroll({"payment_product_id": paymentProductId});
}
