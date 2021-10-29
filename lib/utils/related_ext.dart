extension RelatedExt on String {
  MapEntry relatedTo(List<String> fields) {
    return MapEntry(this, fields);
  }
}
