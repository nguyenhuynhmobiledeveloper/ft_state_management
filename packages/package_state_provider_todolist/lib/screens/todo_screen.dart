import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/todo_provider.dart';
import '../providers/todo_state.dart';

// Vẫn đung StatefulWidget chứ không CustomWidget giống RiverPod
class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final _controller = TextEditingController();
  late final TodoProvider _todoProvider;

  @override
  void initState() {
    super.initState();
    // read lấy controller một lần, không đăng ký vẽ lại widget.
    // Listener riêng chỉ dùng cho hiệu ứng một lần: hiện SnackBar khi có lỗi.
    _todoProvider = context.read<TodoProvider>();
    _todoProvider.addListener(_showErrorIfNeeded);

    // Đợi khung hình đầu tiên để trạng thái loading xuất hiện trước khi đọc I/O.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _todoProvider.loadTodos();
    });
  }

  // Hàm show snackbar nếu có text lỗi
  void _showErrorIfNeeded() {
    if (!mounted) return;
    final message = _todoProvider.state.errorMessage;
    if (message != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  /// Ô nhập được xóa ngay khi gửi, kể cả khi lần ghi sau đó thất bại.
  void _addTodo() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    // Sử dụng context.read để chạy hàm trong provider
    context.read<TodoProvider>().addTodo(title);
    _controller.clear();
  }

  @override
  void dispose() {
    _todoProvider.removeListener(_showErrorIfNeeded);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List với Provider')),

      // Consumer đăng ký theo dõi TodoProvider. notifyListeners() gọi lại
      // builder này, từ đó các số đếm, bộ lọc và danh sách được vẽ theo state.
      body: Consumer<TodoProvider>(
        builder: (context, todoController, _) {
          final state = todoController.state;
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
                // Lấy ra số lượng todo chưa được hoàn thành
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
                                  // read gọi thao tác, không tạo thêm listener.
                                  onChanged: (_) => context
                                      .read<TodoProvider>()
                                      .toggleTodo(todo.id),
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
                                  onPressed: () => context
                                      .read<TodoProvider>()
                                      .deleteTodo(todo.id),
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
        context.read<TodoProvider>().changeFilter(filter);
      },
    );
  }
}
