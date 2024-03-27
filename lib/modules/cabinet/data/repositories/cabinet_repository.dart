import 'package:injectable/injectable.dart';
import 'package:santapocket/helpers/list_params.dart';
import 'package:santapocket/modules/cabinet/data/datasources/cabinet_remote_datasource.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet.dart';
import 'package:santapocket/modules/cabinet/domain/models/cabinet_info.dart';
import 'package:santapocket/modules/cabinet/domain/models/pocket_size.dart';
import 'package:suga_core/suga_core.dart';

@lazySingleton
class CabinetRepository extends Repository {
  final CabinetRemoteDatasource _cabinetDatasource;

  const CabinetRepository(this._cabinetDatasource);

  Future<Cabinet> getCabinet(int id) => _cabinetDatasource.getCabinet(id);

  Future<CabinetInfo> getCabinetInfo({required String uuid, String? otp}) => _cabinetDatasource.getCabinetInfo(uuid: uuid, otp: otp);

  Future<List<Cabinet>> getNearBy(double latitude, double longitude, double radius) => _cabinetDatasource.getNearBy(latitude, longitude, radius);

  Future<List<PocketSize>> getPocketSizes(int cabinetId) => _cabinetDatasource.getPocketSizes(cabinetId);

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
      _cabinetDatasource.getCabinets(
        params,
        query: query,
        nearBy: nearBy,
        latitude: latitude,
        longitude: longitude,
        city: city,
        district: district,
        merchantType: merchantType,
      );

  Future<List<CabinetInfo>> getListCabinetInfo() => _cabinetDatasource.getListCabinetInfo();

  Future<List<CabinetInfo>> getListCabinetInfoWithAuthorizations() => _cabinetDatasource.getListCabinetInfoWithAuthorizations();

  Future<List<String>> getCabinetCities() => _cabinetDatasource.getCabinetCities();

  Future<List<String>> getCabinetDistricts(String city) => _cabinetDatasource.getCabinetDistricts(city);
}
