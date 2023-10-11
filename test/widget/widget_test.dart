import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:funnybone/app/app.dart';
import 'package:funnybone/src/constants.dart';
import 'package:funnybone/src/domain/entities/joke.dart';
import 'package:funnybone/src/presentation/bloc/joke_bloc.dart';
import 'package:funnybone/src/presentation/screens/joke_screen.dart';
import 'package:funnybone/src/presentation/widgets/joke_list_widget.dart';
import 'package:funnybone/src/presentation/widgets/joke_view.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../bloc/bloc_test.dart';
import '../helpers/helpers.dart';

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
      // This will fail if the language is not English on the device
      expect(find.text('Funny Bones'), findsOneWidget);
      expect(find.byType(JokeListWidget), findsOneWidget);
      expect(find.byIcon(Icons.clear_all), findsOneWidget);
      await tester.tap(find.byIcon(Icons.clear_all));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
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

  testWidgets('Joke List Widget Test', (tester) async {
    final mockJokeBloc = MockJokeBloc();

    when(() => mockJokeBloc.state).thenReturn(const JokeLoaded([]));
    when(() => mockJokeBloc.stream).thenAnswer((_) => const Stream.empty());

    when(() => mockJokeBloc.add(const FetchJokeEvent())).thenAnswer((_) async {
      mockJokeBloc.emit(JokeLoaded([Joke('This is a joke')]));
    });

    when(() => mockJokeBloc.allJokes).thenReturn([Joke('This is a joke')]);

    final jokeBloc = mockJokeBloc..add(const FetchJokeEvent());
    await tester.pumpApp(JokeListWidget(jokeBloc));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(
      find.byType(ListView),
      findsOneWidget,
    );
  });
}
