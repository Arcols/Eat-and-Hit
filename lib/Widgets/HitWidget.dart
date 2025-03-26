import 'package:flutter/material.dart';

import '../fonctions/dataFonctions.dart';

class HitWidget extends StatelessWidget {
  final int id;

  const HitWidget(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SizedBox(
        width: 50,
        height: 50,
        child : Image.asset("assets/images/fist.png"),
      ),
      onPressed: () {
        addAction("H", DateTime.now(), id);
      },
    );
  }
}