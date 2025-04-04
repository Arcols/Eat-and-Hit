import 'dart:async';

import 'package:flutter/material.dart';
import 'package:eat_and_hit/fonctions/dataFonctions.dart';

class HitWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback onUpdate;
  final double size;

  const HitWidget(
      this.data, {
      required this.onUpdate,
      this.size = 50,
      super.key
    });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SizedBox(
        width: this.size,
        height: this.size,
        child: Image.asset("assets/images/fist.png"),
      ),
      onPressed: () async {
        // Ajout de l'action "H"
        await addAction("H", DateTime.now(), data["ID"]);

        // Ensuite, met à jour l'état avec onUpdate
        onUpdate();
      },
    );
  }
}
