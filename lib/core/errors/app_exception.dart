class AppException implements Exception {
  const AppException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => message;
}

class AuthException extends AppException {
  const AuthException(super.message, [super.cause]);
}

class RecipeException extends AppException {
  const RecipeException(super.message, [super.cause]);
}

class IngestionException extends AppException {
  const IngestionException(super.message, [super.cause]);
}

class PlannerException extends AppException {
  const PlannerException(super.message, [super.cause]);
}

class VersionException extends AppException {
  const VersionException(super.message, [super.cause]);
}

class SubstitutionException extends AppException {
  const SubstitutionException(super.message, [super.cause]);
}

class DiscoveryException extends AppException {
  const DiscoveryException(super.message, [super.cause]);
}
