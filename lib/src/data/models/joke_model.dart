// Response Model for Joke API
class JokeModel {
  JokeModel(this.joke);

  factory JokeModel.fromJson(Map<String, dynamic> json) {
    return JokeModel(json['joke'] as String);
  }
  final String joke;
}
