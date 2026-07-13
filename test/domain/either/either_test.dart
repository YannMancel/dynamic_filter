import 'package:dynamic_filter/domain/either/either.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/either_fixtures.dart';
import '../../fixtures/exception_fixtures.dart';

void main() {
  group('isLeft', () {
    [
          (either: fakeLeftEither, isLeft: isTrue),
          (either: fakeRightEither, isLeft: isFalse),
        ]
        .map(
          (config) =>
              test('Given the $Either is a ${config.either.runtimeType} '
                  'When the isLeft getter is called '
                  'Then it returns ${config.isLeft}', () {
                expect(config.either.isLeft, config.isLeft);
              }),
        )
        .toList();
  });

  group('isRight', () {
    [
          (either: fakeLeftEither, isRight: isFalse),
          (either: fakeRightEither, isRight: isTrue),
        ]
        .map(
          (config) =>
              test('Given the $Either is a ${config.either.runtimeType} '
                  'When the isRight getter is called '
                  'Then it returns ${config.isRight}', () {
                expect(config.either.isRight, config.isRight);
              }),
        )
        .toList();
  });

  group('fold', () {
    [
          (either: fakeLeftEither, expectedValue: 1),
          (either: fakeRightEither, expectedValue: 2),
        ]
        .map(
          (config) =>
              test('Given the $Either is a ${config.either.runtimeType} '
                  'When the fold method is called '
                  'Then the correct callback is used', () {
                expect(
                  config.either.fold(left: (_) => 1, right: (_) => 2),
                  equals(config.expectedValue),
                );
              }),
        )
        .toList();
  });

  group('map', () {
    [
          (
            either: fakeLeftEither,
            newEither: const LeftEither<FakeException, int>(fakeException),
          ),
          (
            either: fakeRightEither,
            newEither: const RightEither<FakeException, int>(42),
          ),
        ]
        .map(
          (config) =>
              test('Given the $Either is a ${config.either.runtimeType} '
                  'When the map method is called '
                  'Then the correct callback is used', () {
                final either = config.either
                    .peek(debugPrintEither)
                    .map((_) => 42)
                    .peek(debugPrintEither);
                expect(either, equals(config.newEither));
              }),
        )
        .toList();
  });

  group('biMap', () {
    [
          (
            either: fakeLeftEither,
            newEither: const LeftEither<FakeException, int>(
              FakeException('bar'),
            ),
          ),
          (
            either: fakeRightEither,
            newEither: const RightEither<FakeException, int>(42),
          ),
        ]
        .map(
          (config) =>
              test('Given the $Either is a ${config.either.runtimeType} '
                  'When the biMap method is called '
                  'Then the correct callback is used', () {
                final either = config.either
                    .peek(debugPrintEither)
                    .biMap(
                      left: (_) => const FakeException('bar'),
                      right: (_) => 42,
                    )
                    .peek(debugPrintEither);
                expect(either, equals(config.newEither));
              }),
        )
        .toList();
  });

  group('flatMap', () {
    test('Given the $Either is a $RightEither '
        'When the flatMap method is called to convert to another $RightEither '
        'Then it returns a correct $Either', () {
      final either = fakeRightEither
          .peek(debugPrintEither)
          .flatMap((_) => const RightEither<FakeException, int>(1))
          .peek(debugPrintEither)
          .flatMap((_) => const RightEither<FakeException, double>(1.3))
          .peek(debugPrintEither);
      expect(either, equals(const RightEither<FakeException, double>(1.3)));
    });

    test('Given the $Either is a $RightEither '
        'When the flatMap method is called to convert to $LeftEither '
        'Then it returns a correct $Either', () {
      final either = fakeRightEither
          .peek(debugPrintEither)
          .flatMap((_) => const LeftEither<FakeException, int>(fakeException))
          .peek(debugPrintEither);
      expect(
        either,
        equals(const LeftEither<FakeException, int>(fakeException)),
      );
    });

    test('Given the $Either is a $LeftEither '
        'When the flatMap method is called to convert to another $LeftEither '
        'Then it returns a correct $Either', () {
      final either = fakeLeftEither
          .peek(debugPrintEither)
          .flatMap(
            // ⚠️ Never used during this test
            (_) => const RightEither<FakeException, int>(1),
          )
          .peek(debugPrintEither);
      expect(
        either,
        equals(const LeftEither<FakeException, int>(fakeException)),
      );
    });
  });

  group('peek', () {
    [fakeLeftEither, fakeRightEither]
        .map(
          (either) => test('Given the $Either is a ${either.runtimeType} '
              'When the peek method is called '
              'Then the correct action is performed', () {
            bool isCorrectAction = false;
            final anotherEither = either.peek(
              (e) => isCorrectAction = (e == either),
            );
            expect(isCorrectAction, isTrue);
            expect(anotherEither, equals(either));
          }),
        )
        .toList();
  });
}
