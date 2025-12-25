// lib/add_entry_screen.dart
import 'package:flutter/material.dart';
import 'firestore_service.dart';
import 'mood_icon_utility.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _controller = TextEditingController();
  int _rating = 5;

  // --- THE CLIENT-SERVER TASK ---
  void _saveToCloud() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write something!')),
      );
      return;
    }

    final entry = GratitudeEntry(
      date: DateTime.now(),
      entry: _controller.text.trim(),
      moodRating: _rating,
    );

    // This sends the data from the phone (Client) to Firebase (Server)
    await FirestoreService().addEntry(entry);

    if (mounted) {
      Navigator.pop(context); // Go back to Home Screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Gratitude'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "What are 1-3 things you're grateful for?",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            const Text("How's your mood?", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (index) {
                int rating = index + 1;
                return IconButton(
                  icon: MoodIconUtility.buildMoodIcon(
                      rating,
                      size: _rating == rating ? 48 : 32 // Make selected icon bigger
                  ),
                  onPressed: () => setState(() => _rating = rating),
                );
              }),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveToCloud,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(15),
                ),
                child: const Text('SAVE TO FIREBASE SERVER', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}