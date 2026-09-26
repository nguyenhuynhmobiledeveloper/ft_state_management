# todo_blocs

Package chứa tất cả các BLoCs (business logic) của Todo app:

- **TodoBloc**: BLoC chính quản lý danh sách todos (CRUD)
- **FilterBloc**: BLoC quản lý filter (All/Active/Completed)
- **SearchBloc**: BLoC quản lý search query với debounce
- **FilteredTodosBloc**: BLoC tổng hợp kết quả từ 3 BLoCs trên