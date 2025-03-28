import 'package:flutter/material.dart';

import '../fonctions/dataFonctions.dart';

class HitWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const HitWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SizedBox(
        width: 50,
        height: 50,
        child : Image.asset("assets/images/fist.png"),
      ),
      onPressed: () {
        addAction("H", DateTime.now(), data["ID"]);
        var snackBar = SnackBar(
          content: Text('Vous venez d\'exploser la gueule à '+data["Prenom"]+' '+data["Nom"]+' !'),
          backgroundColor: Colors.grey,
          duration: const Duration(milliseconds: 1500),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
  }
}