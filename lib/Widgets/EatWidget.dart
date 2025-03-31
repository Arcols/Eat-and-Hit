import 'package:flutter/material.dart';
import 'package:eat_and_hit/fonctions/dataFonctions.dart';

class EatWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  final VoidCallback onUpdate;

  const EatWidget(this.data, {required this.onUpdate,super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SizedBox(
        width: 50,
        height: 50,
        child: Image.asset("assets/images/eat.png"),
      ),
      onPressed: () async {
        // Ajout de l'action "H"
        await addAction("E", DateTime.now(), data["ID"]);

        // Ensuite, met à jour l'état avec onUpdate
        onUpdate();
      },
    );
  }
}
