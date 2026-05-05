import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class AddAreaScreen extends StatelessWidget {
  final controller = TextEditingController();
  final fs = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Area")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: controller),
            ElevatedButton(
              onPressed: () async {
                await fs.addArea(controller.text);
                Navigator.pop(context);
              },
              child: Text("Save"),
            )
          ],
        ),
      ),
    );
  }
}