import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/profile_controller.dart';

class WordScrambleScreen extends ConsumerStatefulWidget {
  const WordScrambleScreen({super.key});

  @override
  ConsumerState<WordScrambleScreen> createState() => _WordScrambleScreenState();
}

class _WordScrambleScreenState extends ConsumerState<WordScrambleScreen> {
  final _rng = Random();
  final Map<String, List<String>> _categories = {
    'Colors': ['red', 'blue', 'green', 'pink', 'purple', 'yellow', 'orange', 'white', 'black', 'brown'],
    'Animals': ['lion', 'tiger', 'zebra', 'panda', 'bunny', 'kitty', 'puppy', 'horse', 'fox', 'whale'],
    'Fruits': ['apple', 'mango', 'banana', 'grape', 'peach', 'berry', 'melon', 'lemon', 'pear', 'plum'],
    'Shapes': ['circle', 'square', 'triangle', 'star', 'heart', 'oval', 'diamond', 'rectangle', 'cube', 'cone'],
    'School': ['pencil', 'eraser', 'crayon', 'notebook', 'marker', 'desk', 'ruler', 'paper', 'glue', 'chalk'],
  };

  late String _currentCategory;
  late String _currentWord;
  late String _scrambled;
  final _controller = TextEditingController();
  int _streak = 0;
  int _xp = 0;

  @override
  void initState() {
    super.initState();
    _currentCategory = _categories.keys.first;
    _generateWord();
  }

  void _generateWord() {
    final words = _categories[_currentCategory]!;
    _currentWord = words[_rng.nextInt(words.length)];
    final chars = _currentWord.split('')..shuffle(_rng);
    _scrambled = chars.join();
    _controller.clear();
  }

  void _checkAnswer() {
    if (_controller.text.trim().toLowerCase() == _currentWord.toLowerCase()) {
      setState(() {
        _streak += 1;
        _xp += 10;
      });
      ref.read(profileControllerProvider.notifier).awardXp(
            delta: 10,
            reason: 'word_scramble_correct',
          );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Great job! +10 XP')),
      );
    } else {
      setState(() => _streak = 0);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Try again!')),
      );
    }
    _generateWord();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Word Scramble'),
        backgroundColor: Colors.lightBlue.shade400,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber),
                  const SizedBox(width: 8),
                  Text('Streak: $_streak  •  XP: $_xp'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _currentCategory,
              decoration: const InputDecoration(labelText: 'Category'),
              items: _categories.keys
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  _currentCategory = value;
                  _generateWord();
                });
              },
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                _scrambled.toUpperCase(),
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 4),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Your answer',
                hintText: 'Type the word',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _checkAnswer,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Check'),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.shuffle),
                  onPressed: () {
                    setState(() => _generateWord());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


