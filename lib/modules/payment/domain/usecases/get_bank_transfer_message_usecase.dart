import 'package:injectable/injectable.dart';
import 'package:santapocket/modules/payment/data/repositories/payment_repository.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetBankTransferMessageUsecase extends Usecase {
  final PaymentRepository _paymentRepository;

  const GetBankTransferMessageUsecase(this._paymentRepository);

  Future<String> run() => _paymentRepository.getBankTransferMessage();
}
