import 'package:uuid/uuid.dart';

final Uuid uuid = Uuid();

String generateUniqueId() {
  return uuid.v4(); // Generates a unique v4 UUID
}
