
mixin PageAbleModelMixin {
  String get uniqueComparableKey;

  @override
  bool operator ==(Object other) =>
      other is PageAbleModelMixin &&
      runtimeType == other.runtimeType &&
      uniqueComparableKey == other.uniqueComparableKey;

  @override
  int get hashCode => uniqueComparableKey.hashCode;
}
