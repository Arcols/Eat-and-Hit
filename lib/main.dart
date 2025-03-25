import 'dart:io';
import 'dart:convert';
import 'package:eat_and_hit/readjson.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contacts App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactListPage(),
    );
  }
}

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    loadData().then((loadedData) {
      setState(() {
        // charger les données au lancement de l'application
        data = loadedData;
        print("Données chargées: $data");
      });
    });
  }

  void addEtudiant() {
    // Fonction pour récupérer des données (ajouter la logique ici)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: addEtudiant,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: ListView.builder( // construit la liste dynamiquement en fonction du nombre d'étudiants
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => APIDetailView(data[index]),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        backgroundImage: Image.asset("assets/images/prout.png").image,
                      ),
                    ),
                    title: Row(
                      children: <Widget>[
                        Expanded(child: Text(data[index]["Nom"])) ,
                        Expanded(child: Text(data[index]["Prenom"])) ,
                        Expanded(child: Text(data[index]["Sexe"])) ,
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class APIDetailView extends StatelessWidget {
  final Map<String, dynamic> contact;
  APIDetailView(this.contact);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact Details")),
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