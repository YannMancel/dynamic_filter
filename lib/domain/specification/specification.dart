abstract interface class Specification<T> {
  bool isSatisfiedBy(T object);
  Specification<T> and(Specification<T> specification);
  Specification<T> or(Specification<T> specification);
}
