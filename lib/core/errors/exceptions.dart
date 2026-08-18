class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Terjadi kesalahan pada server']);

  @override
  String toString() => message;
}

class AuthException implements Exception {
  final String message;
  AuthException([this.message = 'Terjadi kesalahan autentikasi']);

  @override
  String toString() => message;
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Terjadi kesalahan penyimpanan lokal']);

  @override
  String toString() => message;
}
