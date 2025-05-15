import 'package:app1/BottomBar.dart';
import 'package:app1/MenuDrawer.dart';
import 'package:app1/menubutton/SettingPage.dart';
import 'package:app1/subMenuTabBar/ImportPage.dart';
import 'package:app1/subMenuTabBar/MenuManagePage.dart';
import 'package:app1/subMenuTabBar/MenuOrderPage.dart';
import 'package:app1/subMenuTabBar/ReportPage.dart';
import 'package:app1/subMenuTabBar/SalePage.dart';
import 'package:app1/subMenuTabBar/SearchMenuPage.dart';
import 'package:flutter/material.dart';

class Drawer_Menu extends StatefulWidget {
  const Drawer_Menu({super.key});

  @override
  State<Drawer_Menu> createState() => _Drawer_MenuState();
}

class _Drawer_MenuState extends State<Drawer_Menu> {
  Widget poupMenuButton() {
    return PopupMenuButton<String>(
      itemBuilder:
          (c) => [
            PopupMenuItem(
              child: ListTile(
                leading: Icon(Icons.settings, color: Colors.grey, size: 35),
                title: Text(
                  'Setting',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingPage()),
                  );
                },
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem(
              child: ListTile(
                leading: Icon(
                  Icons.wifi_outlined,
                  color: const Color.fromARGB(255, 31, 164, 49),
                  size: 35,
                ),
                title: Text(
                  'Wifi',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            PopupMenuDivider(),
            PopupMenuItem(
              child: ListTile(
                leading: Icon(
                  Icons.folder_open_outlined,
                  color: const Color.fromARGB(255, 249, 202, 84),
                  size: 35,
                ),
                title: Text(
                  'Database System',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Flutter App Development Lesson"),
          actions: [
            poupMenuButton(),
            IconButton(onPressed: () {}, icon: Icon(Icons.add)),
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.folder_open,
                  color: const Color.fromARGB(255, 237, 204, 255),
                  size: 25,
                ),
                text: "Basic Info Management",
              ),
              Tab(
                icon: Icon(
                  Icons.shopping_basket,
                  color: const Color.fromARGB(255, 237, 204, 255),
                  size: 25,
                ),
                text: "On Sale",
              ),
              Tab(
                icon: Icon(
                  Icons.arrow_back,
                  color: const Color.fromARGB(255, 237, 204, 255),
                  size: 25,
                ),
                text: "Order Product",
              ),
              Tab(
                icon: Icon(
                  Icons.arrow_forward,
                  color: const Color.fromARGB(255, 237, 204, 255),
                  size: 25,
                ),
                text: "Import Product",
              ),
              Tab(
                icon: Icon(
                  Icons.search,
                  color: const Color.fromARGB(255, 237, 204, 255),
                  size: 25,
                ),
                text: "Search",
              ),
              Tab(
                icon: Icon(
                  Icons.bar_chart,
                  color: const Color.fromARGB(255, 237, 204, 255),
                  size: 25,
                ),
                text: "Report",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MenuManagePage(),
            SalePage(),
            MenuOrderPage(),
            ImportPage(),
            SearchMenuPage(),
            ReportPage(),
          ],
        ),

        drawer: MenuDrawer(),
        bottomNavigationBar: BottomBar(),
      ),
    );
  }
}
