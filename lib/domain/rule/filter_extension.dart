import 'package:dynamic_filter/domain/filter/abstracts/composite_filter.dart';
import 'package:dynamic_filter/domain/filter/filter.dart';
import 'package:dynamic_filter/domain/rule/rule.dart';

extension FilterExt<T> on Filter<T> {
  Rule<T>? convertToRuleUntilTarget(Filter<T> target, {Rule<T>? parent}) {
    final rule = Rule(filter: this, next: parent);
    if (this == target) return rule;
    if (this case CompositeFilter<T> composite) {
      for (final component in composite.components) {
        final componentRule = component.convertToRuleUntilTarget(
          target,
          parent: rule,
        );
        if (componentRule != null) return componentRule;
      }
    }
    return null;
  }
}
