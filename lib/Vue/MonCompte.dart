import 'package:flutter/material.dart';
import '../fonctions/dataFonctions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MonCompte extends StatefulWidget {
  @override
  _MonCompteState createState() => _MonCompteState();
}

class _MonCompteState extends State<MonCompte> {
  int totalNourri = 0;
  int totalFrappe = 0;
  int etuHeureux = 0;
  int etuPasHeureux = 0;
  String statutUser = "";

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    List<Map<String, dynamic>> etudiants = await loadData();

    int nourri = await getTotalEat();
    int frappe = await getTotalHit();
    int content = await getNombreEtuHeureux();
    int nombreEtu = await getNombreEtu();
    String etat = await getStatutUser();


    setState(() {
      totalNourri = nourri;
      totalFrappe = frappe;
      etuHeureux =content;
      etuPasHeureux=nombreEtu-content;
      statutUser = etat;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.accountTitle),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/appbar_background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),),
      body: Container(
        decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.jpg"),
          fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$statutUser ", style: TextStyle(fontSize: 26),textAlign: TextAlign.center),
              SizedBox(height: 50),
              Text("Nombre de pains (nourriture) donnés : $totalNourri fois", style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Text("Nombre de pains (coups) donnés : $totalFrappe fois", style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Text("Nombre d'étudiants contents : $etuHeureux", style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Text("Nombre d'étudiants pas contents : $etuPasHeureux", style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
