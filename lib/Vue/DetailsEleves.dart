import 'dart:io';
import 'dart:convert';
import 'package:eat_and_hit/fonctions/readjson.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:eat_and_hit/Widgets/HitWidget.dart';
import 'package:eat_and_hit/Widgets/EatWidget.dart';

class Detailseleves extends StatelessWidget {
  final Map<String, dynamic> contact;
  Detailseleves(this.contact);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contact["Nom"]+" "+contact["Prenom"]),
        actions: [
          EatWidget(contact["ID"]),
          HitWidget(contact["ID"])
        ],),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("First Name: ${contact["Nom"]}", style: TextStyle(fontSize: 18)),
            Text("Last Name: ${contact["Prenom"]}", style: TextStyle(fontSize: 18)),
            Text("Sexe: ${contact["Sexe"]}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}