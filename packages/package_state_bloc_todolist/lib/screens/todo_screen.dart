import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _controller = TextEditingController();

  void _addTodo() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;

    context.read<TodoBloc>().add(TodoAdded(title));
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List với BLoC')),
      body: BlocConsumer<TodoBloc, TodoState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final visibleTodos = state.visibleTodos;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (_) => _addTodo(),
                        decoration: const InputDecoration(
                          labelText: 'Công việc mới',
                          hintText: 'Ví dụ: Học Flutter',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: _addTodo,
                      icon: const Icon(Icons.add),
                      label: const Text('Thêm'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Còn ${state.remainingCount}/${state.todos.length} công việc chưa hoàn thành',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    _filterChip('Tất cả', TodoFilter.all, state.filter),
                    _filterChip('Chưa xong', TodoFilter.active, state.filter),
                    _filterChip('Đã xong', TodoFilter.completed, state.filter),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: visibleTodos.isEmpty
                      ? const Center(child: Text('Chưa có công việc nào.'))
                      : ListView.separated(
                          itemCount: visibleTodos.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final todo = visibleTodos[index];
                            return Card(
                              key: ValueKey(todo.id),
                              margin: EdgeInsets.zero,
                              child: ListTile(
                                leading: Checkbox(
                                  value: todo.isCompleted,
                                  onChanged: (_) => context
                                      .read<TodoBloc>()
                                      .add(TodoToggled(todo.id)),
                                ),
                                title: Text(
                                  todo.title,
                                  style: TextStyle(
                                    decoration: todo.isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                trailing: IconButton(
                                  tooltip: 'Xóa công việc',
                                  onPressed: () => context.read<TodoBloc>().add(
                                    TodoDeleted(todo.id),
                                  ),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _filterChip(String label, TodoFilter filter, TodoFilter current) {
    return ChoiceChip(
      label: Text(label),
      selected: current == filter,
      onSelected: (_) {
        context.read<TodoBloc>().add(TodoFilterChanged(filter));
      },
    );
  }
}
