import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<List<Map<String, dynamic>>> loadData() async {
  try {
    // Lire le fichier JSON depuis assets/data.json
    String jsonString = await rootBundle.loadString('assets/data.json');

    // Convertir le JSON en Map
    Map<String, dynamic> jsonData = json.decode(jsonString);

    // Récupérer étudiants et actions
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
        "ID": etu["id"].toString(),
        "Actions": etuActions, // Liste des actions associées
      };
    }).toList();

    return formattedData;
  } catch (e) {
    print("Erreur lors du chargement des données : $e");
    return [];
  }
}
