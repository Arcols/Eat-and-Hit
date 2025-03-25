import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contacts App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactListPage(),
    );
  }
}

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  List<Map<String, dynamic>> data = [
    {"FirstName": "John", "LastName": "Doe", "Bill_City": "New York", "Customer_Id": "12345"},
    {"FirstName": "Jane", "LastName": "Smith", "Bill_City": "Los Angeles", "Customer_Id": "67890"},
  ];

  void addEtudiant() {
    // Fonction pour récupérer des données (ajouter la logique ici)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: addEtudiant,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: ListView.builder( // construit la liste dynamiquement en fonction du nombre d'étudiants
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell( // rend l'élément clicable
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => APIDetailView(data[index]),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(data[index]["FirstName"][0]),
                      ),
                      title: Row(
                        children: <Widget>[
                          Expanded(child: Text(data[index]["FirstName"])) ,
                          Expanded(child: Text(data[index]["LastName"])) ,
                          Expanded(child: Text(data[index]["Bill_City"])) ,
                          Expanded(child: Text(data[index]["Customer_Id"])) ,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class APIDetailView extends StatelessWidget {
  final Map<String, dynamic> contact;
  APIDetailView(this.contact);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contact Details")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("First Name: ${contact["FirstName"]}", style: TextStyle(fontSize: 18)),
            Text("Last Name: ${contact["LastName"]}", style: TextStyle(fontSize: 18)),
            Text("City: ${contact["Bill_City"]}", style: TextStyle(fontSize: 18)),
            Text("Customer ID: ${contact["Customer_Id"]}", style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}