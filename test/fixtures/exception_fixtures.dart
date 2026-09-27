final class FakeException implements Exception {
  final String _message;

  const FakeException(this._message);

  String get message => _message;

  @override
  String toString() => 'FakeException{message: $_message}';
}

const fakeException = FakeException('fake');
