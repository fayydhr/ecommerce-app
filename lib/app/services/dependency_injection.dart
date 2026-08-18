import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecommerce/data/datasources/auth_local_datasource.dart';
import 'package:ecommerce/data/datasources/auth_remote_datasource.dart';
import 'package:ecommerce/data/repositories/auth_repository_impl.dart';
import 'package:ecommerce/domain/repositories/auth_repository.dart';
import 'package:ecommerce/domain/usecases/check_auth_status_usecase.dart';
import 'package:ecommerce/domain/usecases/get_current_user_usecase.dart';
import 'package:ecommerce/domain/usecases/login_with_email_usecase.dart';
import 'package:ecommerce/domain/usecases/login_with_google_usecase.dart';
import 'package:ecommerce/domain/usecases/logout_usecase.dart';
import 'package:ecommerce/domain/usecases/register_with_email_usecase.dart';
import 'package:ecommerce/domain/usecases/send_password_reset_usecase.dart';

import 'package:ecommerce/firebase_options.dart';

class DependencyInjection {
  static Future<void> init() async {
    // 1. Initialize SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.put<SharedPreferences>(sharedPreferences, permanent: true);

    // 2. Initialize Firebase
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (kDebugMode) {
        print('Firebase successfully initialized with DefaultFirebaseOptions');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Firebase initialization info/fallback: $e');
      }
    }

    // 3. Register External Services
    Get.lazyPut<FirebaseAuth>(() => FirebaseAuth.instance, fenix: true);
    Get.lazyPut<GoogleSignIn>(() => GoogleSignIn(), fenix: true);

    // 4. Register DataSources
    Get.lazyPut<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(
        sharedPreferences: Get.find<SharedPreferences>(),
      ),
      fenix: true,
    );

    Get.lazyPut<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(
        firebaseAuth: Get.find<FirebaseAuth>(),
        googleSignIn: Get.find<GoogleSignIn>(),
      ),
      fenix: true,
    );

    // 5. Register Repositories
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: Get.find<AuthRemoteDataSource>(),
        localDataSource: Get.find<AuthLocalDataSource>(),
      ),
      fenix: true,
    );

    // 6. Register UseCases
    Get.lazyPut(
      () => LoginWithEmailUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => RegisterWithEmailUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => LoginWithGoogleUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => LogoutUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => GetCurrentUserUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => SendPasswordResetUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => CheckFirstTimeUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
    Get.lazyPut(
      () => SetFirstTimeCompleteUseCase(Get.find<AuthRepository>()),
      fenix: true,
    );
  }
}
