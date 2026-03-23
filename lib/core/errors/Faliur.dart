

class Faliur {
  final String errmessage;

  Faliur({required this.errmessage});

  @override
  String toString() => errmessage;
}

class FirebaseAuthError extends Faliur {
  FirebaseAuthError({required super.errmessage});
}