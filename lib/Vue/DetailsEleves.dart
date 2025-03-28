import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:eat_and_hit/Widgets/HitWidget.dart';
import 'package:eat_and_hit/Widgets/EatWidget.dart';
import '../fonctions/dataFonctions.dart';

class Detailseleves extends StatelessWidget {

  final Map<String, dynamic> contact;
  final VoidCallback onUpdate;

  Detailseleves(
      this.contact,
      this.onUpdate,
  );

  int getNbFoisNourri(){
    int compteur = 0;
    List<Map<String,dynamic>> actions= this.contact["Actions"];
    for(var action in actions){
      if(action["action"]=='E') compteur++;
    }
    return compteur;
  }
  int getNbFoisFrappe(){
    int compteur = 0;
    List<Map<String,dynamic>> actions= this.contact["Actions"];
    for(var action in actions){
      if(action["action"]=='H') compteur++;
    }
    return compteur;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact["Nom"] + " " + contact["Prenom"]),
        actions: [
          EatWidget(contact,onUpdate: onUpdate,),
          HitWidget(contact),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 20),
            Center(
              child: FutureBuilder<String>(
                future: getImageEtu(contact['ID']), // Appelle la fonction avec l'ID de l'étudiant
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey,
                      child: CircularProgressIndicator(), // Affiche un indicateur de chargement en attendant l'image
                    );
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey,
                      backgroundImage: AssetImage("assets/images/prout.png"), // Image par défaut en cas d'erreur
                    );
                  } else {
                    return CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey,
                      backgroundImage: AssetImage(snapshot.data!), // Affiche l'image récupérée
                    );
                  }
                },
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
