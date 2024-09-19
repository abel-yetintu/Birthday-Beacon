enum Relationship {
  family,
  friend,
  work,
  other;

  String toMap() => name;
  static Relationship fromString(String json) => values.byName(json);
}
