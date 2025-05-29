import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
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
      final response = await http.get(Uri.parse("$baseUrl/category"));
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

  Future<void> searchCategories(String query) async {
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
            data.where((category) {
              return category['cname'].toString().toLowerCase().contains(
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

  Future<void> deleteCategory(String categoryId) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/category/$categoryId"),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category deleted successfully')),
        );

        if (isSearching && searchController.text.isNotEmpty) {
          searchCategories(searchController.text);
        } else {
          fetchAllData();
        }
      } else {
        print("Delete failed: ${response.statusCode} - ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete category')),
        );
      }
    } catch (e) {
      print("Delete error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while deleting')),
      );
    }
  }

  Future<void> createCategory(Map<String, dynamic> categoryData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/category"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(categoryData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category created successfully')),
        );
        fetchAllData();
      } else {
        print("Create failed: ${response.statusCode} - ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create category')),
        );
      }
    } catch (e) {
      print("Create error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while creating category')),
      );
    }
  }

  Future<void> updateCategory(
    String categoryId,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/category/$categoryId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Category updated successfully')),
        );

        if (isSearching && searchController.text.isNotEmpty) {
          searchCategories(searchController.text);
        } else {
          fetchAllData();
        }
      } else {
        print("Update failed: ${response.statusCode} - ${response.body}");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update category')),
        );
      }
    } catch (e) {
      print("Update error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while updating')),
      );
    }
  }

  Widget buildCategoryNameField(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        filled: true,
        prefixIcon: Icon(
          Icons.category,
          color: Colors.deepPurple.shade800,
          size: 25,
        ),
        labelText: "ຊື່ປະເພດ", // Category Name in Lao
      ),
    );
  }

  Widget buildCategoryForm(TextEditingController categoryNameController) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(color: Colors.deepPurple, thickness: 2),
        buildCategoryNameField(categoryNameController),
      ],
    );
  }

  void showCreateDialog() {
    final categoryNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("ສ້າງປະເພດໃໝ່"), // Create New Category in Lao
          content: SingleChildScrollView(
            child: buildCategoryForm(categoryNameController),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade700,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 15,
                ),
              ),
              onPressed: () {
                // Validate inputs
                if (categoryNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Category name is required')),
                  );
                  return;
                }

                final newCategory = {"cname": categoryNameController.text};
                createCategory(newCategory);
                Navigator.pop(context);
              },
              child: const Text(
                "ບັນທຶກຂໍ້ມູນ", // Save Data in Lao
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade700,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 15,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "ຍົກເລີກ", // Cancel in Lao
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(Map<String, dynamic> category) {
    final categoryNameController = TextEditingController(
      text: category['cname'],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("ແກ້ໄຂຂໍ້ມູນປະເພດ"), // Edit Category Data in Lao
          content: SingleChildScrollView(
            child: buildCategoryForm(categoryNameController),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade700,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 15,
                ),
              ),
              onPressed: () {
                // Validate inputs
                if (categoryNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Category name is required')),
                  );
                  return;
                }

                final updatedData = {"cname": categoryNameController.text};
                updateCategory(category['cid'].toString(), updatedData);
                Navigator.pop(context);
              },
              child: const Text(
                "ອັບເດດ", // Update in Lao
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple.shade700,
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 15,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
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
        backgroundColor: Colors.deepPurple,
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
                  searchCategories(value.trim());
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
                  color: Colors.deepPurple,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.deepPurple,
                      ),
                      onPressed: () {
                        searchController.clear();
                        fetchAllData();
                      },
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                hintText: "ຄົ້ນຫາປະເພດ...", // Search categories in Lao
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: fetchAllData,
            icon: const Icon(Icons.refresh, size: 35, color: Colors.white),
          ),
        ],
        title: const Text(
          "ຈັດການປະເພດສິນຄ້າ", // Product Category Management in Lao
          style: TextStyle(color: Colors.white),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : data.isEmpty
              ? Center(
                child: Text(
                  isSearching
                      ? "ບໍ່ພົບຜົນການຄົ້ນຫາ" // No search results in Lao
                      : "ບໍ່ມີຂໍ້ມູນປະເພດ", // No categories available in Lao
                  style: const TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final category = data[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple.shade100,
                          child: Text(
                            '${category["cid"]}',
                            style: const TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          '${category["cname"]}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          'Category ID: ${category["cid"]}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => showEditDialog(category),
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
                                          "ທ່ານຕ້ອງການລືບປະເພດນີ້ບໍ", // Do you want to delete this category in Lao
                                        ),
                                        content: Text(
                                          "ລືບ '${category['cname']}'?", // Delete category name in Lao
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: const Text(
                                              "ຍົກເລີກ", // Cancel in Lao
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              deleteCategory(
                                                category['cid'].toString(),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          showCreateDialog();
        },
        child: const Icon(Icons.add, color: Colors.white, size: 45),
      ),
    );
  }
}
