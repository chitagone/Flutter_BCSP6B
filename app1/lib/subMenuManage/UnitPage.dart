import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UnitPage extends StatefulWidget {
  const UnitPage({super.key});

  @override
  State<UnitPage> createState() => _UnitPageState();
}

class _UnitPageState extends State<UnitPage> {
  final String baseUrl = "http://localhost:5000"; // Match your API base URL
  List data = [];
  bool isLoading = true;
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchAllData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse("$baseUrl/unit"));
      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body);
          isLoading = false;
          isSearching = false;
        });
      } else {
        print("Error: ${response.statusCode} - ${response.body}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e, stacktrace) {
      print("Exception occurred: $e");
      print("Stacktrace: $stacktrace");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> searchUnits(String query) async {
    if (query.isEmpty) {
      fetchAllData();
      return;
    }

    setState(() {
      isLoading = true;
      isSearching = true;
    });

    try {
      // Filter locally since your API doesn't have search endpoint
      await fetchAllData();
      setState(() {
        data =
            data.where((unit) {
              return unit['uname'].toString().toLowerCase().contains(
                query.toLowerCase(),
              );
            }).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Search exception: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteUnit(String unitId) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/unit/$unitId"));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unit deleted successfully')),
        );

        if (isSearching && searchController.text.isNotEmpty) {
          searchUnits(searchController.text);
        } else {
          fetchAllData();
        }
      } else {
        print("Delete failed: ${response.statusCode} - ${response.body}");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to delete unit')));
      }
    } catch (e) {
      print("Delete error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while deleting')),
      );
    }
  }

  Future<void> createUnit(Map<String, dynamic> unitData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/unit"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(unitData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unit created successfully')),
        );
        fetchAllData();
      } else {
        print("Create failed: ${response.statusCode} - ${response.body}");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to create unit')));
      }
    } catch (e) {
      print("Create error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while creating unit')),
      );
    }
  }

  Future<void> updateUnit(
    String unitId,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/unit/$unitId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unit updated successfully')),
        );

        if (isSearching && searchController.text.isNotEmpty) {
          searchUnits(searchController.text);
        } else {
          fetchAllData();
        }
      } else {
        print("Update failed: ${response.statusCode} - ${response.body}");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to update unit')));
      }
    } catch (e) {
      print("Update error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while updating')),
      );
    }
  }

  Widget TextUnitName(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        filled: true,
        prefixIcon: Icon(Icons.category, color: Colors.blue.shade800, size: 25),
        labelText: "ຊື່ຫົວໜ່ວຍ", // Unit Name in Lao
      ),
    );
  }

  Widget TextDataInfo(TextEditingController unitNameController) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(color: Colors.blue, thickness: 2),
        TextUnitName(unitNameController),
      ],
    );
  }

  /*************  ✨ Windsurf Command ⭐  *************/
  /// Displays a dialog for creating a new unit.
  ///
  /// The dialog contains a text field for entering the unit name.
  /// It validates the input to ensure the unit name is not empty before
  /// calling `createUnit` to add the new unit. The dialog provides
  /// options to save the data or cancel the operation.

  /*******  d277e031-faf9-42b7-8301-50ad0fc106d0  *******/
  void showCreateDialog() {
    final unitNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("ສ້າງຫົວໜ່ວຍໃໝ່"), // Create New Unit in Lao
          content: SingleChildScrollView(
            child: TextDataInfo(unitNameController),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              ),
              onPressed: () {
                // Validate inputs
                if (unitNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Unit name is required')),
                  );
                  return;
                }

                final newUnit = {"uname": unitNameController.text};

                createUnit(newUnit);
                Navigator.pop(context);
              },
              child: Text(
                "ບັນທຶກຂໍ້ມູນ", // Save Data in Lao
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "ຍົກເລີກ", // Cancel in Lao
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(Map<String, dynamic> unit) {
    final unitNameController = TextEditingController(text: unit['uname']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("ແກ້ໄຂຂໍ້ມູນຫົວໜ່ວຍ"), // Edit Unit Data in Lao
          content: SingleChildScrollView(
            child: TextDataInfo(unitNameController),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              ),
              onPressed: () {
                // Validate inputs
                if (unitNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Unit name is required')),
                  );
                  return;
                }

                final updatedData = {"uname": unitNameController.text};
                updateUnit(unit['uid'].toString(), updatedData);
                Navigator.pop(context);
              },
              child: Text(
                "ອັບເດດ", // Update in Lao
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "ຍົກເລີກ", // Cancel in Lao
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.fromLTRB(25, 0, 25, 5),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                if (value.trim().isEmpty) {
                  fetchAllData();
                } else {
                  searchUnits(value.trim());
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(
                  Icons.search,
                  size: 30,
                  color: Colors.blue,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        searchController.clear();
                        fetchAllData();
                      },
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                hintText: "ຄົ້ນຫາຫົວໜ່ວຍ...", // Search units in Lao
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: fetchAllData,
            icon: const Icon(Icons.refresh, size: 35, color: Colors.black),
          ),
        ],
        title: const Text("ຈັດການຫົວໜ່ວຍ"), // Unit Management in Lao
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : data.isEmpty
              ? Center(
                child: Text(
                  isSearching
                      ? "ບໍ່ພົບຜົນການຄົ້ນຫາ" // No search results in Lao
                      : "ບໍ່ມີຂໍ້ມູນຫົວໜ່ວຍ", // No units available in Lao
                  style: const TextStyle(fontSize: 18),
                ),
              )
              : Center(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final getdata = data[index];
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            child: Text(
                              '${getdata["uid"]}',
                              style: const TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            '${getdata["uname"]}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Unit ID: ${getdata["uid"]}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => showEditDialog(getdata),
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                  size: 25,
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => AlertDialog(
                                          title: const Text(
                                            "ທ່ານຕ້ອງການລືບຫົວໜ່ວຍນີ້ບໍ", // Do you want to delete this unit in Lao
                                          ),
                                          content: Text(
                                            "ລືບ '${getdata['uname']}'?", // Delete unit name in Lao
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              child: const Text(
                                                "ຍົກເລີກ",
                                              ), // Cancel in Lao
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                deleteUnit(
                                                  getdata['uid'].toString(),
                                                );
                                              },
                                              child: const Text(
                                                "ລືບ", // Delete in Lao
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                  );
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                  size: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(color: Colors.black, thickness: 1),
                      ],
                    );
                  },
                ),
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          showCreateDialog();
        },
        child: Icon(Icons.add, color: Colors.white, size: 45),
      ),
    );
  }
}
