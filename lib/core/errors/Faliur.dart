class Faliur {
  final String errmessage;

  Faliur({required this.errmessage});

  String get message => errmessage;

  @override
  String toString() => errmessage;
}

class FirebaseAuthError extends Faliur {
  FirebaseAuthError({required super.errmessage});
}
