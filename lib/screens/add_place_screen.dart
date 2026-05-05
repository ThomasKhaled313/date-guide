import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/firestore_service.dart';
import '../services/storage_service.dart';

class AddPlaceScreen extends StatefulWidget {
  final String areaId;

  AddPlaceScreen({required this.areaId});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final name = TextEditingController();
  final notes = TextEditingController();
  final instagram = TextEditingController();
  final menuLink = TextEditingController();

  final picker = ImagePicker();
  List<File> images = [];

  bool isLoading = false;

  @override
  void dispose() {
    name.dispose();
    notes.dispose();
    instagram.dispose();
    menuLink.dispose();
    super.dispose();
  }

  Future pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => images.add(File(picked.path)));
    }
  }

  Future save() async {
    // ✅ Validation
    if (name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter place name")),
      );
      return;
    }

    if (images.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Add at least one image")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      List<String> urls = [];

      for (var img in images) {
        final url = await StorageService().upload(img);
        urls.add(url);
      }

      await FirestoreService().addPlace(
        widget.areaId,
        name.text,
        notes.text,
        urls,
        instagram.text.trim(),
        menuLink.text.trim(),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Place")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            // 📍 Name
            TextField(
              controller: name,
              decoration: InputDecoration(labelText: "Place Name"),
            ),

            // 📝 Notes
            TextField(
              controller: notes,
              decoration: InputDecoration(labelText: "Notes"),
            ),

            // 📷 Instagram
            TextField(
              controller: instagram,
              decoration: InputDecoration(labelText: "Instagram Link"),
            ),

            // 📖 Menu link
            TextField(
              controller: menuLink,
              decoration: InputDecoration(labelText: "Menu Link"),
            ),

            SizedBox(height: 15),

            // 🖼 Images preview
            Wrap(
              spacing: 8,
              children: images
                  .map(
                    (e) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    e,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              )
                  .toList(),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: pickImage,
              child: Text("Add Image"),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: isLoading ? null : save,
              child: isLoading
                  ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
                  : Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}