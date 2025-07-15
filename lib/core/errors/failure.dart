abstract class Failure {
  final String message;

  Failure({required this.message});
}

class FirebaseError extends Failure {
  FirebaseError({required super.message});
}
