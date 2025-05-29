import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final String baseUrl = "http://localhost:5000"; // Use localhost or your IP
  List data = [];
  List categories = [];
  List units = [];
  bool isLoading = true;
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchAllData();
    fetchCategories();
    fetchUnits();
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
      final response = await http.get(Uri.parse("$baseUrl/book"));
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

  Future<void> fetchCategories() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/category"));
      if (response.statusCode == 200) {
        setState(() {
          categories = json.decode(response.body);
        });
      } else {
        print("Error fetching categories: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception fetching categories: $e");
    }
  }

  Future<void> fetchUnits() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/unit"));
      if (response.statusCode == 200) {
        setState(() {
          units = json.decode(response.body);
        });
      } else {
        print("Error fetching units: ${response.statusCode}");
      }
    } catch (e) {
      print("Exception fetching units: $e");
    }
  }

  Future<void> searchBooks(String query) async {
    if (query.isEmpty) {
      fetchAllData();
      return;
    }

    setState(() {
      isLoading = true;
      isSearching = true;
    });

    try {
      final response = await http.get(Uri.parse("$baseUrl/book/$query"));
      if (response.statusCode == 200) {
        setState(() {
          data = json.decode(response.body);
          isLoading = false;
        });
      } else {
        print("Search error: ${response.statusCode} - ${response.body}");
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Search exception: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      final response = await http.delete(Uri.parse("$baseUrl/book/$bookId"));
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book deleted successfully')),
        );

        if (isSearching && searchController.text.isNotEmpty) {
          searchBooks(searchController.text);
        } else {
          fetchAllData();
        }
      } else {
        print("Delete failed: ${response.statusCode} - ${response.body}");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to delete book')));
      }
    } catch (e) {
      print("Delete error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while deleting')),
      );
    }
  }

  Future<void> createBook(Map<String, dynamic> bookData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/book"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(bookData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book created successfully')),
        );
        fetchAllData();
      } else {
        print("Create failed: ${response.statusCode} - ${response.body}");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to create book')));
      }
    } catch (e) {
      print("Create error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while creating book')),
      );
    }
  }

  Future<void> updateBook(
    String bookId,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/book/$bookId"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(updatedData),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Book updated successfully')),
        );

        if (isSearching && searchController.text.isNotEmpty) {
          searchBooks(searchController.text);
        } else {
          fetchAllData();
        }
      } else {
        print("Update failed: ${response.statusCode} - ${response.body}");
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Failed to update book')));
      }
    } catch (e) {
      print("Update error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while updating')),
      );
    }
  }

  Widget TextBookID(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        filled: true,
        prefixIcon: Icon(Icons.book, color: Colors.red.shade800, size: 25),
        labelText: "ລະຫັດປຶ້ມ",
      ),
    );
  }

  Widget TextBookName(TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        filled: true,
        prefixIcon: Icon(Icons.title, color: Colors.red.shade800, size: 25),
        labelText: "ຊື່ປຶ້ມ",
      ),
    );
  }

  Widget TextPrice(TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        filled: true,
        prefixIcon: Icon(
          Icons.attach_money,
          color: Colors.red.shade800,
          size: 25,
        ),
        labelText: "ລາຄາ",
      ),
    );
  }

  Widget TextPage(TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        filled: true,
        prefixIcon: Icon(Icons.pages, color: Colors.red.shade800, size: 25),
        labelText: "ຈໍານວນໜ້າ",
      ),
    );
  }

  Widget CategoryDropdown(int? selectedCategoryId, Function(int?) onChanged) {
    return DropdownButtonFormField<int>(
      value: selectedCategoryId,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        filled: true,
        prefixIcon: Icon(Icons.category, color: Colors.red.shade800, size: 25),
        labelText: "ປະເພດ",
      ),
      items: [
        const DropdownMenuItem<int>(value: null, child: Text("ເລືອກປະເພດ")),
        ...categories.map<DropdownMenuItem<int>>((category) {
          return DropdownMenuItem<int>(
            value: category['cid'],
            child: Text(category['cname']),
          );
        }).toList(),
      ],
      onChanged: onChanged,
    );
  }

  Widget UnitDropdown(int? selectedUnitId, Function(int?) onChanged) {
    return DropdownButtonFormField<int>(
      value: selectedUnitId,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
        filled: true,
        prefixIcon: Icon(
          Icons.straighten,
          color: Colors.red.shade800,
          size: 25,
        ),
        labelText: "ຫົວໜ່ວຍ",
      ),
      items: [
        const DropdownMenuItem<int>(value: null, child: Text("ເລືອກຫົວໜ່ວຍ")),
        ...units.map<DropdownMenuItem<int>>((unit) {
          return DropdownMenuItem<int>(
            value: unit['uid'],
            child: Text(unit['uname']),
          );
        }).toList(),
      ],
      onChanged: onChanged,
    );
  }

  Widget TextDataInfo(
    TextEditingController bookIdController,
    TextEditingController bookNameController,
    TextEditingController priceController,
    TextEditingController pageController,
    int? selectedCategoryId,
    int? selectedUnitId,
    Function(int?) onCategoryChanged,
    Function(int?) onUnitChanged,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(color: Colors.red, thickness: 2),
        TextBookID(bookIdController),
        SizedBox(height: 10),
        TextBookName(bookNameController),
        SizedBox(height: 10),
        TextPrice(priceController),
        SizedBox(height: 10),
        TextPage(pageController),
        SizedBox(height: 10),
        CategoryDropdown(selectedCategoryId, onCategoryChanged),
        SizedBox(height: 10),
        UnitDropdown(selectedUnitId, onUnitChanged),
      ],
    );
  }

  void showCreateDialog() {
    final bookIdController = TextEditingController();
    final bookNameController = TextEditingController();
    final priceController = TextEditingController();
    final pageController = TextEditingController();
    int? selectedCategoryId;
    int? selectedUnitId;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("ຈັດການຂໍ້ມູນ"),
              content: SingleChildScrollView(
                child: TextDataInfo(
                  bookIdController,
                  bookNameController,
                  priceController,
                  pageController,
                  selectedCategoryId,
                  selectedUnitId,
                  (value) {
                    setDialogState(() {
                      selectedCategoryId = value;
                    });
                  },
                  (value) {
                    setDialogState(() {
                      selectedUnitId = value;
                    });
                  },
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                  ),
                  onPressed: () {
                    // Validate inputs
                    if (bookIdController.text.isEmpty ||
                        bookNameController.text.isEmpty ||
                        priceController.text.isEmpty ||
                        pageController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Book ID, name, price and page are required',
                          ),
                        ),
                      );
                      return;
                    }

                    final newBook = <String, dynamic>{
                      "bookid": bookIdController.text,
                      "bookname": bookNameController.text,
                      "price": int.tryParse(priceController.text) ?? 0,
                      "page": int.tryParse(pageController.text) ?? 0,
                    };

                    // Add category and unit if selected
                    if (selectedCategoryId != null) {
                      newBook["categoryId"] = selectedCategoryId;
                    }
                    if (selectedUnitId != null) {
                      newBook["unitId"] = selectedUnitId;
                    }

                    createBook(newBook);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "ບັນທຶກຂໍ້ມູນ",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "ຍົກເລີກ",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void showEditDialog(Map<String, dynamic> book) {
    final bookIdController = TextEditingController(
      text: book['bookid'].toString(),
    );
    final bookNameController = TextEditingController(text: book['bookname']);
    final priceController = TextEditingController(
      text: book['price'].toString(),
    );
    final pageController = TextEditingController(text: book['page'].toString());

    // FIX: Safely cast the values from JSON to int?
    int? selectedCategoryId =
        book['categoryId'] != null ? book['categoryId'] as int : null;
    int? selectedUnitId = book['unitId'] != null ? book['unitId'] as int : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("ແກ້ໄຂຂໍ້ມູນ"),
              content: SingleChildScrollView(
                child: TextDataInfo(
                  bookIdController,
                  bookNameController,
                  priceController,
                  pageController,
                  selectedCategoryId,
                  selectedUnitId,
                  (value) {
                    setDialogState(() {
                      selectedCategoryId = value;
                    });
                  },
                  (value) {
                    setDialogState(() {
                      selectedUnitId = value;
                    });
                  },
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                  ),
                  onPressed: () {
                    // Validate inputs
                    if (bookNameController.text.isEmpty ||
                        priceController.text.isEmpty ||
                        pageController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('All fields are required'),
                        ),
                      );
                      return;
                    }

                    final updatedData = <String, dynamic>{
                      "bookname": bookNameController.text,
                      "price": int.tryParse(priceController.text) ?? 0,
                      "page": int.tryParse(pageController.text) ?? 0,
                    };

                    // Add category and unit (null values are handled by the API)
                    updatedData["categoryId"] = selectedCategoryId;
                    updatedData["unitId"] = selectedUnitId;

                    updateBook(book['bookid'].toString(), updatedData);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "ອັບເດດ",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    padding: EdgeInsets.symmetric(vertical: 18, horizontal: 15),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "ຍົກເລີກ",
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
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
                  searchBooks(value.trim());
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(
                  Icons.input,
                  size: 30,
                  color: Colors.red,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 30,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        searchController.clear();
                        fetchAllData();
                      },
                    ),
                    const SizedBox(width: 15),
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        size: 30,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        searchBooks(searchController.text.trim());
                      },
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
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
        title: const Text("ຈັດການຂໍ້ມູນປຶ້ມ"),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : data.isEmpty
              ? Center(
                child: Text(
                  isSearching
                      ? "No search results found"
                      : "No books available",
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
                          leading: Text(
                            '${getdata["bookid"]}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          title: Text(
                            '${getdata["bookname"]}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Price: ${getdata["price"]}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 20),
                                    Text(
                                      'Pages: ${getdata["page"]}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      'Category: ${getdata["categoryName"] ?? "N/A"}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Text(
                                      'Unit: ${getdata["unitName"] ?? "N/A"}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
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
                                            "ທ່ານຕ້ອງການລືບເເທ້ບໍ",
                                          ),
                                          content: Text(
                                            "ລືບ '${getdata['bookname']}'?",
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed:
                                                  () => Navigator.pop(context),
                                              child: const Text("ຍົກເລີກ"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                deleteBook(
                                                  getdata['bookid'].toString(),
                                                );
                                              },
                                              child: const Text(
                                                "ລືບ",
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
        backgroundColor: Colors.red,
        onPressed: () {
          showCreateDialog();
        },
        child: Icon(Icons.add, color: Colors.white, size: 45),
      ),
    );
  }
}
