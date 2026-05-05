import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'add_place_screen.dart';
import 'place_details_screen.dart';

class PlacesScreen extends StatelessWidget {
  final String areaId;
  final String areaName;

  PlacesScreen({required this.areaId, required this.areaName});

  final fs = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(areaName)),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddPlaceScreen(areaId: areaId),
          ),
        ),
        child: Icon(Icons.add),
      ),

      body: StreamBuilder(
        stream: fs.getPlaces(areaId),
        builder: (context, snapshot) {

          // ✅ Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // ❌ Error
          if (snapshot.hasError) {
            return Center(
              child: Text("Error: ${snapshot.error}"),
            );
          }

          // 📭 Empty
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No places yet 😢"),
            );
          }

          final places = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: places.length,
            itemBuilder: (context, index) {
              final p = places[index];
              final images = p['images'] ?? [];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlaceDetailsScreen(
                        data: p,
                      ),
                    ),
                  );
                },

                child: Container(
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 5,
                        color: Colors.black12,
                      )
                    ],
                  ),

                  child: ListTile(
                    leading: images.isNotEmpty
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        images[0],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.image_not_supported),
                      ),
                    )
                        : Icon(Icons.place),

                    title: Text(p['name'] ?? "No Name"),

                    subtitle: Text(
                      p['notes'] ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    trailing: Icon(Icons.arrow_forward_ios, size: 14),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}