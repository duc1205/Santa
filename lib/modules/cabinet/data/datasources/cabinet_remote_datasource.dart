import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/modules/cabinet/data/datasources/services/cabinet_location_service.dart';
import 'package:santapocket/modules/cabinet/data/datasources/services/cabinet_service.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket_size.dart';

abstract class CabinetRemoteDatasource {
  Future<CabinetInfo> getCabinetInfo({required String uuid, String? otp});

  Future<Cabinet> getCabinet(int id);

  Future<List<Cabinet>> getNearBy(double latitude, double longitude, double radius);

  Future<List<PocketSize>> getPocketSizes(int cabinetId);

  Future<List<Cabinet>> getCabinets(
    ListParams params, {
    String? query,
    String? nearBy,
    double? latitude,
    double? longitude,
    String? city,
    String? district,
    String? merchantType,
  });

  Future<List<CabinetInfo>> getListCabinetInfo();

  Future<List<String>> getCabinetCities();

  Future<List<String>> getCabinetDistricts(String city);

  Future<List<CabinetInfo>> getListCabinetInfoWithAuthorizations();
}

@LazySingleton(as: CabinetRemoteDatasource)
class CabinetRemoteDatasourceImpl extends CabinetRemoteDatasource {
  final CabinetService _cabinetService;
  final CabinetLocationService _cabinetLocationService;

  CabinetRemoteDatasourceImpl(this._cabinetService, this._cabinetLocationService);

  @override
  Future<Cabinet> getCabinet(int id) => _cabinetService.getCabinet(id);

  @override
  Future<CabinetInfo> getCabinetInfo({required String uuid, String? otp}) => _cabinetService.getCabinetInfo(uuid, otp);

  @override
  Future<List<Cabinet>> getNearBy(double latitude, double longitude, double radius) => _cabinetService.getNearBy(latitude, longitude, radius);

  @override
  Future<List<PocketSize>> getPocketSizes(int cabinetId) => _cabinetService.getPocketSizes(cabinetId);

  @override
  Future<List<Cabinet>> getCabinets(
    ListParams params, {
    String? query,
    String? nearBy,
    double? latitude,
    double? longitude,
    String? city,
    String? district,
    String? merchantType,
  }) =>
      _cabinetService.getCabinets(
        params.paginationParams?.page,
        params.paginationParams?.limit,
        params.sortParams?.attribute,
        params.sortParams?.direction,
        query,
        nearBy,
        latitude,
        longitude,
        city,
        district,
        merchantType,
      );

  @override
  Future<List<CabinetInfo>> getListCabinetInfo() => _cabinetService.getListCabinetInfo();

  @override
  Future<List<CabinetInfo>> getListCabinetInfoWithAuthorizations() => _cabinetService.getListCabinetInfoWithAuthorizations();

  @override
  Future<List<String>> getCabinetCities() => _cabinetLocationService.getCabinetCities();

  @override
  Future<List<String>> getCabinetDistricts(String city) => _cabinetLocationService.getCabinetDistricts(city);
}
