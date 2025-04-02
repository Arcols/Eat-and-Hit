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
    print(directory.path);
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
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json');

    // Vérifie si le fichier existe avant de tenter de le lire
    if (!file.existsSync()) {
      print("Erreur : fichier data.json introuvable !");
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
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json'); // Utilisation du bon répertoire
    if (!file.existsSync()) {
      print("Fichier data.json introuvable !");
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
      print("Étudiant non trouvé !");
      return "assets/images/default.png"; // Image par défaut si l'étudiant n'existe pas
    }

    // Filtrer les actions de l'étudiant avec la bonne condition
    List actionsEtu = jsonData["actions"].where((action) => action["id_etu"] == idEtu).toList();

    // Compter le nombre d'actions "E" et "H"
    int countE = actionsEtu.where((action) => action["action"] == "E").length;
    int countH = actionsEtu.where((action) => action["action"] == "H").length;
    print(countH);
    print(countE);

    // Récupérer le sexe de l'étudiant
    String sexe = etudiant["sexe"];

    // Choisir l'image en fonction du nombre d'actions "E" ou "H"
    if (countE >= countH) {
      // Si le nombre d'actions "E" est supérieur ou égal au nombre d'actions "H"
      return sexe == "M" ? "assets/images/heureux.png" : "assets/images/heureuse.png";
    } else {
      // Si le nombre d'actions "H" est supérieur au nombre d'actions "E"
      return sexe == "M" ? "assets/images/angry.png" : "assets/images/grognasse.png";
    }
  } catch (e) {
    print("Erreur lors de la récupération de l'image : $e");
    return "assets/images/default.png"; // Image par défaut en cas d'erreur
  }
}



Future<int> getTotalEat() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json'); // Utilisation du bon répertoire
    if (!file.existsSync()) {
      print("Fichier data.json introuvable !");
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
    print("Erreur lors de la récupération de l'image : $e");
    return -1;
  }
}

Future<int> getTotalHit() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json'); // Utilisation du bon répertoire
    if (!file.existsSync()) {
      print("Fichier data.json introuvable !");
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
    print("Erreur lors de la récupération de l'image : $e");
    return -1;
  }
}

Future<int> getNombreEtuHeureux() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json');

    if (!file.existsSync()) {
      print("Fichier data.json introuvable !");
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
      if (countE >= countH) {
        happyStudents++;
      }
    }

    return happyStudents;
  } catch (e) {
    print("Erreur lors du calcul des étudiants heureux : $e");
    return -1;
  }
}


Future<int> getNombreEtu() async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/data.json');

    if (!file.existsSync()) {
      print("Fichier data.json introuvable !");
      return -1;
    }

    // Lire le fichier JSON local
    String jsonString = await file.readAsString();
    Map<String, dynamic> jsonData = json.decode(jsonString);

    List etudiants = jsonData["etudiants"];

    return etudiants.length;
  } catch (e) {
    print("Erreur lors du comptage des étudiants : $e");
    return -1;
  }
}


Future<String> getStatutUser() async{
  int nbEat= await getTotalEat();
  int nbHit= await getTotalHit();
  int etuContent = await getNombreEtuHeureux();
  int nbEtu = await getNombreEtu();
  int etuPasContent = nbEtu-etuContent;
  if (nbEat>1 && nbHit==0){
    return "Vous avez la bonté incarnée ! Restez comme ça ! (ou pas...)";
  } else if (nbHit>1 && nbEat==0){
    return "Vous êtes le mal incarné ! HIHIHI !";
  } else if (nbHit>nbEat && etuContent>etuPasContent){
    return "Vous vous acharnez sur certains étudiants ! C'est pas gentil d'être méchant !";
  } else if (nbHit<nbEat && etuContent<etuPasContent){
    return "Vous appréciez très peu d'étudiants ! La nourriture peu se partager !";
  } else if (nbHit>nbEat && etuContent<etuPasContent){
    return "Vous aimez vraiment pas les étudiants, il existe d'autres métiers vous savez ?";
  } else if (nbHit<nbEat && etuContent<etuPasContent){
    return "Ce métier est vraiment fait pour vous, vous appréciez vraiment vos étudiants !";
  } else {
    return "Rien ne s'est passé pour l'instant ...";
  }
}

