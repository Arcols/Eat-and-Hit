import 'package:eat_and_hit/fonctions/dataFonctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddEtudiantPage extends StatelessWidget{

  final VoidCallback onEtudiantAjoute;

  const AddEtudiantPage({required this.onEtudiantAjoute, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
        appBar: AppBar(
        title: Text(loc.add_etudiant_titre),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/appbar_background.jpg"),
              fit: BoxFit.cover,
            ),
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
      child: ZoneSaisie(onEtudiantAjoute: onEtudiantAjoute, loc:loc),
      ),
    );
  }
}

class ZoneSaisie extends StatefulWidget {

  final VoidCallback onEtudiantAjoute;
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final AppLocalizations loc;
  ZoneSaisie({
    required this.onEtudiantAjoute,
    super.key, required this.loc
  });

  State<ZoneSaisie> createState() => _ZoneSaisieState(loc);

}
enum genre {M,W}

class _ZoneSaisieState extends State<ZoneSaisie> {
  genre? _genre = genre.M;
  bool bdsm = false;
  final AppLocalizations loc;
  final ButtonStyle _buttonStyle = ElevatedButton.styleFrom(
    foregroundColor: Colors.white,
    backgroundColor: Colors.blue,
    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(2)),
    ),
  );

  _ZoneSaisieState(this.loc);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),

            TextField(
              controller: widget.nomController ,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: loc.add_etudiant_nom,
                labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 30),
            TextField(
              controller: widget.prenomController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: loc.add_etudiant_prenom,
                labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  children: [
                    Radio<genre>(
                      value: genre.M,
                      groupValue: _genre,
                      onChanged: (genre? value) {
                        setState(() {
                          _genre = value;
                        });
                      },
                    ),
                    Text(
                      loc.add_etudiant_homme,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: _genre == genre.M ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20),
                Row(
                  children: [
                    Radio<genre>(
                      value: genre.W,
                      groupValue: _genre,
                      onChanged: (genre? value) {
                        setState(() {
                          _genre = value;
                        });
                      },
                    ),
                    Text(
                      loc.add_etudiant_femme,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: _genre == genre.W ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded( // Adaptation des débordements
                  child: Text(
                    bdsm
                        ? loc.add_etudiant_aimesefairetaper
                        : loc.add_etudiant_aimepasefairetaper,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                    softWrap: true, // retour à la ligne automatique
                  ),
                ),
                Switch(
                  value: bdsm,
                  activeColor: Colors.red,
                  onChanged: (bool value) {
                    setState(() {
                      bdsm = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: _buttonStyle,
              onPressed: () {
                if(widget.nomController.text == '' || widget.prenomController.text ==''){
                  var snackBar = SnackBar(
                    content: Text(loc.add_etudiant_snackbar_error),
                    backgroundColor: Colors.grey,
                    duration: const Duration(seconds: 2),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }else{
                  String genreString = _genre == genre.M ? 'M' : 'W';
                  addEtudiant(widget.nomController.text, widget.prenomController.text, genreString, bdsm);
                  widget.onEtudiantAjoute();
                  Navigator.pop(context,widget.nomController.text+' '+widget.prenomController.text);
                }
              },
              child: Text(loc.add_etudiant_addbutton),
            )
          ],
        ),
      )
    );
  }
}