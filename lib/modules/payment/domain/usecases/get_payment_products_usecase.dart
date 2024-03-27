import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/payment/data/repositories/payment_repository.dart';
import 'package:santapocket/modules/payment/domain/models/payment_product.dart';
import 'package:suga_core/suga_core.dart';

@LazySingleton()
class GetPaymentProductsUsecase extends Usecase {
  final PaymentRepository _paymentRepository;

  const GetPaymentProductsUsecase(this._paymentRepository);

  Future<List<PaymentProduct>> run(SortParams? params) => _paymentRepository.getPaymentProduct(params);
}
