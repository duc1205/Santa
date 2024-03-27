import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/payment/data/repositories/payment_repository.dart';
import 'package:santapocket/modules/payment/domain/models/vnpay_payment.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class CreatePaymentVnPayUsecase extends Usecase {
  final PaymentRepository _paymentRepository;

  const CreatePaymentVnPayUsecase(this._paymentRepository);

  Future<VnPayPayment> run({
    required String orderInfo,
    required int productId,
  }) =>
      _paymentRepository.createPaymentVnPay(
        orderInfo: orderInfo,
        productId: productId,
      );
}
