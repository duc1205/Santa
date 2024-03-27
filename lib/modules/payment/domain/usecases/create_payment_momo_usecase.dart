import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/payment/data/repositories/payment_repository.dart';
import 'package:santapocket/modules/payment/domain/models/momo_payment.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class CreatePaymentMomoUsecase extends Usecase {
  final PaymentRepository _paymentRepository;

  const CreatePaymentMomoUsecase(this._paymentRepository);

  Future<MomoPayment> run({
    required String orderInfo,
    required int productId,
  }) =>
      _paymentRepository.createPaymentMomo(
        orderInfo: orderInfo,
        productId: productId,
      );
}
