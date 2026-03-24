import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/profile_controller.dart';

class DoodleLandScreen extends ConsumerStatefulWidget {
  const DoodleLandScreen({super.key});

  @override
  ConsumerState<DoodleLandScreen> createState() => _DoodleLandScreenState();
}

class _DoodleLandScreenState extends ConsumerState<DoodleLandScreen> {
  final _prompts = const [
    (
      title: 'Happy Dino',
      image:
          'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?auto=format&fit=crop&w=600&q=80',
      note: 'Friendly dinosaur with a big smile.'
    ),
    (
      title: 'Rainbow Rocket',
      image:
          'https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=600&q=80',
      note: 'A rocket blasting through colorful clouds.'
    ),
    (
      title: 'Ocean Friends',
      image:
          'https://images.unsplash.com/photo-1505761671935-60b3a7427bad?auto=format&fit=crop&w=600&q=80',
      note: 'Draw fish, turtles, and bubbles under the sea.'
    ),
    (
      title: 'Jungle Parade',
      image:
          'https://images.unsplash.com/photo-1469536526925-9b5547cd5d38?auto=format&fit=crop&w=600&q=80',
      note: 'Monkeys, parrots, and tall trees.'
    ),
    (
      title: 'Sky Balloons',
      image:
          'https://images.unsplash.com/photo-1505761671935-60b3a7427bad?auto=format&fit=crop&w=600&q=80',
      note: 'Hot air balloons floating in a blue sky.'
    ),
    (
      title: 'Space Buddy',
      image:
          'https://images.unsplash.com/photo-1446941611757-91d2c3bd3d45?auto=format&fit=crop&w=600&q=80',
      note: 'Astronaut waving with planets around.'
    ),
    (
      title: 'Magic Castle',
      image:
          'https://images.unsplash.com/photo-1529429617124-aee3f4ae7890?auto=format&fit=crop&w=600&q=80',
      note: 'Flags, towers, and sparkles.'
    ),
    (
      title: 'Sunny Park',
      image:
          'https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=600&q=80',
      note: 'Slides, swings, and happy kids.'
    ),
    (
      title: 'Robot Pal',
      image:
          'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?auto=format&fit=crop&w=600&q=80',
      note: 'Buttons, lights, and friendly antennas.'
    ),
    (
      title: 'Candy Land',
      image:
          'https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=600&q=80',
      note: 'Lollipops, cupcakes, and sprinkles.'
    ),
    (
      title: 'Cozy Cottage',
      image:
          'https://images.unsplash.com/photo-1475855581690-80accde3ae2b?auto=format&fit=crop&w=600&q=80',
      note: 'Little house with flowers and smoke from the chimney.'
    ),
    (
      title: 'Snowy Fun',
      image:
          'https://images.unsplash.com/photo-1518791841217-8f162f1e1131?auto=format&fit=crop&w=600&q=80',
      note: 'Snowman, mittens, and snowflakes.'
    ),
    (
      title: 'Garden Picnic',
      image:
          'https://images.unsplash.com/photo-1523419400524-4cfa248f00b0?auto=format&fit=crop&w=600&q=80',
      note: 'Basket, fruits, and a sunny blanket.'
    ),
    (
      title: 'Train Adventure',
      image:
          'https://images.unsplash.com/photo-1519677100203-a0e668c92439?auto=format&fit=crop&w=600&q=80',
      note: 'Colorful train with smoke and mountains.'
    ),
    (
      title: 'Bug Buddies',
      image:
          'https://images.unsplash.com/photo-1502082553048-f009c37129b9?auto=format&fit=crop&w=600&q=80',
      note: 'Butterflies, ladybugs, and leaves.'
    ),
  ];

  int _index = 0;
  Uint8List? _uploadPreview;
  String? _uploadName;
  int _xpEarned = 0;

  void _nextPrompt() {
    setState(() {
      _index = (_index + 1) % _prompts.length;
    });
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _uploadPreview = result.files.first.bytes;
        _uploadName = result.files.first.name;
        _xpEarned += 15;
      });
      await ref.read(profileControllerProvider.notifier).awardXp(
            delta: 15,
            reason: 'doodle_upload',
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Awesome! Drawing uploaded. +15 XP')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final prompt = _prompts[_index];
    return Scaffold(
      appBar: AppBar(
        title: const Text('DoodleLand'),
        backgroundColor: Colors.lightBlue.shade400,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.lightBlue.shade50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    prompt.image,
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 220,
                      color: Colors.blue.shade100,
                      alignment: Alignment.center,
                      child: const Text('Image preview'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(prompt.title,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(prompt.note),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _nextPrompt,
                  icon: const Icon(Icons.shuffle),
                  label: const Text('New Prompt'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.file_upload_outlined),
                  label: const Text('Upload drawing'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_uploadPreview != null) ...[
            const Text('Your latest upload', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(_uploadPreview!, height: 180, fit: BoxFit.cover),
            ),
            const SizedBox(height: 6),
            Text(_uploadName ?? 'Drawing'),
          ],
          const SizedBox(height: 12),
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
                Expanded(
                  child: Text('Rewards earned: $_xpEarned XP',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


