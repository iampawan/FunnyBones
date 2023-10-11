// Result is a sealed class that can be either Success or Failure.
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  const Success({this.data});
  final T? data;
}

class Failure<T> extends Result<T> {
  const Failure({required this.exception});
  final String exception;
}
