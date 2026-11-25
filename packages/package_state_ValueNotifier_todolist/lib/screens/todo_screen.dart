import 'package:flutter/material.dart';

import '../controllers/todo_controller.dart';
import '../models/todo_state.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _todos = TodoController();
  final _input = TextEditingController();

  void _addTodo() {
    if (_input.text.trim().isEmpty) return;
    _todos.addTodo(_input.text);
    _input.clear();
  }

  @override
  void dispose() {
    _input.dispose();
    _todos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('09. To-do tổng hợp')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Ô nhập nằm ngoài builder của danh sách.
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _input,
                    onSubmitted: (_) => _addTodo(),
                    decoration: const InputDecoration(
                      labelText: 'Công việc mới',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(onPressed: _addTodo, child: const Text('Thêm')),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: _todos.changeQuery,
              decoration: const InputDecoration(
                labelText: 'Tìm công việc',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ValueListenableBuilder<TodoState>(
                valueListenable: _todos,
                builder: (context, state, child) {
                  final visibleTodos = state.visibleTodos;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Còn ${state.remainingCount}/${state.todos.length} '
                        'công việc chưa hoàn thành',
                      ),
                      Wrap(
                        spacing: 8,
                        children: [
                          _filterChip('Tất cả', TodoFilter.all, state.filter),
                          _filterChip(
                            'Chưa xong',
                            TodoFilter.active,
                            state.filter,
                          ),
                          _filterChip(
                            'Đã xong',
                            TodoFilter.completed,
                            state.filter,
                          ),
                        ],
                      ),
                      Expanded(
                        child: visibleTodos.isEmpty
                            ? const Center(
                                child: Text('Không có công việc phù hợp'),
                              )
                            : ListView.builder(
                                itemCount: visibleTodos.length,
                                itemBuilder: (context, index) {
                                  final todo = visibleTodos[index];
                                  return ListTile(
                                    key: ValueKey(todo.id),
                                    leading: Checkbox(
                                      value: todo.isCompleted,
                                      onChanged: (_) =>
                                          _todos.toggleTodo(todo.id),
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
                                      tooltip: 'Xóa ${todo.title}',
                                      onPressed: () =>
                                          _todos.removeTodo(todo.id),
                                      icon: const Icon(Icons.delete_outline),
                                    ),
                                  );
                                },
                              ),
                      ),
                      TextButton(
                        onPressed: state.completedCount == 0
                            ? null
                            : _todos.clearCompleted,
                        child: const Text('Xóa các việc đã xong'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChip(String label, TodoFilter filter, TodoFilter current) {
    return ChoiceChip(
      label: Text(label),
      selected: current == filter,
      onSelected: (_) => _todos.changeFilter(filter),
    );
  }
}
