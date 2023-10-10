import 'package:shared_preferences/shared_preferences.dart';

// Constants is a class that holds all the constants used in the app.
class Constants {
  static late SharedPreferences prefs;

  // Keys for shared preferences
  static const jokeListKey = 'jokeListKey';

  // API Base URL
  static const baseUrl = 'https://geek-jokes.sameerkumar.website';

  // Time in minutes to fetch a new joke
  static int minutesToFetchJoke = 1;
}
