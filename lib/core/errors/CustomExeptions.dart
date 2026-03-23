
class Customexeptions implements Exception {
  final String message;

  Customexeptions({required this.message});

  @override
  
  String toString() => message;
}
  