import 'package:event_poll/models/user.dart';

class Poll {
  Poll({
    required this.id,
    required this.name,
    this.description,
    this.imageName,
    this.eventDate,
    this.user,
  });

  final int id;
  final String name;
  final String? description;
  final String? imageName;
  final DateTime? eventDate;
  final User? user;

  Poll.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        name = json['name'] as String,
        description = json['description'] as String?,
        imageName = json['imageName'] as String?,
        eventDate = json['eventDate'] != null
            ? DateTime.parse(json[
                'eventDate']) // Si l'eventDate est une chaîne de caractères, on le parse
            : null,
        user = json['user'] != null
            ? User.fromJson(json['user'])
            : null; // Conversion de 'user' en objet User si disponible
}
