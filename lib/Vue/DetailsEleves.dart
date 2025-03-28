import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:eat_and_hit/Widgets/HitWidget.dart';
import 'package:eat_and_hit/Widgets/EatWidget.dart';
import '../fonctions/dataFonctions.dart';

class Detailseleves extends StatefulWidget {
  final Map<String, dynamic> initialEtu;
  final VoidCallback onUpdate;

  Detailseleves(this.initialEtu, this.onUpdate, {Key? key}) : super(key: key);

  @override
  _DetailselevesState createState() => _DetailselevesState();
}

class _DetailselevesState extends State<Detailseleves> {
  late Map<String, dynamic> etudiant;
  late String imagePath;

  @override
  void initState() {
    super.initState();
    etudiant = Map.from(widget.initialEtu); // Cloner les données pour les modifier localement
    imagePath = "assets/images/prout.png"; // Image par défaut
    _loadImage(); // Charge l'image initiale
  }

  Future<void> _loadImage() async {
    // Charger l'image en tâche de fond
    String newPath = await getImageEtu(etudiant["ID"]);

    // Mettre à jour l'image immédiatement après le calcul
    if (mounted) {
      setState(() {
        imagePath = newPath;
      });
    }
  }

  int getNbFoisNourri() {
    return etudiant["Actions"].where((a) => a["action"] == 'E').length;
  }

  int getNbFoisFrappe() {
    return etudiant["Actions"].where((a) => a["action"] == 'H').length;
  }

  void _handleEat() {
    setState(() {
      // Ajouter l'action "E" et mettre à jour immédiatement l'interface
      etudiant["Actions"].add({"action": "E", "date": DateTime.now().toString()});
    });

    // Charger l'image après l'action et rafraîchir l'interface
    widget.onUpdate();
    _loadImage();
  }

  void _handleHit() {
    setState(() {
      // Ajouter l'action "H" et mettre à jour immédiatement l'interface
      etudiant["Actions"].add({"action": "H", "date": DateTime.now().toString()});
    });

    // Charger l'image après l'action et rafraîchir l'interface
    widget.onUpdate();
    _loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${etudiant["Nom"]} ${etudiant["Prenom"]}"),
        actions: [
          EatWidget(etudiant, onUpdate: _handleEat),
          HitWidget(etudiant, onUpdate: _handleHit),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage(imagePath),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "A été nourri ${getNbFoisNourri()} fois",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              "A été frappé ${getNbFoisFrappe()} fois",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
