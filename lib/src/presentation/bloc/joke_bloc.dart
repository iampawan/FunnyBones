import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:funnybone/src/core/result.dart';
import 'package:funnybone/src/domain/entities/joke.dart';
import 'package:funnybone/src/domain/repositories/joke_repository.dart';
import 'package:funnybone/src/domain/usecases/fetch_jokes.dart';

part 'joke_event.dart';
part 'joke_state.dart';

class JokeBloc extends Bloc<JokeEvent, JokeState> {
  JokeBloc(this.repository)
      : fetchJokes = FetchJokes(repository),
        super(const JokeInitial()) {
    on<FetchJokeEvent>(mapFetchJokeToState);
    on<LoadSavedJokesEvent>(mapLoadSavedJokeToState);
    on<ClearAllJokesEvent>(mapClearAllJokesToState);
  }
  final FetchJokes fetchJokes;
  final JokeRepository repository;

  List<Joke> allJokes = [];

  // A method to map the FetchJokeEvent to the JokeState
  Future<void> mapFetchJokeToState(
    FetchJokeEvent event,
    Emitter<JokeState> emit,
  ) async {
    final result = await fetchJokes();
    if (result is Success<Joke>) {
      final joke = result.data!;
      emit(JokeLoaded([joke]));
      removeDuplicatedAndAddNewJoke(joke);
      await _saveJokesToRepository(
        allJokes,
      ); // Save
    } else {
      final error = result as Failure;
      emit(JokeError(error.exception.toString()));
    }
  }

// A method to remove duplicated jokes and add new jokes
  void removeDuplicatedAndAddNewJoke(Joke joke) {
    if (allJokes.contains(joke)) {
      allJokes.remove(joke);
    }
    allJokes = [...allJokes, joke];
  }

  // A method to map the LoadSavedJokesEvent to the JokeState
  Future<void> mapLoadSavedJokeToState(
    LoadSavedJokesEvent event,
    Emitter<JokeState> emit,
  ) async {
    final result = await repository.getSavedJokes();
    if (result is Success<List<Joke>>) {
      final jokes = result.data!;
      allJokes = jokes;
      emit(JokeLoaded(allJokes));
    } else {
      final error = result as Failure;
      emit(JokeError(error.exception.toString()));
    }
  }

  // A method to map the ClearAllJokesEvent to the JokeState
  Future<void> mapClearAllJokesToState(
    ClearAllJokesEvent event,
    Emitter<JokeState> emit,
  ) async {
    final result = await repository.clearAllJokes();
    if (result is Success) {
      allJokes = [];
      emit(JokeLoaded(allJokes));
    } else {
      final error = result as Failure;
      emit(JokeError(error.exception.toString()));
    }
  }

  // Add a method to save jokes to the repository
  Future<void> _saveJokesToRepository(List<Joke> jokes) async {
    final result = await repository.saveJokes(jokes);
    if (result is Failure) {
      debugPrint('Failed to save jokes: ${result.exception}');
    } else {
      debugPrint('Saved jokes successfully');
    }
  }
}
