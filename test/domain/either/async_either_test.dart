import 'package:dynamic_filter/domain/either/async_either.dart';
import 'package:dynamic_filter/domain/either/either.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/either_fixtures.dart';
import '../../fixtures/exception_fixtures.dart';

void main() {
  group('chain', () {
    test('Given the $AsyncEither will get a $RightEither '
        'When the chain method is called to convert to another $RightEither '
        'Then it returns a correct $Either after the completion', () async {
      final asyncEither = AsyncEither(() async => fakeRightEither)
          .peek(debugPrintEither)
          .chain((message) async => RightEither('$message!'))
          .peek(debugPrintEither)
          .chain<int>((message) async => RightEither(message.length))
          .peek(debugPrintEither);
      await expectLater(
        asyncEither.run(),
        completion(equals(const RightEither<FakeException, int>(4))),
      );
    });

    test('Given the $AsyncEither will get a $RightEither '
        'When the chain method is called to convert to $LeftEither '
        'Then it returns a correct $Either after the completion', () async {
      final asyncEither = AsyncEither(() async => fakeRightEither)
          .peek(debugPrintEither)
          .chain<int>((message) async => LeftEither(fakeException))
          .peek(debugPrintEither);
      await expectLater(
        asyncEither.run(),
        completion(equals(const LeftEither<FakeException, int>(fakeException))),
      );
    });

    test('Given the $AsyncEither will get a $LeftEither '
        'When the chain method is called to convert to another $LeftEither '
        'Then it returns a correct $Either after the completion', () async {
      final asyncEither = AsyncEither(() async => fakeLeftEither)
          .peek(debugPrintEither)
          // ⚠️ Only the type conversion of right is apply.
          .chain<int>((message) async => RightEither(message.length))
          .peek(debugPrintEither);
      await expectLater(
        asyncEither.run(),
        completion(equals(const LeftEither<FakeException, int>(fakeException))),
      );
    });
  });

  group('peek', () {
    [fakeLeftEither, fakeRightEither]
        .map(
          (either) => test(
            'Given the $AsyncEither will get a ${either.runtimeType} '
            'When the peek method is called '
            'Then the correct action is performed during the completion',
            () async {
              bool isCorrectAction = false;
              final asyncEither = AsyncEither(
                () async => either,
              ).peek((e) => isCorrectAction = (e == either));
              await expectLater(asyncEither.run(), completion(equals(either)));
              expect(isCorrectAction, isTrue);
            },
          ),
        )
        .toList();
  });

  group('run', () {
    test('Given the guarded $AsyncEither throws a $FakeException '
        'When the run method is called to convert to another $RightEither '
        'Then all next methods are ignored '
        'And it returns a $LeftEither via the onError argument', () async {
      final asyncEither =
          AsyncEither<FakeException, String>.guarded(
                () async => throw fakeException,
                onError: (error, _) async =>
                    error is FakeException ? error : FakeException('$error'),
              )
              .peek(debugPrintEither)
              .chain<int>((message) async => RightEither(message.length))
              .peek(debugPrintEither);
      await expectLater(
        asyncEither.run(),
        completion(equals(const LeftEither<FakeException, int>(fakeException))),
      );
    });

    test('Given the guarded $AsyncEither will get a $RightEither '
        'When the run method is called to convert to another $RightEither '
        'And a $FakeException is throws during the process '
        'Then all next methods are ignored '
        'And it returns a $LeftEither via the onError argument', () async {
      final asyncEither =
          AsyncEither<FakeException, String>.guarded(
                () async => fakeRightEither,
                onError: (error, _) async =>
                    error is FakeException ? error : FakeException('$error'),
              )
              .peek(debugPrintEither)
              .chain<int>((message) async => throw fakeException)
              .peek(debugPrintEither)
              .chain<double>((message) async => throw fakeException)
              .peek(debugPrintEither);
      await expectLater(
        asyncEither.run(),
        completion(
          equals(const LeftEither<FakeException, double>(fakeException)),
        ),
      );
    });
  });
}
