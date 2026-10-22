import 'package:dynamic_filter/domain/either/either.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/either_fixtures.dart';
import '../../fixtures/exception_fixtures.dart';

void main() {
  group('isLeft', () {
    for (final (either, isLeft) in [
      (fakeLeftEither, true),
      (fakeRightEither, false),
    ]) {
      test('Given the $Either is a ${either.runtimeType} '
          'When the isLeft getter is called '
          'Then it returns $isLeft', () {
        expect(either.isLeft, equals(isLeft));
      });
    }
  });

  group('isRight', () {
    for (final (either, isRight) in [
      (fakeLeftEither, false),
      (fakeRightEither, true),
    ]) {
      test('Given the $Either is a ${either.runtimeType} '
          'When the isRight getter is called '
          'Then it returns $isRight', () {
        expect(either.isRight, equals(isRight));
      });
    }
  });

  group('fold', () {
    for (final (either, expectedValue) in [
      (fakeLeftEither, 1),
      (fakeRightEither, 2),
    ]) {
      test('Given the $Either is a ${either.runtimeType} '
          'When the fold method is called '
          'Then the correct callback is used', () {
        expect(
          either.fold(left: (_) => 1, right: (_) => 2),
          equals(expectedValue),
        );
      });
    }
  });

  group('map', () {
    for (final (either, newEither) in [
      (fakeLeftEither, const LeftEither<FakeException, int>(fakeException)),
      (fakeRightEither, const RightEither<FakeException, int>(42)),
    ]) {
      test('Given the $Either is a ${either.runtimeType} '
          'When the map method is called '
          'Then the correct callback is used', () {
        expect(
          either.peek(debugPrintEither).map((_) => 42).peek(debugPrintEither),
          equals(newEither),
        );
      });
    }
  });

  group('biMap', () {
    for (final (either, newEither) in [
      (
        fakeLeftEither,
        const LeftEither<FakeException, int>(FakeException('bar')),
      ),
      (fakeRightEither, const RightEither<FakeException, int>(42)),
    ]) {
      test('Given the $Either is a ${either.runtimeType} '
          'When the biMap method is called '
          'Then the correct callback is used', () {
        expect(
          either
              .peek(debugPrintEither)
              .biMap(left: (_) => const FakeException('bar'), right: (_) => 42)
              .peek(debugPrintEither),
          equals(newEither),
        );
      });
    }
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
    for (final either in [fakeLeftEither, fakeRightEither]) {
      test('Given the $Either is a ${either.runtimeType} '
          'When the peek method is called '
          'Then the correct action is performed', () {
        bool isCorrectAction = false;
        final anotherEither = either.peek(
          (e) => isCorrectAction = (e == either),
        );
        expect(isCorrectAction, isTrue);
        expect(anotherEither, equals(either));
      });
    }
  });
}
