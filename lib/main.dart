import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:eat_and_hit/Vue/DetailsEleves.dart';
import 'package:eat_and_hit/Widgets/HitWidget.dart';
import 'package:eat_and_hit/Widgets/EatWidget.dart';

import 'fonctions/dataFonctions.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeJsonFile(); // Initialiser le fichier JSON local car assets est un dossier immuable
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Eat & Hit',
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
      });
    });
  }

  void updateState() {
    loadData().then((loadedData) {
      setState(() {
        // charger les données à l'appui sur un bouton
        data = loadedData;
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
        title: Text('Eat & Hit'),
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
                  return LigneEleve(
                    data: data,
                    index: index,
                    onUpdate: updateState,
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


// a passer en statefull pour les smileys
class LigneEleve extends StatefulWidget {
  const LigneEleve({
    super.key,
    required this.data,
    required this.index,
    required this.onUpdate,
  });

  final List<Map<String, dynamic>> data;
  final int index;
  final VoidCallback onUpdate;

  @override
  State<LigneEleve> createState() => _LigneEleveState();
}

class _LigneEleveState extends State<LigneEleve> {
  get data => widget.data;
  get index => widget.index;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Detailseleves(data[index],widget.onUpdate),
            ),
          );
        },
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: Image.asset("assets/images/angry.png").image,
        ),
      ),
      title: Row(
        children: <Widget>[
          Expanded(child: Text(data[index]["Nom"])) ,
          Expanded(child: Text(data[index]["Prenom"])) ,
          EatWidget(data[index], onUpdate: widget.onUpdate),
          HitWidget(data[index]),
        ],
      ),
    );
  }
}





