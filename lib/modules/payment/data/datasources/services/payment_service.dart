import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';
import 'package:santapocket/config/config.dart';
import 'package:santapocket/modules/payment/domain/models/momo_payment.dart';
import 'package:santapocket/modules/payment/domain/models/payment_order.dart';
import 'package:santapocket/modules/payment/domain/models/payment_product.dart';
import 'package:santapocket/modules/payment/domain/models/vnpay_payment.dart';

part 'payment_service.g.dart';

@lazySingleton
@RestApi(baseUrl: "${Config.baseUrl}/api/client/v1")
abstract class PaymentService {
  @factoryMethod
  factory PaymentService(Dio dio) = _PaymentService;

  @POST("/payments/momo/aio/create")
  Future<MomoPayment> createPaymentMomo(@Body() Map<String, dynamic> map);

  @POST("/payments/vnpay/create")
  Future<VnPayPayment> createPaymentVnPay(@Body() Map<String, dynamic> map);

  @GET("/payments/products")
  Future<List<PaymentProduct>> getPaymentProducts(
    @Query("sort") String? sort,
    @Query("dir") String? dir,
  );

  @GET("/payments/orders/{uuid}")
  Future<PaymentOrder> getPaymentOrder(@Path("uuid") String orderId);

  @GET("/bank-transfers/message")
  Future<String> getBankTransferMessage();

  @POST("/payments/payroll/topup")
  Future<PaymentOrder> topupPayroll(@Body() Map<String, dynamic> map);
}
