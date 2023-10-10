part of 'joke_bloc.dart';

abstract class JokeEvent {
  const JokeEvent();
}

// Thie event is used to fetch a joke from the API
class FetchJokeEvent extends JokeEvent {
  const FetchJokeEvent();
}

// This event is used to load saved jokes from the repository
class LoadSavedJokesEvent extends JokeEvent {
  const LoadSavedJokesEvent();
}

// This event is used to clear all jokes from the repository
class ClearAllJokesEvent extends JokeEvent {
  const ClearAllJokesEvent();
}
