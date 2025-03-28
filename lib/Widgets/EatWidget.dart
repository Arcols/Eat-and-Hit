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
      onPressed: () {
        addAction("E", DateTime.now(), data["ID"]);
        onUpdate();
        var snackBar = SnackBar(
          content: Text('Vous venez de donner à manger à '+data["Prenom"]+' '+data["Nom"]+' !'),
          backgroundColor: Colors.grey,
          duration: const Duration(milliseconds: 1500),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
    );
  }
}
