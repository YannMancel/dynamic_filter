import 'package:flutter/foundation.dart';

@immutable
final class StateTransitionException implements Exception {
  const StateTransitionException(this._message);

  final String _message;

  String get message => _message;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is StateTransitionException &&
            runtimeType == other.runtimeType &&
            _message == other._message;
  }

  @override
  int get hashCode => _message.hashCode;

  @override
  String toString() => 'StateTransitionException{message: $_message}';
}
