import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/date_time_range.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/helpers/sort_params.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket_size.dart';
import 'package:santapocket/modules/delivery/app/ui/history/enums/delivery_filter_tabs.dart';
import 'package:santapocket/modules/delivery/data/datasources/services/delivery_service.dart';
import 'package:santapocket/modules/delivery/domain/enums/package_category.dart';
import 'package:santapocket/modules/delivery/domain/models/delivery.dart';
import 'package:santapocket/modules/delivery/domain/models/reopen_request.dart';
import 'package:santapocket/modules/user/domain/models/user.dart';
import 'package:suga_core/suga_core.dart';

abstract class DeliveryRemoteDatasource {
  Future<List<Delivery>> getDeliveries(
    ListParams listParams, {
    DeliveryFilterTabs filterTab = DeliveryFilterTabs.all,
    int? cabinetId,
    String? status,
    DateTimeRange? dateTimeRange,
    String? query,
    String? type,
  });

  Future<Delivery> getDeliveryById(int deliveryId);

  Future<Delivery> getCharityDeliveryById(int deliveryId);

  Future<List<Delivery>> getReceivableDeliveries({
    SortParams? sortParams,
    int? cabinetId,
  });

  Future<Delivery> createDelivery({
    required int cabinetId,
    required int sizeId,
    required String receiverPhoneNumber,
    String? note,
    PackageCategory? packageCategory,
  });

  Future<Unit> cancelDelivery(int deliveryId);

  Future<Unit> cancelSentDelivery({
    required int deliveryId,
    required int cabinetId,
  });

  Future<Unit> receiveDelivery(int deliveryId, bool isUseCoin);

  Future<Delivery> rentPocket({
    required int cabinetId,
    required int sizeId,
    required String senderPhoneNumber,
    PackageCategory? packageCategory,
    String? note,
  });

  Future<Delivery> selfRentPocket({
    required int cabinetId,
    required int sizeId,
    PackageCategory? packageCategory,
    String? note,
  });

  Future sendDelivery({required int id});

  Future<List<User>> getRecentReceivers(ListParams listParams);

  Future<Unit> changePocketSize({required int deliveryId, required PocketSize pocketSize});

  Future<int> getEstimateFinalReceivingPrice({required int deliveryId});

  Future<bool> checkDeliveryReopenable({required int deliveryId});

  Future<ReopenRequest> reopenPocket({required int deliveryId, required int cabinetId});

  Future<ReopenRequest> getDeliveryReopenRequest({required int reopenRequestId});

  Future<Delivery> donateForCharity(String id, Map<String, dynamic> params);

  Future<List<Delivery>> getCharityDeliveries(
    ListParams listParams, {
    DeliveryFilterTabs filterTab = DeliveryFilterTabs.all,
    int? cabinetId,
    String? status,
    DateTimeRange? dateTimeRange,
    String? query,
  });
}

@LazySingleton(as: DeliveryRemoteDatasource)
class DeliveryRemoteDatasourceImpl extends DeliveryRemoteDatasource {
  final DeliveryService _deliveryService;

  DeliveryRemoteDatasourceImpl(this._deliveryService);

  @override
  Future<Unit> cancelDelivery(int deliveryId) async {
    await _deliveryService.cancelDelivery(deliveryId);
    return unit;
  }

  @override
  Future<Unit> cancelSentDelivery({
    required int deliveryId,
    required int cabinetId,
  }) async {
    final body = <String, dynamic>{};
    body["cabinet_id"] = cabinetId;
    await _deliveryService.cancelSentDelivery(deliveryId, body);
    return unit;
  }

  @override
  Future<Delivery> createDelivery({
    required int cabinetId,
    required int sizeId,
    required String receiverPhoneNumber,
    String? note,
    PackageCategory? packageCategory,
  }) =>
      _deliveryService.createDelivery({
        'cabinet_id': cabinetId,
        'pocket_size_id': sizeId,
        'receiver_phone_number': receiverPhoneNumber,
        'note': note,
        "package_category": packageCategory?.toValue(),
      });

  @override
  Future<List<Delivery>> getDeliveries(
    ListParams listParams, {
    DeliveryFilterTabs filterTab = DeliveryFilterTabs.all,
    String? status,
    int? cabinetId,
    DateTimeRange? dateTimeRange,
    String? query,
    String? type,
  }) {
    switch (filterTab) {
      case DeliveryFilterTabs.all:
        return _performGetDeliveryFunction(
          _deliveryService.getAllDeliveries,
          listParams,
          status: status,
          dateTimeRange: dateTimeRange,
          query: query,
          cabinetId: cabinetId,
          type: type,
        );
      case DeliveryFilterTabs.processing:
        return _performGetDeliveryFunction(
          _deliveryService.getUnFinishedDeliveries,
          listParams,
          status: status,
          dateTimeRange: dateTimeRange,
          query: query,
          cabinetId: cabinetId,
          type: type,
        );
      case DeliveryFilterTabs.finished:
        return _performGetDeliveryFunction(
          _deliveryService.getFinishedDeliveries,
          listParams,
          status: status,
          dateTimeRange: dateTimeRange,
          query: query,
          cabinetId: cabinetId,
          type: type,
        );
    }
  }

  Future<List<Delivery>> _performGetDeliveryFunction(
    Future<List<Delivery>> Function(
      int? page,
      int? limit,
      String? sort,
      String? dir,
      String? status,
      String? fromDate,
      String? toDate,
      String? query,
      int? cabinetId,
      String? type,
    )
        forwardedCall,
    ListParams listParams, {
    String? status,
    int? cabinetId,
    DateTimeRange? dateTimeRange,
    String? query,
    String? type,
  }) =>
      forwardedCall(
        listParams.paginationParams?.page,
        listParams.paginationParams?.limit,
        listParams.sortParams?.attribute,
        listParams.sortParams?.direction,
        status,
        dateTimeRange?.from?.toIso8601String(),
        dateTimeRange?.to?.toIso8601String(),
        query,
        cabinetId,
        type,
      );

  Future<List<Delivery>> _performGetCharityDeliveryFunction(
    Future<List<Delivery>> Function(
      int? page,
      int? limit,
      String? sort,
      String? dir,
      String? status,
      String? fromDate,
      String? toDate,
      String? query,
      int? cabinetId,
    )
        forwardedCall,
    ListParams listParams, {
    String? status,
    int? cabinetId,
    DateTimeRange? dateTimeRange,
    String? query,
  }) =>
      forwardedCall(
        listParams.paginationParams?.page,
        listParams.paginationParams?.limit,
        listParams.sortParams?.attribute,
        listParams.sortParams?.direction,
        status,
        dateTimeRange?.from?.toIso8601String(),
        dateTimeRange?.to?.toIso8601String(),
        query,
        cabinetId,
      );

  @override
  Future<Delivery> getDeliveryById(int deliveryId) => _deliveryService.getDeliveryById(deliveryId);
  @override
  Future<Delivery> getCharityDeliveryById(int deliveryId) => _deliveryService.getCharityDeliveryById(deliveryId);

  @override
  Future<List<Delivery>> getReceivableDeliveries({
    SortParams? sortParams,
    int? cabinetId,
  }) =>
      _deliveryService.getReceivableDeliveries(
        sortParams?.attribute,
        sortParams?.direction,
        cabinetId,
      );

  @override
  Future<Unit> receiveDelivery(int deliveryId, bool isUseCoin) async {
    await _deliveryService.receiveDelivery(deliveryId, {"use_coin": isUseCoin});
    return unit;
  }

  @override
  Future<Delivery> rentPocket({
    required int cabinetId,
    required int sizeId,
    required String senderPhoneNumber,
    PackageCategory? packageCategory,
    String? note,
  }) =>
      _deliveryService.rentPocket({
        'cabinet_id': cabinetId,
        'pocket_size_id': sizeId,
        'sender_phone_number': senderPhoneNumber,
        "package_category": packageCategory?.toValue(),
        'note': note,
      });

  @override
  Future<Delivery> selfRentPocket({
    required int cabinetId,
    required int sizeId,
    PackageCategory? packageCategory,
    String? note,
  }) =>
      _deliveryService.selfRentPocket({
        'cabinet_id': cabinetId,
        'pocket_size_id': sizeId,
        "package_category": packageCategory?.toValue(),
        'note': note,
      });

  @override
  Future sendDelivery({required int id}) => _deliveryService.sendDelivery(id);

  @override
  Future<List<User>> getRecentReceivers(ListParams listParams) => _deliveryService.getRecentReceivers(
        listParams.paginationParams?.page,
        listParams.paginationParams?.limit,
        listParams.sortParams?.attribute,
        listParams.sortParams?.direction,
      );

  @override
  Future<Unit> changePocketSize({required int deliveryId, required PocketSize pocketSize}) async {
    await _deliveryService.changePocketSize(deliveryId, {"pocket_size_id": pocketSize.id});
    return unit;
  }

  @override
  Future<int> getEstimateFinalReceivingPrice({required int deliveryId}) async {
    int estimateFinalReceivingPrice = await _deliveryService.getEstimateFinalReceivingPrice(deliveryId: deliveryId);
    return estimateFinalReceivingPrice;
  }

  @override
  Future<bool> checkDeliveryReopenable({required int deliveryId}) async {
    return _deliveryService.checkDeliveryReopenable(deliveryId: deliveryId);
  }

  @override
  Future<ReopenRequest> reopenPocket({required int deliveryId, required int cabinetId}) async {
    final body = <String, dynamic>{};
    body["cabinet_id"] = cabinetId;
    ReopenRequest reopenRequest = await _deliveryService.reopenPocket(deliveryId, body);
    return reopenRequest;
  }

  @override
  Future<ReopenRequest> getDeliveryReopenRequest({required int reopenRequestId}) async {
    return _deliveryService.getDeliveryReopenRequest(reopenRequestId);
  }

  @override
  Future<Delivery> donateForCharity(String id, Map<String, dynamic> params) => _deliveryService.donateForCharity(id, params);

  @override
  Future<List<Delivery>> getCharityDeliveries(
    ListParams listParams, {
    DeliveryFilterTabs filterTab = DeliveryFilterTabs.all,
    String? status,
    int? cabinetId,
    DateTimeRange? dateTimeRange,
    String? query,
  }) {
    switch (filterTab) {
      case DeliveryFilterTabs.all:
        return _performGetCharityDeliveryFunction(
          _deliveryService.getAllCharityDeliveries,
          listParams,
          status: status,
          dateTimeRange: dateTimeRange,
          query: query,
          cabinetId: cabinetId,
        );
      case DeliveryFilterTabs.processing:
        return _performGetCharityDeliveryFunction(
          _deliveryService.getUnFinishedCharityDeliveries,
          listParams,
          status: status,
          dateTimeRange: dateTimeRange,
          query: query,
          cabinetId: cabinetId,
        );
      case DeliveryFilterTabs.finished:
        return _performGetCharityDeliveryFunction(
          _deliveryService.getFinishedCharityDeliveries,
          listParams,
          status: status,
          dateTimeRange: dateTimeRange,
          query: query,
          cabinetId: cabinetId,
        );
    }
  }
}
