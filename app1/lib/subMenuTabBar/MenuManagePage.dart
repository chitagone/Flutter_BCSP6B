import 'package:app1/subMenuManage/BookPage.dart';
import 'package:app1/subMenuManage/CategoryPage.dart';
import 'package:app1/subMenuManage/ProductPage.dart';
import 'package:app1/subMenuManage/UnitPage.dart';
import 'package:flutter/material.dart';

class MenuManagePage extends StatefulWidget {
  const MenuManagePage({super.key});

  @override
  State<MenuManagePage> createState() => _MenuManagePageState();
}

class _MenuManagePageState extends State<MenuManagePage> {
  final List<Map<String, dynamic>> menuItems = [
    {'icon': Icons.straighten, 'label': 'Unit'},
    {'icon': Icons.category, 'label': 'Product Type'},
    {'icon': Icons.info_outline, 'label': 'Product Info'},
    {'icon': Icons.people_outline, 'label': 'Respondent'},
    {'icon': Icons.badge_outlined, 'label': 'Employees'},
    {'icon': Icons.monetization_on, 'label': 'Rate'},
    {'icon': Icons.person, 'label': 'Customer'},
    {'icon': Icons.book, 'label': 'Books'},
  ];

  // Only first 3 have pages for now
  final List<Widget> itmpage = [
    UnitPage(),
    CategoryPage(),
    ProductPage(),
    UnitPage(),
    CategoryPage(),
    ProductPage(),
    ProductPage(),
    BookPage(),
  ];

  void selectMenagePage(int idx) {
    if (idx < itmpage.length) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (context) => itmpage[idx]));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Page not available yet.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EBFE),
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 0.9,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: List.generate(menuItems.length, (idx) {
            final item = menuItems[idx];
            return GestureDetector(
              onTap: () => selectMenagePage(idx),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.deepPurple.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item['icon'], size: 40, color: Colors.deepPurple),
                    const SizedBox(height: 10),
                    Text(
                      item['label'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.deepPurple.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
