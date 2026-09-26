# todo_core

Package chứa các thành phần core (data layer & cross-cutting concerns) của Todo app:

- **Models**: `Todo`, `TodoFilter`
- **Repository**: `TodoRepository` - data access layer
- **Observer**: `SimpleBlocObserver` - log tất cả BLoC activities
- **Extensions**: `BlocContextExtensions`, `BlocExtensions` - helper utilities

## Cài đặt

Package này được sử dụng như một phần của monorepo. Vui lòng tham khảo Melos config ở root.