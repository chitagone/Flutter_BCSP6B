import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  PickedFile? imgFile;
  final ImagePicker impicker = ImagePicker();

  void takePhoto(ImageSource source) async {
    final FileImage = await impicker.pickImage(source: source);
    setState(() {
      imgFile = PickedFile(FileImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Product Type Management")),
      body: Center(
        child: Stack(
          children: [
            CircleAvatar(
              radius: 80.0,
              backgroundImage:
                  imgFile == null
                      ? const AssetImage("images/loco.png") as ImageProvider
                      : FileImage(File(imgFile!.path)),
            ),
            Positioned(
              bottom: 18.0,
              right: 18.0,
              child: PopupMenuButton<String>(
                icon: const Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 30,
                ),
                onSelected: (value) {
                  if (value == 'camera') {
                    takePhoto(ImageSource.camera);
                  } else if (value == 'gallery') {
                    takePhoto(ImageSource.gallery);
                  }
                },
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        value: 'camera',
                        child: Row(
                          children: const [
                            Icon(Icons.camera, color: Colors.deepPurple),
                            SizedBox(width: 10),
                            Text("Camera"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'gallery',
                        child: Row(
                          children: const [
                            Icon(
                              Icons.image_outlined,
                              color: Colors.deepPurple,
                            ),
                            SizedBox(width: 10),
                            Text("Gallery"),
                          ],
                        ),
                      ),
                    ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
