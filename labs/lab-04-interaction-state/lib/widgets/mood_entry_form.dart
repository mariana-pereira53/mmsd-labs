import 'package:flutter/material.dart';

import '../models/mood_entry.dart';
import 'mood_score_selector.dart';

/// A form for recording a new mood entry.
///
/// Exercise 1, step 3, and Exercise 2, steps 1-3.
class MoodEntryForm extends StatefulWidget {
  const MoodEntryForm({super.key, required this.onSubmit});

  /// Called with the new entry when the user saves it.
  final ValueChanged<MoodEntry> onSubmit;

  @override
  State<MoodEntryForm> createState() => _MoodEntryFormState();
}

class _MoodEntryFormState extends State<MoodEntryForm> {
  // TODO 1.3: Declare the selected score. It starts with nothing selected:
  int? _score;

  // TODO 2.1: Declare a TextEditingController for the note. Override
  //   dispose() and call _noteController.dispose() before super.dispose().
  //   Why does a controller need disposing when an int does not?
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  // TODO 2.3: Write a _save() method that:
  //   1. creates a MoodEntry with the selected score, the trimmed note
  //      (or null if the trimmed note is empty) and DateTime.now()
  //   2. passes the entry to widget.onSubmit
  //   3. clears the form: no score selected and an empty note
  void _save() {
    if (_score == null)
      return;

    final rawNote = _noteController.text.trim();
    final note = rawNote.isEmpty ? null : rawNote;

    final entry = MoodEntry(
      score: _score!,
      note: note,
      createdAt: DateTime.now(),
    );

    widget.onSubmit(entry);

    setState(() {
      _score = null;
      _noteController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'How are you feeling?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            // TODO 1.3 (continued): Pass _score instead of null. In
            //   onChanged, store the tapped score inside setState(() { ... }).
            //   Then try it without setState. What happens, and why?
            MoodScoreSelector(
                selectedScore: _score,
                onChanged: (score) {
                  setState(() {
                    _score = score;
                  });
                }
            ),
            const SizedBox(height: 12),
            // TODO 2.2: Add a TextField for the note that uses your
            //   controller, labelled 'Note (optional)' (InputDecoration).
            //
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Note (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // TODO 2.3 (continued): Add a FilledButton labelled 'Save entry'
            //   that calls _save. While no score is selected, pass
            //   onPressed: null so that the button is disabled.
            FilledButton(
              onPressed: _score == null ? null : _save,
              child: const Text('Save entry'),
            ),
          ],
        ),
      ),
    );
  }
}
