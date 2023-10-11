import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:funnybone/app/app.dart';
import 'package:funnybone/src/constants.dart';
import 'package:funnybone/src/presentation/screens/joke_screen.dart';
import 'package:funnybone/src/presentation/widgets/joke_list_widget.dart';
import 'package:funnybone/src/presentation/widgets/joke_view.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/helpers.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    Constants.prefs = MockSharedPreferences();
  });

  group('App', () {
    testWidgets('renders JokeScreen', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(JokeScreen), findsOneWidget);

      expect(find.byType(JokeListWidget), findsOneWidget);
    });

    testWidgets('Find Widgets', (tester) async {
      await tester.pumpApp(const JokeScreen());
      expect(find.byType(JokeListWidget), findsOneWidget);
      expect(find.byIcon(Icons.clear_all), findsOneWidget);
      // This will fail if the language is not English on the device
      expect(find.text('Funny Bones'), findsOneWidget);
    });

    testWidgets('Joke View Test', (tester) async {
      await tester.pumpApp(
        const JokeView(
          joke: 'This is a joke',
        ),
      );

      await tester.pumpAndSettle(const Duration(milliseconds: 400));

      expect(
        find.byType(AnimatedContainer),
        findsOneWidget,
      );
      expect(
        find.text('😄'),
        findsOneWidget,
      );
      expect(find.text('This is a joke'), findsOneWidget);
    });
  });
}
