import 'package:package_state_bloc_todolist/package_state_bloc_todolist.dart';
import 'package:package_state_riverpod_todolist/package_state_riverpod_todolist.dart'
    as riverpod_todolist;
import 'package:package_state_bloc/package_state_bloc.dart';
import 'package:package_state_provider_todolist/package_state_provider_todolist.dart'
    as provider_todolist;

import 'package:package_state_value_notifier/package_state_value_notifier.dart'
    as package_state_value_notifier;

import 'package:package_state_value_notifier_todolist/package_state_value_notifier_todolist.dart'
    as package_state_value_notifier_todolist;
import 'package:package_state_change_notifier/package_state_change_notifier.dart'
    as package_state_change_notifier;

// void main() => package_state_value_notifier_todolist
//     .runPackageStateValueNotifierTodolistApp();
// void main() => runPackageStateBlocApp();
// void main1() => runPackageStateBlocTodolistApp();
// void main() => riverpod_todolist.runPackageStateRiverpodTodolistApp();
// void main() => provider_todolist.runPackageStateProviderTodolistApp();
// void main() => package_state_value_notifier.runPackageStateValueNotifierApp();

void main() => package_state_change_notifier.runPackageStateChangeNotifierApp();
