import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final db = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get areas =>
      db.collection('users').doc(userId).collection('areas');

  Future addArea(String name) async {
    await areas.add({
      'name': name,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getAreas() => areas.snapshots();

  CollectionReference places(String areaId) =>
      areas.doc(areaId).collection('places');

  Future addPlace(
      String areaId,
      String name,
      String notes,
      List<String> images,
      String instagram,
      String menu,
      ) async {
    await places(areaId).add({
      'name': name,
      'notes': notes,
      'images': images,
      'instagram': instagram,
      'menu': menu,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getPlaces(String areaId) =>
      places(areaId).snapshots();
}