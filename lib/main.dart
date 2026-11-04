import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:demo_ft_state_management/Riverpod/demo_Riverpod/index.dart';

import 'package:demo_ft_state_management/Riverpod/doc_riverpod/main.dart';
// import 'package:demo_ft_state_management/Riverpod/doc_riverpod_v2/main.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

