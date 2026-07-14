import 'package:dynamic_filter/domain/async_value/async_value.dart';

import 'exception_fixtures.dart';

const fakeIdleAsyncValue = IdleAsyncValue<FakeException, String>();
const fakeLoadingAsyncValue = LoadingAsyncValue<FakeException, String>();
final fakeFailureAsyncValue = FailureAsyncValue<FakeException, String>(
  fakeException,
);
final fakeSuccessAsyncValue = SuccessAsyncValue<FakeException, String>('foo');
