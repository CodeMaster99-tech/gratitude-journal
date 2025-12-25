// lib/entry_detail_screen.dart
import 'package:flutter/material.dart';
import 'firestore_service.dart';
import 'mood_icon_utility.dart';

class EntryDetailScreen extends StatefulWidget {
  final GratitudeEntry entry;
  const EntryDetailScreen({super.key, required this.entry});

  @override
  State<EntryDetailScreen> createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends State<EntryDetailScreen> {
  late TextEditingController _controller;
  late int _rating;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.entry.entry);
    _rating = widget.entry.moodRating;
  }

  void _update() async {
    final updated = GratitudeEntry(
      id: widget.entry.id,
      date: widget.entry.date,
      entry: _controller.text,
      moodRating: _rating,
    );
    await FirestoreService().updateEntry(updated);
    if (mounted) Navigator.pop(context);
  }

  void _delete() async {
    await FirestoreService().deleteEntry(widget.entry.id!);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Entry'),
        actions: [IconButton(icon: const Icon(Icons.delete), onPressed: _delete)],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _controller, maxLines: 4, decoration: const InputDecoration(border: OutlineInputBorder())),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(5, (i) => IconButton(
                icon: MoodIconUtility.buildMoodIcon(i + 1, size: _rating == i + 1 ? 45 : 30),
                onPressed: () => setState(() => _rating = i + 1),
              )),
            ),
            const SizedBox(height: 30),
            ElevatedButton(onPressed: _update, child: const Text('Update Server'))
          ],
        ),
      ),
    );
  }
}