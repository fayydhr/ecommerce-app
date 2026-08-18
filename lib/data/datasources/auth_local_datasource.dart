import 'package:shared_preferences/shared_preferences.dart';
import 'package:ecommerce/app/config/app_constants.dart';
import 'package:ecommerce/core/errors/exceptions.dart';

abstract class AuthLocalDataSource {
  Future<bool> isFirstTime();
  Future<void> setFirstTimeComplete();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<bool> isFirstTime() async {
    try {
      final isFirstTime =
          sharedPreferences.getBool(AppConstants.keyIsFirstTime) ?? true;
      return isFirstTime;
    } catch (e) {
      throw CacheException('Gagal membaca preferensi lokal');
    }
  }

  @override
  Future<void> setFirstTimeComplete() async {
    try {
      await sharedPreferences.setBool(AppConstants.keyIsFirstTime, false);
    } catch (e) {
      throw CacheException('Gagal menyimpan status onboarding');
    }
  }
}
