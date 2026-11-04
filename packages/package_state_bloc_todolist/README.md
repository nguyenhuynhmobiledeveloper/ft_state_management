# package_state_bloc_todolist

A Flutter Todo list package using BLoC for state management and shared preferences for persistence.

Add the package to the application's `pubspec.yaml`:

```yaml
dependencies:
  package_state_bloc_todolist:
    path: packages/package_state_bloc_todolist
```

Launch the example from `lib/main.dart`:

```dart
import 'package:package_state_bloc_todolist/package_state_bloc_todolist.dart';

void main() => runPackageStateBlocTodolistApp();
```

The public library also exports `TodoApp`, `TodoBloc`, events, state, model, repository, and screen.
