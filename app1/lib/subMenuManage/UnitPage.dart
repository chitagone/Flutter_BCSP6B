import 'package:flutter/material.dart';

class UnitPage extends StatefulWidget {
  const UnitPage({super.key});

  @override
  State<UnitPage> createState() => _UnitPageState();
}

class _UnitPageState extends State<UnitPage> {
  String? selectedUnit;
  String? selectedCategory;
  Widget showButtonSheet() {
    return Container(
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey.shade900,
              child: Icon(
                Icons.share,
                color: const Color.fromARGB(255, 97, 19, 199),
                size: 30,
              ),
            ),
            title: Text(
              "Share",
              style: TextStyle(
                color: const Color.fromARGB(255, 69, 80, 160),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey.shade900,
              child: Icon(
                Icons.copy,
                color: const Color.fromARGB(255, 97, 19, 199),
                size: 30,
              ),
            ),
            title: Text(
              "Copy",
              style: TextStyle(
                color: const Color.fromARGB(255, 69, 80, 160),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.grey.shade900,
              child: Icon(
                Icons.delete,
                color: const Color.fromARGB(255, 97, 19, 199),
                size: 30,
              ),
            ),
            title: Text(
              "Delete",
              style: TextStyle(
                color: const Color.fromARGB(255, 69, 80, 160),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          Divider(),
        ],
      ),
    );
  }

  final TextEditingController codeController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final List<String> units = ['piece', 'glass', 'box', 'pack', 'bottle', 'can'];
  final List<String> categories = [
    'Milk',
    'Milk Powder',
    'Drinks',
    'Food',
    'Makeup',
  ];
  List<Map<String, String>> itemList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product List"),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (c) => showButtonSheet(),
              );
            },
            icon: Icon(Icons.add, color: Colors.white),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 97, 19, 199),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: codeController,
                decoration: InputDecoration(
                  labelText: 'Product ID',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Product Item',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: selectedUnit,
                decoration: InputDecoration(
                  labelText: 'Select Unit',
                  border: OutlineInputBorder(),
                ),
                items:
                    units
                        .map(
                          (unit) =>
                              DropdownMenuItem(value: unit, child: Text(unit)),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedUnit = value;
                  });
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                isExpanded: true,
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Select Type',
                  border: OutlineInputBorder(),
                ),
                items:
                    categories
                        .map(
                          (cat) =>
                              DropdownMenuItem(value: cat, child: Text(cat)),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      if (codeController.text.isEmpty ||
                          nameController.text.isEmpty ||
                          selectedUnit == null ||
                          selectedCategory == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter info before")),
                        );
                      } else {
                        setState(() {
                          itemList.add({
                            'code': codeController.text,
                            'name': nameController.text,
                            'unit': selectedUnit!,
                            'category': selectedCategory!,
                          });
                          codeController.clear();
                          nameController.clear();
                          selectedUnit = null;
                          selectedCategory = null;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Product already added")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 201, 244, 226),
                    ),
                    icon: Icon(Icons.add),
                    label: Text("Add"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        codeController.clear();
                        nameController.clear();
                        selectedUnit = null;
                        selectedCategory = null;
                      });
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text("Clear finish")));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 198, 239, 255),
                    ),
                    icon: Icon(Icons.cancel),
                    label: Text("Cancel"),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // 🔽 แสดงรายการสินค้าที่เพิ่ม
              if (itemList.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "List Product Add:",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...itemList.map((item) {
                      return Card(
                        child: ListTile(
                          title: Text("${item['name']} (${item['code']})"),
                          subtitle: Text(
                            "Unit: ${item['unit']}, Type: ${item['category']}",
                          ),
                        ),
                      );
                    }).toList(),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
