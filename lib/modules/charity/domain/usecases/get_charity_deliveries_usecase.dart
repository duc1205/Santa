import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/date_time_range.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/modules/delivery/app/ui/history/enums/delivery_filter_tabs.dart';
import 'package:santapocket/modules/delivery/data/repositories/delivery_repository.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class GetCharityDeliveriesUsecase extends Usecase {
  final DeliveryRepository _deliveryRepository;

  const GetCharityDeliveriesUsecase(this._deliveryRepository);

  Future<List<Delivery>> run(
    ListParams listParams, {
    DeliveryFilterTabs filterTab = DeliveryFilterTabs.all,
    String? status,
    int? cabinetId,
    DateTimeRange? dateTimeRange,
    String? query,
  }) =>
      _deliveryRepository.getCharityDeliveries(
        listParams,
        filterTab: filterTab,
        status: status,
        dateTimeRange: dateTimeRange,
        query: query,
        cabinetId: cabinetId,
      );
}
