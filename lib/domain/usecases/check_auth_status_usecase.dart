import 'package:dartz/dartz.dart';
import 'package:ecommerce/core/errors/failures.dart';
import 'package:ecommerce/core/usecases/usecase.dart';
import 'package:ecommerce/domain/repositories/auth_repository.dart';

class CheckFirstTimeUseCase implements UseCase<bool, NoParams> {
  final AuthRepository repository;

  CheckFirstTimeUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isFirstTime();
  }
}

class SetFirstTimeCompleteUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SetFirstTimeCompleteUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.setFirstTimeComplete();
  }
}
