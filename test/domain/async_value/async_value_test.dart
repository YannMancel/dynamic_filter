import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/async_value_fixtures.dart';

void main() {
  group('when', () {
    for (final (asyncValue, message) in [
      (fakeIdleAsyncValue, 'Idle'),
      (fakeLoadingAsyncValue, 'Loading'),
      (fakeFailureAsyncValue, 'Failure: FakeException{message: fake}'),
      (fakeSuccessAsyncValue, 'Success: foo'),
    ]) {
      test('Given the async value equals to $asyncValue '
          'When the when method is called '
          'Then the correct message is returned', () {
        expect(
          asyncValue.when(
            idle: () => 'Idle',
            loading: () => 'Loading',
            failure: (exception) => 'Failure: $exception',
            success: (value) => 'Success: $value',
          ),
          equals(message),
        );
      });
    }
  });

  group('maybeWhen', () {
    for (final (asyncValue, message) in [
      (fakeIdleAsyncValue, 'Idle'),
      (fakeLoadingAsyncValue, 'Loading'),
      (fakeFailureAsyncValue, 'Failure: FakeException{message: fake}'),
      (fakeSuccessAsyncValue, 'Success: foo'),
    ]) {
      test('Given the async value equals to $asyncValue '
          'When the maybeWhen method is called '
          'Then the subclass callback takes precedence over '
          'the orElse callback '
          'And the correct message is returned', () {
        expect(
          asyncValue.maybeWhen(
            idle: () => 'Idle',
            loading: () => 'Loading',
            failure: (exception) => 'Failure: $exception',
            success: (value) => 'Success: $value',
            orElse: () => 'orElse',
          ),
          equals(message),
        );
      });
    }

    for (final asyncValue in [
      fakeIdleAsyncValue,
      fakeLoadingAsyncValue,
      fakeFailureAsyncValue,
      fakeSuccessAsyncValue,
    ]) {
      test('Given the async value equals to $asyncValue '
          'When the maybeWhen method is called '
          'And there is no subclass callback '
          'Then the correct message is returned', () {
        expect(asyncValue.maybeWhen(orElse: () => 'orElse'), equals('orElse'));
      });
    }
  });
}
