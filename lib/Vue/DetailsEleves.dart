import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:eat_and_hit/Widgets/HitWidget.dart';
import 'package:eat_and_hit/Widgets/EatWidget.dart';
import '../fonctions/dataFonctions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    imagePath = "assets/images/default.png"; // Image par défaut
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

  void _handleEat() async {
    setState(() {
      // Ajouter l'action "E" et mettre à jour immédiatement l'interface
      etudiant["Actions"].add({"action": "E", "date": DateTime.now().toString()});
      imagePath = "assets/images/loading.png"; // Image temporaire pendant le chargement
    });

    widget.onUpdate(); // Met à jour la liste principale

    // Charger l'image après l'action et rafraîchir l'interface
    await _loadImage();
  }

  void _handleHit() async {
    setState(() {
      // Ajouter l'action "H" et mettre à jour immédiatement l'interface
      etudiant["Actions"].add({"action": "H", "date": DateTime.now().toString()});
      imagePath = "assets/images/default.png"; // Image temporaire pendant le chargement
    });

    widget.onUpdate(); // Met à jour la liste principale

    // Charger l'image après l'action et rafraîchir l'interface
    await _loadImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${etudiant["Nom"]} ${etudiant["Prenom"]}"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/appbar_background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: MediaQuery.of(context).orientation == Orientation.portrait // Récupérer l'orientation de l'écran
            ? [
          EatWidget(etudiant, onUpdate: _handleEat),
          HitWidget(etudiant, onUpdate: _handleHit),
        ]
            : null, // Pas d'actions en paysage
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
          image: AssetImage("assets/images/background.jpg"),
          fit: BoxFit.cover,
          ),
        ),
      child: OrientationBuilder(
          builder: (context, orientation) { //builder est une fonction qui prend en paramètre le context et l'orientation.
            if (orientation == Orientation.portrait) {
              return _buildPortraitLayout();
            } else {
              return _buildLandscapeLayout();
            }
          },
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(){
    final loc = AppLocalizations.of(context)!;
    return Padding(
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
            loc.details_eleves_nbfoisnourri(getNbFoisNourri()),
            style: TextStyle(fontSize: 18),
          ),
          SizedBox(height: 10),
          Text(
            loc.details_eleves_nbfoisfrappe(getNbFoisFrappe()),
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscapeLayout(){
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          // Partie Image (50% de l'écran)
          Expanded(
            flex: 2,
            child: Center(
              child: CircleAvatar(
                radius: MediaQuery.of(context).size.width * 0.15, // Taille adaptative
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage(imagePath),
              ),
            ),
          ),
          // Partie Texte (50% de l'écran)
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.details_eleves_nbfoisnourri(getNbFoisNourri()),
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 10),
                Text(
                  loc.details_eleves_nbfoisfrappe(getNbFoisFrappe()),
                  style: TextStyle(fontSize: 18),
                ),
                Row(
                  children: [
                    EatWidget(etudiant, onUpdate: _handleEat,size:70),
                    HitWidget(etudiant, onUpdate: _handleHit,size:70),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
