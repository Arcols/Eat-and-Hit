import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:eat_and_hit/Widgets/HitWidget.dart';
import 'package:eat_and_hit/Widgets/EatWidget.dart';

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
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage("assets/images/angry.png"),
              ),
            ),
            SizedBox(height: 20),
            Text(
                "A été nourri ${getNbFoisFrappe()} fois",
                style: TextStyle(fontSize: 18)
            ),
            SizedBox(height: 10),
            Text(
                "A été frappé ${getNbFoisNourri()} fois",
                style: TextStyle(fontSize: 18)
            ),
          ],
        ),
      ),
    );
  }
}
