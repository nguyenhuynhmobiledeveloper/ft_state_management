import 'package:flutter_test/flutter_test.dart';
import 'package:package_state_bloc/package_state_bloc.dart';

void main() {
  testWidgets('Ứng dụng sử dụng màn hình từ package_state_bloc', (tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text('BLoC Pattern Demo'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
  });
}
