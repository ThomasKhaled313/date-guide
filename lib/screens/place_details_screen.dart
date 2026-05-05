import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final dynamic data;

  PlaceDetailsScreen({required this.data});

  Future<void> openLink(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      throw "Could not launch $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    final images = data['images'] ?? [];

    return Scaffold(
      appBar: AppBar(title: Text(data['name'] ?? "")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🖼 Main image gallery
            SizedBox(
              height: 250,
              child: PageView(
                children: images.map<Widget>((img) {
                  return Image.network(
                    img,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                }).toList(),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                data['notes'] ?? "",
                style: TextStyle(fontSize: 16),
              ),
            ),

            // 🔗 Links section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  if (data['instagram'] != null &&
                      data['instagram'].toString().isNotEmpty)
                    ElevatedButton.icon(
                      icon: Icon(Icons.camera_alt),
                      label: Text("Open Instagram"),
                      onPressed: () => openLink(data['instagram']),
                    ),

                  if (data['menu'] != null &&
                      data['menu'].toString().isNotEmpty)
                    ElevatedButton.icon(
                      icon: Icon(Icons.menu_book),
                      label: Text("View Menu"),
                      onPressed: () => openLink(data['menu']),
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