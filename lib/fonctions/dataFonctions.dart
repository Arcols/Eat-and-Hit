import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

/// Écriture du contenu de data.json dans un fichier local du téléphone
Future<void> initializeJsonFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/data.json');

  if (!file.existsSync()) {
    String assetContent = await rootBundle.loadString('assets/data.json');
    await file.writeAsString(assetContent);
  }
}

/// Ajoute une action dans le fichier JSON local
Future<void> addAction(String action, DateTime date, int idEtu) async {
  try {
    // Obtenez le répertoire des documents
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json');

    // Lire le contenu actuel du fichier JSON
    String content = await file.readAsString();
    Map<String, dynamic> jsonData = jsonDecode(content);

    // Ajouter une nouvelle action
    Map<String, dynamic> newAction = {
      "id": jsonData["actions"].length + 1, // ID auto-incrémenté
      "action": action,
      "horaire": DateFormat('yyyy-MM-dd HH:mm:ss').format(date),
      "id_etu": idEtu
    };

    jsonData["actions"].add(newAction);

    // Réécrire le contenu mis à jour dans le fichier JSON
    await file.writeAsString(jsonEncode(jsonData));

    print("Nouvelle action ajoutée !");
  } catch (e) {
    print("Erreur : $e");
  }
}

/// Charge toutes les actions stockées dans le fichier JSON
Future<List<dynamic>> getActions() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json');
    String content = await file.readAsString();
    Map<String, dynamic> jsonData = jsonDecode(content);

    return jsonData["actions"];
  } catch (e) {
    print("Erreur : $e");
    return [];
  }
}


Future<List<Map<String, dynamic>>> loadData() async {
  try {

    // Lire le fichier JSON
    final directory = await getApplicationDocumentsDirectory();
    String jsonString = await rootBundle.loadString('${directory.path}/data.json');

    Map<String, dynamic> jsonData = json.decode(jsonString);

    List<Map<String, dynamic>> etudiants = List<Map<String, dynamic>>.from(jsonData["etudiants"]);
    List<Map<String, dynamic>> actions = List<Map<String, dynamic>>.from(jsonData["actions"]);

    // Associer les actions à chaque étudiant
    List<Map<String, dynamic>> formattedData = etudiants.map((etu) {
      List<Map<String, dynamic>> etuActions =
      actions.where((act) => act["id_etu"] == etu["id"]).toList();

      return {
        "Prenom": etu["prenom"],
        "Nom": etu["nom"],
        "Sexe": etu["sexe"],
        "ID": etu["id"],
        "Actions": etuActions, // Liste des actions associées
      };
    }).toList();

    return formattedData;
  } catch (e) {
    print("Erreur lors du chargement des données : $e");
    return [];
  }
}


Future<String> getImageEtu(int idEtu) async {
  try {
    // Lire le fichier JSON
    String jsonString = await rootBundle.loadString('assets/data.json');
    Map<String, dynamic> jsonData = json.decode(jsonString);

    // Chercher l'étudiant correspondant à l'ID donné
    var etudiant = jsonData["etudiants"]
        .firstWhere((etu) => etu["id"] == idEtu, orElse: () => null);

    // Vérifier si l'étudiant existe
    if (etudiant == null) {
      print("Étudiant non trouvé !");
      return "assets/images/prout.png"; // Image par défaut si l'étudiant n'existe pas
    }

    // Filtrer les actions de l'étudiant avec la bonne condition
    List actionsEtu = jsonData["actions"].where((action) => action["id_etu"] == idEtu).toList();

    // Compter le nombre d'actions "E" et "H"
    int countE = actionsEtu.where((action) => action["action"] == "E").length;
    int countH = actionsEtu.where((action) => action["action"] == "H").length;

    // Récupérer le sexe de l'étudiant
    String sexe = etudiant["sexe"];

    // Choisir l'image en fonction du nombre d'actions "E" ou "H"
    if (countE >= countH) {
      // Si le nombre d'actions "E" est supérieur ou egal au nombre d'actions "H"
      return sexe == "M" ? "assets/images/heureux.png" : "assets/images/heureuse.png";
    } else {
      // Si le nombre d'actions "H" est supérieur au nombre d'actions "E"
      return sexe == "M" ? "assets/images/angry.png" : "assets/images/grognasse.png";
    }
  } catch (e) {
    print("Erreur lors de la récupération de l'image : $e");
    return "assets/images/prout.png"; // Image par défaut en cas d'erreur
  }
}

