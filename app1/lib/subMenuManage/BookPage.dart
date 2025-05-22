import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  final String baseUrl = "http://localhost:3000"; // Use localhost or your IP
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
      final response = await http.get(
        Uri.parse("$baseUrl/search?query=$query"),
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          data = responseData['results'] ?? [];
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

  void showCreateDialog() {
    final bookIdController = TextEditingController();
    final bookNameController = TextEditingController();
    final priceController = TextEditingController();
    final pageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add New Book"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: bookIdController,
                  decoration: const InputDecoration(
                    labelText: 'Book ID (optional)',
                    hintText: 'Leave empty for auto-generation',
                  ),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: bookNameController,
                  decoration: const InputDecoration(labelText: 'Book Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: pageController,
                  decoration: const InputDecoration(labelText: 'Page'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Validate inputs
                if (bookNameController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    pageController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Book name, price and page are required'),
                    ),
                  );
                  return;
                }

                final newBook = {
                  "bookname": bookNameController.text,
                  "price": int.tryParse(priceController.text) ?? 0,
                  "page": int.tryParse(pageController.text) ?? 0,
                };

                // Add bookId if provided
                if (bookIdController.text.isNotEmpty) {
                  newBook["bookid"] = bookIdController.text;
                }

                createBook(newBook);
                Navigator.pop(context);
              },
              child: const Text("Create"),
            ),
          ],
        );
      },
    );
  }

  void showEditDialog(Map<String, dynamic> book) {
    final bookNameController = TextEditingController(text: book['bookname']);
    final priceController = TextEditingController(
      text: book['price'].toString(),
    );
    final pageController = TextEditingController(text: book['page'].toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Edit Book"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: bookNameController,
                  decoration: const InputDecoration(labelText: 'Book Name'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: pageController,
                  decoration: const InputDecoration(labelText: 'Page'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                // Validate inputs
                if (bookNameController.text.isEmpty ||
                    priceController.text.isEmpty ||
                    pageController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All fields are required')),
                  );
                  return;
                }

                final updatedData = {
                  "bookname": bookNameController.text,
                  "price": int.tryParse(priceController.text) ?? 0,
                  "page": int.tryParse(pageController.text) ?? 0,
                };
                updateBook(book['bookid'].toString(), updatedData);
                Navigator.pop(context);
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void showDetailDialog(Map<String, dynamic> book) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(book['bookname'] ?? 'Book Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Book ID: ${book['bookid']}"),
                const SizedBox(height: 8),
                Text("Book Name: ${book['bookname']}"),
                const SizedBox(height: 8),
                Text("Price: ${book['price']}"),
                const SizedBox(height: 8),
                Text("Pages: ${book['page']}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
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
        title:
            !isSearching
                ? const Text("ປຶ້ມ")
                : TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    hintText: "Search books...",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white),
                  onSubmitted: (value) => searchBooks(value),
                ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  isSearching = false;
                  searchController.clear();
                  fetchAllData();
                } else {
                  isSearching = true;
                }
              });
            },
          ),
          IconButton(onPressed: fetchAllData, icon: const Icon(Icons.refresh)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showCreateDialog,
        child: const Icon(Icons.add),
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
              : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(6),
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("Book ID")),
                    DataColumn(label: Text("Book Name")),

                    DataColumn(label: Text("Actions")),
                  ],
                  rows:
                      data.map<DataRow>((book) {
                        return DataRow(
                          cells: [
                            DataCell(
                              Text(book['bookid']?.toString() ?? ''),
                              onTap: () => showDetailDialog(book),
                            ),
                            DataCell(
                              Text(book['bookname']?.toString() ?? ''),
                              onTap: () => showDetailDialog(book),
                            ),

                            DataCell(
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () => showEditDialog(book),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              title: const Text(
                                                "Delete Confirmation",
                                              ),
                                              content: Text(
                                                "Delete '${book['bookname']}'?",
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                  child: const Text("Cancel"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                    deleteBook(
                                                      book['bookid'].toString(),
                                                    );
                                                  },
                                                  child: const Text(
                                                    "Delete",
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
    );
  }
}
