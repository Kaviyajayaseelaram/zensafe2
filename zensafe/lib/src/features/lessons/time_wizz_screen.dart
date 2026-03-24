import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../state/profile_controller.dart';

class TimeWizzScreen extends ConsumerStatefulWidget {
  const TimeWizzScreen({super.key});

  @override
  ConsumerState<TimeWizzScreen> createState() => _TimeWizzScreenState();
}

class _TimeWizzScreenState extends ConsumerState<TimeWizzScreen> {
  final _controller = TextEditingController();
  final List<_Task> _tasks = [];
  int _xp = 0;

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _tasks.add(_Task(text));
      _controller.clear();
    });
  }

  void _toggleTask(_Task task) {
    setState(() {
      task.done = !task.done;
      if (task.done) {
        _xp += 8;
        ref.read(profileControllerProvider.notifier).awardXp(
              delta: 8,
              reason: 'timewizz_task_complete',
            );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Great! Task completed. +8 XP')),
        );
      }
    });
  }

  void _deleteTask(_Task task) {
    setState(() => _tasks.remove(task));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Wizz'),
        backgroundColor: Colors.lightBlue.shade400,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Add a task',
                      hintText: 'e.g., Pack school bag',
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _addTask,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 16),
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
                  Text('XP earned: $_xp'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _tasks.isEmpty
                  ? Center(
                      child: Text(
                        'No tasks yet. Add one!',
                        style: TextStyle(color: Colors.blueGrey.shade400),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task = _tasks[index];
                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: task.done,
                              onChanged: (_) => _toggleTask(task),
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.done ? TextDecoration.lineThrough : null,
                                color: task.done ? Colors.green : null,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => _deleteTask(task),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Task {
  _Task(this.title);
  final String title;
  bool done = false;
}


