import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _Settings();
}

class _Settings extends State<Settings> {
  String _selectedLanguage = 'fr'; // Valeur par défaut

  void _changeLanguage(String? value) {
    if (value != null) {
      setState(() {
        _selectedLanguage = value;
      });
      // Tu peux sauvegarder cette préférence avec SharedPreferences plus tard
      // Ex: await SharedPreferences.getInstance().then((prefs) => prefs.setString('lang', value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paramètres"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/appbar_background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        )
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text("Langue", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              DropdownButton<String>(
                value: _selectedLanguage,
                items: [
                  DropdownMenuItem(
                    value: 'fr',
                    child: Text('Français'),
                  ),
                  DropdownMenuItem(
                    value: 'en',
                    child: Text('English'),
                  ),
                ],
                onChanged: _changeLanguage,
              ),

              const SizedBox(height: 30),

              Text("Crédits", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text("Développé par Arthur Colson & Indi Blateau")
            ],
          ),
        )
      ),
    );
  }
}
