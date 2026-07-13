final class FakeException implements Exception {
  const FakeException(this._message);

  final String _message;

  String get message => _message;

  @override
  String toString() => 'FakeException{message: $_message}';
}

const fakeException = FakeException('fake');
