import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/profile_controller.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool editing = false;
  late TextEditingController nameCtrl;
  late TextEditingController ageCtrl;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileControllerProvider).value;
    nameCtrl = TextEditingController(text: profile?.name ?? '');
    ageCtrl = TextEditingController(text: profile?.age.toString() ?? '');
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileControllerProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(editing ? Icons.check : Icons.edit),
            onPressed: () async {
              if (!editing) {
                setState(() => editing = true);
                return;
              }
              await ref.read(profileControllerProvider.notifier).updateProfile(
                    name: nameCtrl.text,
                    age: int.tryParse(ageCtrl.text) ?? profile?.age ?? 0,
                  );
              setState(() => editing = false);
            },
          ),
        ],
      ),
      body: profile == null
          ? const Center(child: Text('Complete onboarding to view your profile.'))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: nameCtrl,
                          enabled: editing,
                          decoration: const InputDecoration(labelText: 'Name'),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: ageCtrl,
                          enabled: editing,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Age'),
                        ),
                        const SizedBox(height: 12),
                        Text('Joined: ${profile.dateJoined?.toIso8601String().split("T").first ?? 'today'}'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.military_tech_outlined),
                    title: const Text('Badges'),
                    subtitle: Text(
                      profile.badges.isEmpty ? 'No badges yet' : profile.badges.join(' • '),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.settings_outlined),
                    title: const Text('Settings'),
                    subtitle: const Text('Notification preferences (placeholder)'),
                  ),
                ),
              ],
            ),
    );
  }
}

