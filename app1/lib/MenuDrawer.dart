import 'package:app1/subchapter1.dart';
import 'package:flutter/material.dart';

class MenuDrawer extends StatefulWidget {
  const MenuDrawer({super.key});

  @override
  State<MenuDrawer> createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Reonagi"),
            accountEmail: Text("mikagereohandsomeandcool@gmail.com"),
            currentAccountPicture: CircleAvatar(
              child: Image.asset("images/loco.png"),
            ),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          Card(
            elevation: 20,
            shadowColor: Colors.blueGrey,
            child: ListTile(
              title: Text(
                "Lesson 1",
                style: TextStyle(
                  color: const Color.fromARGB(255, 7, 39, 65),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              leading: Icon(Icons.book, color: Colors.blueGrey, size: 25),

              onTap: () {
                // Navigator.of(context).pop();
                MaterialPageRoute route = MaterialPageRoute(
                  builder: (c) => subchapter1(),
                );
                Navigator.of(context).push(route);
              },
            ),
          ),

          Card(
            elevation: 20,
            shadowColor: Colors.blueGrey,
            child: ListTile(
              title: Text(
                "Lesson 2",
                style: TextStyle(
                  color: const Color.fromARGB(255, 7, 39, 65),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              leading: Icon(Icons.book, color: Colors.blueGrey, size: 25),

              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),

          Card(
            elevation: 20,
            shadowColor: Colors.blueGrey,
            child: ListTile(
              title: Text(
                "Lesson 3",
                style: TextStyle(
                  color: const Color.fromARGB(255, 7, 39, 65),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              leading: Icon(Icons.book, color: Colors.blueGrey, size: 25),

              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),

          Card(
            elevation: 20,
            shadowColor: Colors.blueGrey,
            child: ListTile(
              title: Text(
                "Lesson 4",
                style: TextStyle(
                  color: const Color.fromARGB(255, 7, 39, 65),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              leading: Icon(Icons.book, color: Colors.blueGrey, size: 25),

              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),

          Card(
            elevation: 20,
            shadowColor: Colors.blueGrey,
            child: ListTile(
              title: Text(
                "Lesson 5",
                style: TextStyle(
                  color: const Color.fromARGB(255, 7, 39, 65),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              leading: Icon(Icons.book, color: Colors.blueGrey, size: 25),

              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),

          Card(
            elevation: 20,
            shadowColor: Colors.blueGrey,
            child: ListTile(
              title: Text(
                "Lesson 6",
                style: TextStyle(
                  color: const Color.fromARGB(255, 7, 39, 65),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              leading: Icon(Icons.book, color: Colors.blueGrey, size: 25),

              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),

          Card(
            elevation: 20,
            shadowColor: Colors.blueGrey,
            child: ListTile(
              title: Text(
                "Lesson 7",
                style: TextStyle(
                  color: const Color.fromARGB(255, 7, 39, 65),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              leading: Icon(Icons.book, color: Colors.blueGrey, size: 25),

              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}
