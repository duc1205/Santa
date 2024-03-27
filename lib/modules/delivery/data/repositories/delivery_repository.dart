import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/date_time_range.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket_size.dart';
import 'package:santapocket/modules/delivery/app/ui/history/enums/delivery_filter_tabs.dart';
import 'package:santapocket/modules/delivery/data/datasources/delivery_remote_datasource.dart';
import 'package:santapocket/modules/delivery/domain/enums/package_category.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery/domain/models/reopen_request.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class DeliveryRepository extends Repository {
  final DeliveryRemoteDatasource _deliveryRemoteDatasource;

  const DeliveryRepository(this._deliveryRemoteDatasource);

  Future<List<Delivery>> getDeliveries(
    ListParams listParams, {
    DeliveryFilterTabs filterTab = DeliveryFilterTabs.all,
    String? status,
    int? cabinetId,
    DateTimeRange? dateTimeRange,
    String? query,
    String? type,
  }) =>
      _deliveryRemoteDatasource.getDeliveries(
        listParams,
        filterTab: filterTab,
        status: status,
        dateTimeRange: dateTimeRange,
        query: query,
        cabinetId: cabinetId,
        type: type,
      );

  Future<List<Delivery>> getCharityDeliveries(
    ListParams listParams, {
    DeliveryFilterTabs filterTab = DeliveryFilterTabs.all,
    String? status,
    int? cabinetId,
    DateTimeRange? dateTimeRange,
    String? query,
  }) =>
      _deliveryRemoteDatasource.getCharityDeliveries(
        listParams,
        filterTab: filterTab,
        status: status,
        dateTimeRange: dateTimeRange,
        query: query,
        cabinetId: cabinetId,
      );

  Future<Delivery> getDeliveryById(int deliveryId) => _deliveryRemoteDatasource.getDeliveryById(deliveryId);

  Future<Delivery> getCharityDeliveryById(int deliveryId) => _deliveryRemoteDatasource.getCharityDeliveryById(deliveryId);

  Future<List<Delivery>> getReceivableDeliveries({
    SortParams? sortParams,
    int? cabinetId,
  }) =>
      _deliveryRemoteDatasource.getReceivableDeliveries(
        sortParams: sortParams,
        cabinetId: cabinetId,
      );

  Future<Delivery> createDelivery({
    required int cabinetId,
    required int sizeId,
    required String receiverPhoneNumber,
    PackageCategory? packageCategory,
    String? note,
  }) =>
      _deliveryRemoteDatasource.createDelivery(
        cabinetId: cabinetId,
        sizeId: sizeId,
        receiverPhoneNumber: receiverPhoneNumber,
        note: note,
        packageCategory: packageCategory,
      );

  Future<Unit> cancelDelivery(int deliveryId) => _deliveryRemoteDatasource.cancelDelivery(deliveryId);

  Future<Unit> cancelSentDelivery({
    required int deliveryId,
    required int cabinetId,
  }) =>
      _deliveryRemoteDatasource.cancelSentDelivery(deliveryId: deliveryId, cabinetId: cabinetId);

  Future<Unit> receiveDelivery(int deliveryId, bool isUseCoin) => _deliveryRemoteDatasource.receiveDelivery(deliveryId, isUseCoin);

  Future<Delivery> rentPocket({
    required int cabinetId,
    required int sizeId,
    required String senderPhoneNumber,
    PackageCategory? packageCategory,
    String? note,
  }) =>
      _deliveryRemoteDatasource.rentPocket(
        cabinetId: cabinetId,
        sizeId: sizeId,
        senderPhoneNumber: senderPhoneNumber,
        packageCategory: packageCategory,
        note: note,
      );

  Future<Delivery> selfRentPocket({required int cabinetId, required int sizeId, PackageCategory? packageCategory, String? note}) =>
      _deliveryRemoteDatasource.selfRentPocket(
        cabinetId: cabinetId,
        sizeId: sizeId,
        packageCategory: packageCategory,
        note: note,
      );

  Future sendDelivery({required int id}) => _deliveryRemoteDatasource.sendDelivery(id: id);

  Future<List<User>> getRecentReceivers(ListParams listParams) => _deliveryRemoteDatasource.getRecentReceivers(listParams);

  Future<Unit> changePocketSize(int deliveryId, PocketSize pocketSize) =>
      _deliveryRemoteDatasource.changePocketSize(deliveryId: deliveryId, pocketSize: pocketSize);

  Future<int> getEstimateFinalReceivingPrice(int deliveryId) => _deliveryRemoteDatasource.getEstimateFinalReceivingPrice(deliveryId: deliveryId);

  Future<bool> checkDeliveryReopenable({required int deliveryId}) => _deliveryRemoteDatasource.checkDeliveryReopenable(deliveryId: deliveryId);

  Future<ReopenRequest> reopenPocket({required int deliveryId, required int cabinetId}) =>
      _deliveryRemoteDatasource.reopenPocket(deliveryId: deliveryId, cabinetId: cabinetId);

  Future<ReopenRequest> getDeliveryReopenRequest({required int reopenRequestId}) =>
      _deliveryRemoteDatasource.getDeliveryReopenRequest(reopenRequestId: reopenRequestId);

  Future<Delivery> donateForCharity(String id, Map<String, dynamic> params) => _deliveryRemoteDatasource.donateForCharity(id, params);
}
