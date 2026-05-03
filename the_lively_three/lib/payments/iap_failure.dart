class IapFailure implements Exception {
  final String message;
  final String code; // optional, handy for analytics/filters
  IapFailure(this.message, {this.code = ''});
  @override
  String toString() => message;
}