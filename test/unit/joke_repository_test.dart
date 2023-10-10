// test/unit/joke_repository_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:funnybone/src/core/result.dart';
import 'package:funnybone/src/data/data_sources/remote_data_source.dart';
import 'package:funnybone/src/data/models/joke_model.dart';
import 'package:funnybone/src/data/repositories/joke_repository_impl.dart';
import 'package:funnybone/src/domain/entities/joke.dart';
import 'package:funnybone/src/domain/repositories/joke_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('JokeRepository', () {
    late JokeRepository repository;
    late RemoteDataSource remoteDataSource;

    setUp(() {
      remoteDataSource = MockRemoteDataSource();

      repository =
          JokeRepositoryImpl(remoteDataSource, MockSharedPreferences());
    });

    test('fetchJoke should return a Joke', () async {
      final jokeModel = JokeModel('This is a joke');
      when(() => remoteDataSource.fetchJoke())
          .thenAnswer((_) async => '{"joke": "${jokeModel.joke}"}');

      final result = await repository.fetchJoke();
      expect(
        ((result as Success).data as Joke).text,
        jokeModel.joke,
      );
    });
  });
}
