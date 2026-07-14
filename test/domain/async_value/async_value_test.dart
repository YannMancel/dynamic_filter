import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/async_value_fixtures.dart';

void main() {
  group('when', () {
    [
          (asyncValue: fakeIdleAsyncValue, message: 'Idle'),
          (asyncValue: fakeLoadingAsyncValue, message: 'Loading'),
          (
            asyncValue: fakeFailureAsyncValue,
            message: 'Failure: FakeException{message: fake}',
          ),
          (asyncValue: fakeSuccessAsyncValue, message: 'Success: foo'),
        ]
        .map(
          (config) =>
              test('Given the async value equals to ${config.asyncValue} '
                  'When the when method is called '
                  'Then the correct message is returned', () {
                final message = config.asyncValue.when(
                  idle: () => 'Idle',
                  loading: () => 'Loading',
                  failure: (exception) => 'Failure: $exception',
                  success: (value) => 'Success: $value',
                );
                expect(message, equals(config.message));
              }),
        )
        .toList();
  });

  group('maybeWhen', () {
    [
          (asyncValue: fakeIdleAsyncValue, message: 'Idle'),
          (asyncValue: fakeLoadingAsyncValue, message: 'Loading'),
          (
            asyncValue: fakeFailureAsyncValue,
            message: 'Failure: FakeException{message: fake}',
          ),
          (asyncValue: fakeSuccessAsyncValue, message: 'Success: foo'),
        ]
        .map(
          (config) =>
              test('Given the async value equals to ${config.asyncValue} '
                  'When the maybeWhen method is called '
                  'Then the subclass callback takes precedence over '
                  'the orElse callback '
                  'And the correct message is returned', () {
                final message = config.asyncValue.maybeWhen(
                  idle: () => 'Idle',
                  loading: () => 'Loading',
                  failure: (exception) => 'Failure: $exception',
                  success: (value) => 'Success: $value',
                  orElse: () => 'orElse',
                );
                expect(message, equals(config.message));
              }),
        )
        .toList();

    [
          fakeIdleAsyncValue,
          fakeLoadingAsyncValue,
          fakeFailureAsyncValue,
          fakeSuccessAsyncValue,
        ]
        .map(
          (asyncValue) => test('Given the async value equals to $asyncValue '
              'When the maybeWhen method is called '
              'And there is no subclass callback '
              'Then the correct message is returned', () {
            final message = asyncValue.maybeWhen(orElse: () => 'orElse');
            expect(message, equals('orElse'));
          }),
        )
        .toList();
  });
}
