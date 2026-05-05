import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'add_area_screen.dart';
import 'places_screen.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  final fs = FirestoreService();
  final auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Date Guide 💕"),
        actions: [
          IconButton(
            onPressed: () => auth.logout(),
            icon: Icon(Icons.logout),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => AddAreaScreen())),
      ),
      body: StreamBuilder(
        stream: fs.getAreas(),
        builder: (context, snapshot) {

          // ✅ 1. Handle loading correctly
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // ✅ 2. Handle errors
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // ✅ 3. Handle empty data
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No areas yet 😢"));
          }

          final areas = snapshot.data!.docs;

          return ListView.builder(
            itemCount: areas.length,
            itemBuilder: (context, i) {
              final area = areas[i];

              return Card(
                child: ListTile(
                  title: Text(area['name'] ?? "No Name"),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PlacesScreen(
                          areaId: area.id,
                          areaName: area['name'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}