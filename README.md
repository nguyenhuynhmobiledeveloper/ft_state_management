# ft_state_management

Flutter BLoC Pattern Demo - Monorepo với Melos.

## Cấu trúc Monorepo

```
ft_state_management/
├── melos.yaml                    # Melos config
├── pubspec.yaml                  # App shell (demo_ft_bloc)
├── lib/                          # App shell - chỉ chứa UI
│   ├── main.dart
│   ├── screens/                  # Màn hình UI
│   └── examples/                 # Demo code (giữ nguyên)
└── packages/
    ├── todo_core/                # Models, Repository, BlocObserver, Extensions
    ├── todo_events_states/       # Events & States cho các BLoCs
    └── todo_blocs/               # Tất cả BLoCs (business logic)
```

## Dependency Graph

```
demo_ft_bloc (app shell)
    ├── todo_blocs
    │    ├── todo_events_states
    │    │    └── todo_core
    │    └── todo_core
    ├── todo_events_states
    │    └── todo_core
    └── todo_core
```

## Cài đặt & Sử dụng

### Yêu cầu

- Flutter SDK >= 3.0
- Dart SDK >= 2.17.6
- [Melos](https://melos.invertase.dev/) - để quản lý monorepo

### Bootstrap monorepo

```bash
# Cài Melos (1 lần)
dart pub global activate melos

# Bootstrap tất cả packages (liên kết path dependencies)
melos bootstrap
```

### Các lệnh Melos thường dùng

```bash
# Phân tích code trong tất cả packages
melos run analyze

# Format code trong tất cả packages
melos run format

# Kiểm tra format
melos run format-check

# Chạy tests trong tất cả packages
melos run test

# Xem danh sách packages
melos list

# Xem version của tất cả packages
melos run version-all
```

### Chạy app

```bash
flutter run
```

## Packages

| Package | Mô tả |
|---------|--------|
| `todo_core` | Models (`Todo`, `TodoFilter`), Repository (`TodoRepository`), `SimpleBlocObserver`, Bloc extensions |
| `todo_events_states` | Tất cả Events & States cho 4 BLoCs: Todo, Filter, Search, FilteredTodos |
| `todo_blocs` | 4 BLoCs: `TodoBloc`, `FilterBloc`, `SearchBloc`, `FilteredTodosBloc` |
| `demo_ft_bloc` (app shell) | UI: `main.dart`, `screens/`, `examples/` |

## Lợi ích của việc tách package

1. **Tách concerns rõ ràng**: UI / business logic / data layer được tách biệt
2. **Dễ test**: Mỗi package có thể test độc lập với `bloc_test`
3. **Tái sử dụng**: Có thể publish các package này lên pub.dev sau này
4. **Quản lý version độc lập**: Mỗi package có version riêng
5. **CI/CD đơn giản**: Có thể test/build từng package riêng biệt
6. **Parallel development**: Nhiều người có thể làm việc trên các package khác nhau