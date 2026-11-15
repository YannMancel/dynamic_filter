import 'package:dynamic_filter/domain/rule/filter_response.dart';

extension FilterResponseExt<T> on FilterResponse<T> {
  String get debugLabel {
    return when(
      empty: () => 'empty',
      same: (filter) => '$filter',
      update: (filter) => '$filter',
    );
  }
}
