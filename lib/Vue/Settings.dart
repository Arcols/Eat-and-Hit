import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _Settings();
}

class _Settings extends State<Settings> {
  String _selectedLanguage = 'fr';

  void _changeLanguage(String? value) {
    if (value != null) {
      setState(() {
        _selectedLanguage = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Credits"),
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
              Text("Développé par Arthur Colson & Indi Blateau")
            ],
          ),
        )
      ),
    );
  }
}
