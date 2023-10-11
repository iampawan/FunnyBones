import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funnybone/src/domain/entities/joke.dart';
import 'package:funnybone/src/presentation/bloc/joke_bloc.dart';
import 'package:funnybone/src/presentation/widgets/joke_view.dart';

// A widget to display the list of jokes
class JokeListWidget extends StatelessWidget {
  JokeListWidget(this._jokeBloc, {super.key});
  final JokeBloc _jokeBloc;
  final _scrollController = ScrollController(); // Create a ScrollController

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JokeBloc, JokeState>(
      bloc: _jokeBloc,
      builder: (context, state) {
        if (state is JokeInitial) {
          return _buildInitialLoading(); // Show loading indicator initially
        } else if (state is JokeLoaded) {
          scrollToLast(context);
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

  void scrollToLast(BuildContext context) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent +
            MediaQuery.of(context).padding.bottom +
            20.0,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildInitialLoading() {
    // Show a loading indicator while the initial joke is being fetched
    return const CircularProgressIndicator.adaptive();
  }

  Widget _buildJokeList(List<Joke> jokes) {
    if (jokes.isEmpty) {
      return const Center(
        child: Text(
          'No jokes found',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      );
    }
    // Build the list of jokes using a ListView.builder
    return ListView.builder(
      controller: _scrollController,
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
