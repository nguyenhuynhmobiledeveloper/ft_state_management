import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/todo_provider.dart';
import '../providers/todo_state.dart';

// Màn hình todo sử dụng Riverpod, giữ nguyên giao diện của bản RiverPod.
// ConsumerStatefulWidget: qua widget này có thể dùng ref của RiverPod
class TodoScreen extends ConsumerStatefulWidget {
  const TodoScreen({super.key});

  // createState tạo ConsumerState, nơi có thể dùng ref để truy cập provider.
  @override
  ConsumerState<TodoScreen> createState() => _TodoScreenState();
}

// _TodoScreenState quản lý ô nhập và dùng ref để đọc, theo dõi TodoState.
class _TodoScreenState extends ConsumerState<TodoScreen> {
  final _controller = TextEditingController();

  // initState đăng ký tải danh sách sau khung hình đầu tiên.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(todoProvider.notifier) lấy TodoNotifier để gọi loadTodos một lần.
      if (mounted) ref.read(todoProvider.notifier).loadTodos();
    });
  }

  // Hàm thêm todo vào danh sách
  // _addTodo lấy nội dung ô nhập, gọi TodoNotifier.addTodo rồi xóa ô nhập.
  void _addTodo() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;

    // ref.read : dùng để đọc một lần hoặc gọi 1 function
    // Đây 1 gọi function có trong Provider
    ref.read(todoProvider.notifier).addTodo(title);
    _controller.clear();
  }

  // dispose giải phóng TextEditingController khi màn hình bị hủy.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // build vẽ giao diện từ TodoState và đăng ký phản ứng với lỗi.
  @override
  Widget build(BuildContext context) {
    // ref.listen nghe thay đổi của todoProvider để hiện SnackBar khi có lỗi.
    ref.listen<TodoState>(todoProvider, (previous, state) {
      if (state.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      }
    });

    // ref.watch theo dõi todoProvider và khiến build chạy lại khi state đổi.
    final state = ref.watch(todoProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List với RiverPod')),

      body: Builder(
        builder: (context) {
          // Đọc giá trị state đã được lưu trong RiverPod
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Lấy ra danh sách todo dựa theo trạng thái của state filer
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
                                  // Lấy notifier để gọi toggleTodo khi đổi trạng thái checkbox.
                                  onChanged: (_) => ref
                                      .read(todoProvider.notifier)
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
                                  // Lấy notifier để gọi deleteTodo khi nhấn nút xóa.
                                  onPressed: () => ref
                                      .read(todoProvider.notifier)
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

  // _filterChip tạo nút lọc và gọi changeFilter qua TodoNotifier khi được chọn.
  Widget _filterChip(String label, TodoFilter filter, TodoFilter current) {
    return ChoiceChip(
      label: Text(label),
      selected: current == filter,
      // Gọi hàm trong NotifierProvider để có thể thay đổi trạng thái của state filter
      onSelected: (_) {
        ref.read(todoProvider.notifier).changeFilter(filter);
      },
    );
  }
}
