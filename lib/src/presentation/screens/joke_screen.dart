import 'dart:async';

import 'package:flutter/material.dart';
import 'package:funnybone/l10n/l10n.dart';
import 'package:funnybone/src/constants.dart';
import 'package:funnybone/src/data/data_sources/remote_data_source.dart';
import 'package:funnybone/src/data/repositories/joke_repository_impl.dart';
import 'package:funnybone/src/presentation/bloc/joke_bloc.dart';
import 'package:funnybone/src/presentation/widgets/joke_list_widget.dart';

class JokeScreen extends StatefulWidget {
  const JokeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _JokeScreenState createState() => _JokeScreenState();
}

class _JokeScreenState extends State<JokeScreen> {
  Timer? _timer;
  late JokeBloc _jokeBloc;

  // We are using the initState method to initialize the JokeBloc
  // and load the saved jokes
  @override
  void initState() {
    super.initState();
    initJokeBloc();
    _loadSavedJokes();
    _startFetchingJokesPeriodically();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the screen is disposed
    _jokeBloc.close(); // Close the bloc when the screen is disposed
    super.dispose();
  }

  void initJokeBloc() {
    _jokeBloc = JokeBloc(
      JokeRepositoryImpl(
        RemoteDataSource(),
        Constants.prefs,
      ),
    )
      ..add(const LoadSavedJokesEvent()) // Load saved jokes initially
      ..add(const FetchJokeEvent()); // Fetch a joke initially
  }

  // A method to start fetching jokes periodically based on given time
  void _startFetchingJokesPeriodically() {
    final oneMinute = Duration(minutes: Constants.minutesToFetchJoke);
    _timer = Timer.periodic(oneMinute, (_) {
      _jokeBloc.add(const FetchJokeEvent());
    });
  }

  Future<void> _loadSavedJokes() async {
    _jokeBloc.add(const LoadSavedJokesEvent());
  }

  Future<void> _clearAllJokes() async {
    _jokeBloc.add(const ClearAllJokesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appBarTitle),
        actions: [
          IconButton(
            onPressed: _clearAllJokes,
            icon: const Icon(Icons.clear_all),
          ),
        ],
      ),
      body: Center(
        child: JokeListWidget(
          _jokeBloc,
        ), // Pass the list of jokes to the JokeList widget
      ),
    );
  }
}
