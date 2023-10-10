import 'package:funnybone/src/core/result.dart';
import 'package:funnybone/src/domain/entities/joke.dart';

// JokeRepository is an abstract class that defines the methods that the
// JokeRepositoryImpl class must implement.
abstract class JokeRepository {
  Future<Result<Joke>> fetchJoke();
  Future<Result<List<Joke>>> getSavedJokes();
  Future<Result<void>> saveJokes(List<Joke> jokes);
  Future<Result<void>> clearAllJokes();
}
