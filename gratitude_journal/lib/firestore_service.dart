import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GratitudeEntry {
  final String? id;
  final DateTime date;
  final String entry;
  final int moodRating;

  GratitudeEntry({this.id, required this.date, required this.entry, required this.moodRating});

  Map<String, dynamic> toMap() => {
    'date': date.toIso8601String(),
    'entry': entry,
    'moodRating': moodRating,
  };

  factory GratitudeEntry.fromMap(Map<String, dynamic> map, String id) {
    return GratitudeEntry(
      id: id,
      date: DateTime.parse(map['date']),
      entry: map['entry'],
      moodRating: map['moodRating'],
    );
  }
}

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  CollectionReference get _journalRef =>
      _db.collection('users').doc(uid).collection('journal');

  Future<void> addEntry(GratitudeEntry entry) => _journalRef.add(entry.toMap());

  Future<void> updateEntry(GratitudeEntry entry) =>
      _journalRef.doc(entry.id).update(entry.toMap());

  Future<void> deleteEntry(String id) => _journalRef.doc(id).delete();

  Stream<List<GratitudeEntry>> getEntries() {
    return _journalRef.orderBy('date', descending: true).snapshots().map((snap) =>
        snap.docs.map((doc) => GratitudeEntry.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }
}