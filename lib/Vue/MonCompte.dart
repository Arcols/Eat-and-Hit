import 'package:flutter/material.dart';
import '../fonctions/dataFonctions.dart';

class MonCompte extends StatefulWidget {
  @override
  _MonCompteState createState() => _MonCompteState();
}

class _MonCompteState extends State<MonCompte> {
  int totalNourri = 0;
  int totalFrappe = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    List<Map<String, dynamic>> etudiants = await loadData();

    int nourri = 0;
    int frappe = 0;


    setState(() {
      totalNourri = nourri;
      totalFrappe = frappe;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Mon Compte")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Total de nourritures données : $totalNourri", style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text("Total de frappes effectuées : $totalFrappe", style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadStats, // Recharge les stats manuellement
              child: Text("Rafraîchir les stats"),
            ),
          ],
        ),
      ),
    );
  }
}
