part of 'joke_bloc.dart';

abstract class JokeState {
  const JokeState();
}

// Initial state when the app is launched
class JokeInitial extends JokeState {
  const JokeInitial();
}

// Loading state when the app is fetching a joke (Not being used currently)
class JokeLoading extends JokeState {
  const JokeLoading();
}

// Loaded state when the app has fetched a joke

class JokeLoaded extends JokeState {
  const JokeLoaded(this.jokes);
  final List<Joke> jokes;
}

// Error state when the app has encountered an error
class JokeError extends JokeState {
  const JokeError(this.errorMessage);
  final String errorMessage;
}
