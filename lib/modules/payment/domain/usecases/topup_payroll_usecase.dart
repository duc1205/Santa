import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/payment/data/repositories/payment_repository.dart';
import 'package:santapocket/modules/payment/domain/models/payment_order.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class TopupPayrollUsecase extends Usecase {
  final PaymentRepository _paymentRepository;

  const TopupPayrollUsecase(this._paymentRepository);

  Future<PaymentOrder> run({required int paymentProductId}) => _paymentRepository.topupPayroll(paymentProductId: paymentProductId);
}
