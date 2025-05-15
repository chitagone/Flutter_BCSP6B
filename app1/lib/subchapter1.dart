import 'package:app1/subLesson1/ButtonPage.dart';
import 'package:app1/subLesson1/ListViewPage.dart';
import 'package:app1/subLesson1/TextFieldPage.dart';
import 'package:app1/subLesson1/TextPage.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> itm = [
  {"page": TextPage(), "icon": Icons.book},
  {"page": TextFieldPage(), "icon": Icons.edit},
  {"page": ButtonPage(), "icon": Icons.smart_button},
  {"page": ListViewPage(), "icon": Icons.list},
];

class subchapter1 extends StatefulWidget {
  const subchapter1({super.key});

  @override
  State<subchapter1> createState() => _subchapter1State();
}

class _subchapter1State extends State<subchapter1> {
  void selectPage(int idx) {
    setState(() {
      if (idx < itm.length) {
        MaterialPageRoute route = MaterialPageRoute(
          builder: (c) => itm[idx]["page"],
        );
        Navigator.of(context).push(route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lesson 1")),
      body: Container(
        margin: EdgeInsets.all(5),
        child: GridView.builder(
          itemCount:
              itm.length, // Update itemCount to match the number of items
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
          ),
          itemBuilder: (c, idx) {
            return InkWell(
              onTap: () {
                selectPage(idx);
              },
              child: Card(
                elevation: 10,
                child: Container(
                  width: 100,
                  height: 180,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 246, 237, 255),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color.fromARGB(255, 82, 66, 99),
                      width: 2,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        itm[idx]["icon"], // Uses unique icon per page
                        color: const Color.fromARGB(255, 69, 51, 85),
                        size: 80,
                      ),
                      SizedBox(height: 30),
                      Text(
                        "How to split sapphic 1.${idx + 1}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
