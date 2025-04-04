import 'package:event_poll/models/poll.dart';
import 'package:flutter/material.dart';

class PollPage extends StatefulWidget {
  const PollPage({super.key});

  @override
  State<PollPage> createState() => _PollPageState();
}

class _PollPageState extends State<PollPage> {
  Poll? _poll;
  Poll? get poll => _poll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.all(16.0), // Ajouter de l'espace autour des éléments
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligner les éléments à gauche
        children: [
          Text(
            _poll!.name, // Afficher le nom du sondage
          ),
          SizedBox(height: 8), // Espacement entre les éléments
          Text(
            _poll!.description!,
          ),
          SizedBox(height: 8),
          Text(
            'Date de l\'événement : ${_poll!.eventDate}', // Plus explicite pour l'utilisateur
          ),
          SizedBox(height: 16), // Espacement avant le bouton
          ElevatedButton(
            onPressed: null,
            child: const Text(
                'Créer mon compte'), // Le texte du bouton est plus clair
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8), // Arrondir les coins du bouton
              ),
            ),
          ),
        ],
      ),
    );
  }
}
