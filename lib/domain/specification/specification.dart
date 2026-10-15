abstract interface class Specification<R extends Specification<R, T>, T> {
  bool isSatisfiedBy(T object);
  R and(R specification);
  R or(R specification);
}
