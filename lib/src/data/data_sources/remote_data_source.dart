import 'package:funnybone/src/constants.dart';
import 'package:http/http.dart' as http;

// RemoteDataSource is a class that fetches jokes from the API.
class RemoteDataSource {
  final String apiUrl = '${Constants.baseUrl}/api?format=json';

  Future<String> fetchJoke() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to fetch joke');
    }
  }
}
