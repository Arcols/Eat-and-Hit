import 'dart:io';
import 'dart:convert';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:eat_and_hit/Vue/DetailsEleves.dart';
import 'package:eat_and_hit/Widgets/HitWidget.dart';
import 'package:eat_and_hit/Widgets/EatWidget.dart';
import 'Vue/addEtudiantPage.dart';
import 'fonctions/dataFonctions.dart';
import 'Vue/MonCompte.dart';
import 'Vue/Settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en'),
        Locale('fr'),
      ],
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
        // charger les données du tableau
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
        title: Text("Eat & Hit"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/appbar_background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () async {
              final nomprenom = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEtudiantPage(
                    onEtudiantAjoute: () {
                      updateState();
                    },
                  ),
                ),
              );
              await Future.delayed(Duration(milliseconds: 300)); // temps d'attente pour que l'étudiant s'affiche sur la liste
              updateState();
              var snackBar = SnackBar(
                content: Text('L\'étudiant '+nomprenom+' a bien été ajouté'),
                backgroundColor: Colors.grey,
                duration: const Duration(seconds: 2),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/appbar_background.jpg"), // ton image de fond
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.transparent, // Important pour voir l'image derrière
                ),
                child: Text(
                  "Menu",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title: Text("Mon Compte", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MonCompte()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text("Paramètres", style: TextStyle(color: Colors.white)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
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
  late String imagePath = "assets/images/prout.png";
  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    String newPath = await getImageEtu(widget.data[widget.index]["ID"]);
    setState(() {
      imagePath = newPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Detailseleves(data[index], widget.onUpdate),
            ),
          );
          _loadImage(); // recharge l’image quand on revient sur la page
        },
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          backgroundImage: AssetImage(imagePath),
        ),
      ),
      title: Row(
        children: <Widget>[
          Expanded(child: Text(data[index]["Nom"])) ,
          Expanded(child: Text(data[index]["Prenom"])) ,
          EatWidget(widget.data[widget.index], onUpdate: () {
            widget.onUpdate(); // Met à jour la liste complète
            _loadImage(); // Recharge l’image
          }),
          HitWidget(widget.data[widget.index], onUpdate: () {
            widget.onUpdate(); // Met à jour la liste complète
            _loadImage(); // Recharge l’image
          }),
        ],
      ),
    );
  }
}





