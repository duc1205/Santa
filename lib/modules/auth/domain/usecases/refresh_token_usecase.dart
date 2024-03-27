import 'package:injectable/injectable.dart';
import 'package:santapocket/locator.dart';
import 'package:santapocket/modules/auth/data/repositories/auth_repository.dart';
import 'package:santapocket/oauth2/oauth2_manager.dart';
import 'package:santapocket/retrofit/rest_client.dart';
import 'package:santapocket/storage/spref.dart';
import 'package:suga_core/suga_core.dart' hide Oauth2Manager;

@lazySingleton
class RefreshTokenUsecase extends Usecase {
  final AuthRepository _authRepository;

  const RefreshTokenUsecase(this._authRepository);

  Future<bool> run() async {
    final refreshToken = await SPref.instance.getRefreshToken();
    if (refreshToken == null) {
      return false;
    } else {
      try {
        final data = await _authRepository.refreshToken(refreshToken);
        if (data is Map<String, dynamic>) {
          Oauth2Manager.instance.onRefreshTokenSuccess(data["access_token"] as String, data["refresh_token"] as String, data["expires_in"] as int);
          locator<RestClient>().onRefreshToken = false;
        }
        return true;
      } catch (e) {
        return false;
      }
    }
  }
}
