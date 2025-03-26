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
