import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


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

  } catch (e) {
    print("Erreur : $e");
  }
}

Future<void> addEtudiant(String nom, String prenom, String genre,bool bdsm) async {
  try {
    // Obtenez le répertoire des documents
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json');

    // Lire le contenu actuel du fichier JSON
    String content = await file.readAsString();
    Map<String, dynamic> jsonData = jsonDecode(content);

    // Ajouter une nouvelle action
    Map<String, dynamic> newAction = {
      "id": jsonData["etudiants"].length + 1,
      "nom": nom,
      "prenom": prenom,
      "sexe": genre,
      "bdsm": bdsm
    };

    jsonData["etudiants"].add(newAction);

    // Réécrire le contenu mis à jour dans le fichier JSON
    await file.writeAsString(jsonEncode(jsonData));
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
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json');

    // Vérifie si le fichier existe avant de tenter de le lire
    if (!file.existsSync()) {
      return [];
    }

    String jsonString = await file.readAsString();
    Map<String, dynamic> jsonData = jsonDecode(jsonString);

    List<Map<String, dynamic>> etudiants = List<Map<String, dynamic>>.from(jsonData["etudiants"]);
    List<Map<String, dynamic>> actions = List<Map<String, dynamic>>.from(jsonData["actions"]);

    // Associe les actions aux étudiants
    List<Map<String, dynamic>> formattedData = etudiants.map((etu) {
      List<Map<String, dynamic>> etuActions =
      actions.where((act) => act["id_etu"] == etu["id"]).toList();

      return {
        "Prenom": etu["prenom"],
        "Nom": etu["nom"],
        "Sexe": etu["sexe"],
        "ID": etu["id"],
        "bdsm": etu["bdsm"],
        "Actions": etuActions, // Liste des actions associées
      };
    }).toList();

    return formattedData;
  } catch (e) {
    return [];
  }
}



Future<String> getImageEtu(int idEtu) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json'); // Utilisation du bon répertoire
    if (!file.existsSync()) {
      return "assets/images/default.png"; // Image par défaut si le fichier n'existe pas
    }

    // Lire le fichier JSON local
    String jsonString = await file.readAsString();
    Map<String, dynamic> jsonData = json.decode(jsonString);

    // Chercher l'étudiant correspondant à l'ID donné
    var etudiant = jsonData["etudiants"]
        .firstWhere((etu) => etu["id"] == idEtu, orElse: () => null);

    // Vérifier si l'étudiant existe
    if (etudiant == null) {
      return "assets/images/default.png"; // Image par défaut si l'étudiant n'existe pas
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
      if(etudiant["bdsm"]){
        return sexe == "M" ? "assets/images/angry.png" : "assets/images/grognasse.png";
      }
      // Si le nombre d'actions "E" est supérieur ou égal au nombre d'actions "H"
      return sexe == "M" ? "assets/images/heureux.png" : "assets/images/heureuse.png";
    } else {
      if(etudiant["bdsm"]){
        return sexe == "M" ? "assets/images/heureux.png" : "assets/images/heureuse.png";
      }
      // Si le nombre d'actions "H" est supérieur au nombre d'actions "E"
      return sexe == "M" ? "assets/images/angry.png" : "assets/images/grognasse.png";
    }
  } catch (e) {
    return "assets/images/default.png"; // Image par défaut en cas d'erreur
  }
}

// pour supprimer le fichier de data si jamais il est rempli de nimp / bug
Future<void> deleteFile() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/data.json');

  if (await file.exists()) {
    await file.delete();
  } else {
    print("Le fichier n'existe pas.");
  }
}




Future<int> getTotalEat() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json'); // Utilisation du bon répertoire
    if (!file.existsSync()) {
      return -1;
    }

    // Lire le fichier JSON local
    String jsonString = await file.readAsString();
    Map<String, dynamic> jsonData = json.decode(jsonString);
    List actionsEtu = jsonData["actions"].toList();

    // Compter le nombre d'actions "E"
    int countE = actionsEtu.where((action) => action["action"] == "E").length;
    return countE;
  } catch (e) {
    return -1;
  }
}

Future<int> getTotalHit() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json'); // Utilisation du bon répertoire
    if (!file.existsSync()) {
      return -1;
    }

    // Lire le fichier JSON local
    String jsonString = await file.readAsString();
    Map<String, dynamic> jsonData = json.decode(jsonString);
    List actionsEtu = jsonData["actions"].toList();

    // Compter le nombre d'actions "H"
    int countH = actionsEtu.where((action) => action["action"] == "H").length;
    return countH;
  } catch (e) {
    return -1;
  }
}

Future<int> getNombreEtuHeureux() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json');

    if (!file.existsSync()) {
      return -1;
    }

    // Lire le fichier JSON local
    String jsonString = await file.readAsString();
    Map<String, dynamic> jsonData = json.decode(jsonString);

    List<Map<String, dynamic>> etudiants = List<Map<String, dynamic>>.from(jsonData["etudiants"]);
    List<Map<String, dynamic>> actions = List<Map<String, dynamic>>.from(jsonData["actions"]);

    int happyStudents = 0;

    for (var etudiant in etudiants) {
      int idEtu = etudiant["id"];

      // Filtrer les actions de cet étudiant
      List<Map<String, dynamic>> actionsEtu = actions.where((act) => act["id_etu"] == idEtu).toList();

      // Compter le nombre d'actions "E" et "H"
      int countE = actionsEtu.where((action) => action["action"] == "E").length;
      int countH = actionsEtu.where((action) => action["action"] == "H").length;

      // L'étudiant est heureux si le nombre de "E" est supérieur ou égal à "H"
      if (etudiant["bdsm"]) {
        if (countE <= countH) {
          happyStudents++;
        }
      } else {
        if (countE >= countH) {
          happyStudents++;
        }
      }
    }

    return happyStudents;
  } catch (e) {
    return -1;
  }
}


Future<int> getNombreEtu() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json');

    if (!file.existsSync()) {
      return -1;
    }

    // Lire le fichier JSON local
    String jsonString = await file.readAsString();
    Map<String, dynamic> jsonData = json.decode(jsonString);

    List etudiants = jsonData["etudiants"];

    return etudiants.length;
  } catch (e) {
    return -1;
  }
}


Future<String> getStatutUser(AppLocalizations loc) async{
  int nbEat= await getTotalEat();
  int nbHit= await getTotalHit();
  int etuContent = await getNombreEtuHeureux();
  int nbEtu = await getNombreEtu();
  int etuPasContent = nbEtu-etuContent;
  if (nbEat>1 && nbHit==0){
    return loc.moncompte_etat_gentil;
  } else if (nbHit>1 && nbEat==0){
    return loc.moncompte_etat_pasgentil;
  } else if (nbHit>nbEat && etuContent>etuPasContent){
    return loc.moncompte_etat_passigentil;
  } else if (nbHit<nbEat && etuContent<etuPasContent){
    return loc.moncompte_etat_unpeugentil;
  } else if (nbHit>nbEat && etuContent<etuPasContent){
    return loc.moncompte_etat_pasgentildutout;
  } else if (nbHit<nbEat && etuContent<etuPasContent){
    return loc.moncompte_etat_supergentil;
  } else if (etuPasContent==etuContent){
    return loc.moncompte_etat_normal;
  } else {
    return loc.moncompte_etat_vide;
  }
}

