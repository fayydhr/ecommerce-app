abstract class Failure {
  final String message;
  const Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Terjadi kesalahan pada server']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Gagal melakukan autentikasi']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Gagal mengakses data lokal']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Koneksi internet bermasalah']);
}
