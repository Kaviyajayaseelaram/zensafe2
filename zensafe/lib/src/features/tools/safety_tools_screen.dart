import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/chat_message.dart';
import '../../services/supabase_service.dart';
import '../../state/profile_controller.dart';

class SafetyToolsScreen extends ConsumerStatefulWidget {
  const SafetyToolsScreen({super.key});

  @override
  ConsumerState<SafetyToolsScreen> createState() => _SafetyToolsScreenState();
}

class _SafetyToolsScreenState extends ConsumerState<SafetyToolsScreen> {
  int _breathSeconds = 0;
  Timer? _timer;
  final _moodCtrl = TextEditingController();
  bool _savingJournal = false;
  List<Map<String, dynamic>> _contacts = [];
  bool _loadingContacts = false;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _moodCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadContacts() async {
    final profile = ref.read(profileControllerProvider).value;
    if (profile == null) return;
    setState(() => _loadingContacts = true);
    final contacts = await SupabaseService.fetchEmergencyContacts(profile.id);
    setState(() {
      _contacts = contacts;
      _loadingContacts = false;
    });
  }

  void _startBreathing() {
    _timer?.cancel();
    _breathSeconds = 30;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_breathSeconds == 0) {
        timer.cancel();
      } else {
        setState(() => _breathSeconds -= 1);
      }
    });
  }

  Future<void> _saveMoodJournal() async {
    final profile = ref.read(profileControllerProvider).value;
    if (profile == null || _moodCtrl.text.isEmpty) return;
    setState(() => _savingJournal = true);
    final entry = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: ChatSender.user,
      content: 'Mood journal: ${_moodCtrl.text}',
      createdAt: DateTime.now(),
    );
    await SupabaseService.logChat(entry);
    await ref.read(profileControllerProvider.notifier).awardXp(
          delta: 2,
          reason: 'mood_journal',
          completedWellness: true,
        );
    setState(() => _savingJournal = false);
    if (mounted) {
      _moodCtrl.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mood journal saved (+2 XP)')),
      );
    }
  }

  Future<void> _addContact() async {
    final profile = ref.read(profileControllerProvider).value;
    if (profile == null) return;
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add emergency contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Phone')),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
          ],
        );
      },
    );
    if (result == true && nameCtrl.text.isNotEmpty && phoneCtrl.text.isNotEmpty) {
      await SupabaseService.addEmergencyContact(
        userId: profile.id,
        name: nameCtrl.text,
        phone: phoneCtrl.text,
      );
      await ref.read(profileControllerProvider.notifier).awardXp(
            delta: 10,
            reason: 'emergency_contact_setup',
          );
      await _loadContacts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Safety Toolkit')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.sos, color: Colors.red),
              title: const Text('SOS Button'),
              subtitle: const Text('Call your main contact quickly'),
              trailing: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('SOS triggered (placeholder)')),
                  );
                },
                child: const Text('Call'),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Breathing Exercise'),
                  const SizedBox(height: 8),
                  Text(_breathSeconds > 0
                      ? 'Inhale 4s • Exhale 6s • ${_breathSeconds}s left'
                      : 'Tap start for a 30s calm-down'),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _startBreathing,
                    child: Text(_breathSeconds > 0 ? 'Running...' : 'Start 30s'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Mood Journal'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _moodCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(hintText: 'How are you feeling today?'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: _savingJournal ? null : _saveMoodJournal,
                    child: _savingJournal
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save +2 XP'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on_outlined, color: Colors.blue),
              title: const Text('Live Location'),
              subtitle: const Text('Placeholder - integrate share sheet later'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Location sharing coming soon')),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Emergency Contacts', style: TextStyle(fontWeight: FontWeight.w700)),
                      TextButton(onPressed: _addContact, child: const Text('Add +10 XP')),
                    ],
                  ),
                  if (_loadingContacts)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  if (!_loadingContacts && _contacts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('No contacts yet'),
                    ),
                  for (final contact in _contacts)
                    ListTile(
                      leading: const Icon(Icons.person_outline),
                      title: Text(contact['name']?.toString() ?? ''),
                      subtitle: Text(contact['phone']?.toString() ?? ''),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

