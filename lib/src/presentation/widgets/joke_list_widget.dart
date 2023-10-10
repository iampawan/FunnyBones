import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funnybone/src/domain/entities/joke.dart';
import 'package:funnybone/src/presentation/bloc/joke_bloc.dart';
import 'package:funnybone/src/presentation/widgets/joke_view.dart';

// A widget to display the list of jokes
class JokeListWidget extends StatelessWidget {
  const JokeListWidget(this._jokeBloc, {super.key});
  final JokeBloc _jokeBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JokeBloc, JokeState>(
      bloc: _jokeBloc,
      builder: (context, state) {
        if (state is JokeInitial) {
          return _buildInitialLoading(); // Show loading indicator initially
        } else if (state is JokeLoaded) {
          final jokes = _jokeBloc.allJokes;
          // Trim the list to keep a maximum of 10 jokes
          if (jokes.length > 10) {
            jokes.removeRange(0, jokes.length - 10);
          }
          return _buildJokeList(jokes); // Build the joke list
        } else if (state is JokeError) {
          return _buildError(state.errorMessage); // Handle error state
        } else {
          return const CircularProgressIndicator
              .adaptive(); // Default loading indicator
        }
      },
    );
  }

  Widget _buildInitialLoading() {
    // Show a loading indicator while the initial joke is being fetched
    return const CircularProgressIndicator.adaptive();
  }

  Widget _buildJokeList(List<Joke> jokes) {
    // Build the list of jokes using a ListView.builder
    return ListView.builder(
      itemCount: jokes.length,
      itemBuilder: (context, index) {
        final joke = jokes[index];
        return JokeView(
          joke: joke.text,
        );
      },
    );
  }

  Widget _buildError(String errorMessage) {
    // Handle the error state by displaying an error message
    return Center(
      child: Text(
        'Error: $errorMessage',
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
