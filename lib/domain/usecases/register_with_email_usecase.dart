import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/errors/failures.dart';
import 'package:ecommerce/core/usecases/usecase.dart';
import 'package:ecommerce/domain/entities/user_entity.dart';
import 'package:ecommerce/domain/repositories/auth_repository.dart';

class RegisterParams {
  final String name;
  final String email;
  final String password;

  RegisterParams({
    required this.name,
    required this.email,
    required this.password,
  });
}

class RegisterWithEmailUseCase implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository repository;

  RegisterWithEmailUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterParams params) async {
    return await repository.registerWithEmail(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}
