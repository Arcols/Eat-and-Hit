import 'package:flutter/material.dart';
import 'package:eat_and_hit/fonctions/dataFonctions.dart';

class EatWidget extends StatelessWidget {
  final Map<String, dynamic> data;

  const EatWidget(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SizedBox(
        width: 50,
        height: 50,
        child: Image.asset("assets/images/eat.png"),
      ),
      onPressed: () {
        addAction("E", DateTime.now(), data["ID"]);

        var snackBar = SnackBar(
          content: Text('Vous venez de donner à manger à '+data["Prenom"]+' '+data["Nom"]+' !'),
          backgroundColor: Colors.grey,
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
  }
}
