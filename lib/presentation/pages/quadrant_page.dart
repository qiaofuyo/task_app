import 'package:flutter/material.dart';
import '../../domain/value_objects/quadrant.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/task_providers.dart';

class QuadrantPage extends ConsumerWidget {
  static const routeName = '/quadrants';

  const QuadrantPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTasks = ref.watch(tasksProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('四象限任务管理')),
      body: asyncTasks.when(
        data: (tasks) {
          return GridView.count(
            crossAxisCount: 2,
            padding: const EdgeInsets.all(16),
            children: Quadrant.values.map((q) {
              final list = tasks.where((t) => t.quadrant == q).toList();
              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        q.displayName,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      if (list.isEmpty)
                        const Expanded(child: Center(child: Text('无任务')))
                      else
                        Expanded(
                          child: ListView(
                            children: list.map((t) => Text('• ${t.title}')).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('加载失败：$e')),
      ),
    );
  }
}
