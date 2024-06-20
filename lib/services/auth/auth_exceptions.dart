// login exceptions

class InvalidEmailAuthException implements Exception {}

class InvalidCredentialAuthException implements Exception {}

// registrartion exceptions

class WeekPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

// generic exceptions

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
