import 'package:dynamic_filter/domain/either/either.dart';
import 'package:flutter/foundation.dart';

import 'exception_fixtures.dart';

const fakeLeftEither = LeftEither<FakeException, String>(fakeException);
const fakeRightEither = RightEither<FakeException, String>('foo');

void debugPrintEither<L, R>(Either<L, R> either) {
  final buffer = StringBuffer('${either.runtimeType}: ');
  buffer.write(
    either.fold(left: (value) => '$value', right: (value) => '$value'),
  );
  debugPrint(buffer.toString());
}
