# package_state_bloc

Package Flutter chứa ví dụ quản lý Todo bằng BLoC: model, repository, event,
state, BLoC, màn hình và tiện ích.

Thêm package vào `pubspec.yaml` của ứng dụng:

```yaml
dependencies:
  package_state_bloc:
    path: packages/package_state_bloc
```

Import API chung và khởi chạy ứng dụng ví dụ:

```dart
import 'package:package_state_bloc/package_state_bloc.dart';

void main() => runPackageStateBlocApp();
```

`runPackageStateBlocApp()` thiết lập `SimpleBlocObserver` trước khi tạo các BLoC
và hiển thị `MyApp`. Các BLoC, event, state, model, repository và màn hình cũng
được export qua import trên.
