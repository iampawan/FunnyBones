// test/unit/joke_repository_test.dart

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:funnybone/src/constants.dart';
import 'package:funnybone/src/data/data_sources/remote_data_source.dart';
import 'package:funnybone/src/data/models/joke_model.dart';
import 'package:funnybone/src/data/repositories/joke_repository_impl.dart';
import 'package:funnybone/src/domain/repositories/joke_repository.dart';
import 'package:funnybone/src/presentation/bloc/joke_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('Bloc Tests', () {
    late JokeRepository repository;
    late RemoteDataSource remoteDataSource;
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      remoteDataSource = MockRemoteDataSource();
      mockSharedPreferences = MockSharedPreferences();

      repository = JokeRepositoryImpl(remoteDataSource, mockSharedPreferences);

      final jokeModel = JokeModel('This is a joke');
      when(() => remoteDataSource.fetchJoke())
          .thenAnswer((_) async => '{"joke": "${jokeModel.joke}"}');
    });

    blocTest<JokeBloc, JokeState>(
      'emits [JokeLoading, JokeLoaded] when FetchJokeEvent is added.',
      build: () {
        when(
          () => mockSharedPreferences.setStringList(
            Constants.jokeListKey,
            any(),
          ),
        ).thenAnswer((_) async => true);
        return JokeBloc(repository);
      },
      act: (bloc) => bloc.add(const FetchJokeEvent()),
      expect: () => [
        isA<JokeLoaded>(),
      ],
      verify: (bloc) => [
        expect(
          bloc.allJokes,
          isNotEmpty,
        ),
        verify(() => repository.fetchJoke()).called(1),
      ],
    );

    blocTest<JokeBloc, JokeState>(
      'emits [JokeLoading, JokeLoaded] when LoadJokeEvent is added.',
      build: () => JokeBloc(repository),
      act: (bloc) => bloc.add(const LoadSavedJokesEvent()),
      expect: () => [
        isA<JokeLoaded>(),
      ],
      verify: (bloc) => [
        expect(
          bloc.allJokes,
          isEmpty,
        ),
        verify(() => repository.getSavedJokes()).called(1),
      ],
    );

    blocTest<JokeBloc, JokeState>(
      'emits [JokeLoading, JokeLoaded] when ClearAllJokesEvent is added.',
      build: () {
        when(() => mockSharedPreferences.clear()).thenAnswer((_) async => true);
        return JokeBloc(repository);
      },
      act: (bloc) => bloc.add(const ClearAllJokesEvent()),
      expect: () => [
        isA<JokeLoaded>(),
      ],
      verify: (bloc) => [
        expect(
          bloc.allJokes,
          isEmpty,
        ),
        verify(() => repository.clearAllJokes()).called(1),
      ],
    );
  });
}
