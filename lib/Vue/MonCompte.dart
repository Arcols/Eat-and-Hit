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
    String etat = await getStatutUser(AppLocalizations.of(context)!);


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
        title: Text(loc.moncompte_titrepage),
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
              Text(loc.moncompte_totalFoodGiven(totalNourri), style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Text(loc.moncompte_totalHitsGiven(totalFrappe), style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Text(loc.moncompte_happyStudents(etuHeureux), style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
              Text(loc.moncompte_unhappyStudents(etuPasHeureux), style: TextStyle(fontSize: 18)),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
