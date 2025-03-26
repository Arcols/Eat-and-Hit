import 'package:flutter/material.dart';
import 'package:eat_and_hit/fonctions/dataFonctions.dart';

class EatWidget extends StatelessWidget {
  final int id;

  const EatWidget(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SizedBox(
        width: 50,
        height: 50,
        child: Image.asset("assets/images/eat.png"),
      ),
      onPressed: () {
        addAction("E", DateTime.now(), id);
      },
    );
  }
}
