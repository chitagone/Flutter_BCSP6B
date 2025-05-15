import 'package:flutter/material.dart';

List itm = [
  "App Develop By Flutter 1",
  "App Develop By React Native",
  "Program Develop By C#",
];

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String? selectItm;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Management"),
        backgroundColor: const Color.fromARGB(255, 134, 54, 154),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.symmetric(vertical: 5.0),
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: DropdownButton(
              isExpanded: true,
              value: selectItm,
              hint: Text('Select option'),
              items:
                  itm.map((c) {
                    return DropdownMenuItem(
                      value: c,
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.book,
                            color: const Color.fromARGB(255, 114, 38, 202),
                            size: 25,
                          ),
                        ),
                        title: Text(
                          '${c}',
                          style: TextStyle(
                            fontSize: 18,
                            color: const Color.fromARGB(255, 134, 54, 154),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
              onChanged: (newval) {
                setState(() {
                  selectItm = newval.toString();
                });
              },
            ),
          ),
        ),
      ),
      body: Center(
        child:
            selectItm == null
                ? Text("Product Info")
                : Text(
                  '${selectItm}',
                  style: TextStyle(
                    fontSize: 18,
                    color: const Color.fromARGB(255, 134, 54, 154),
                    fontWeight: FontWeight.bold,
                  ),
                ),
      ),
    );
  }
}
