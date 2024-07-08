abstract class APagination {
  int page;
  int total;
  int size;
  String? search;
  String? id;

  APagination({
    this.page = 0,
    this.total = 100,
    this.size = 50,
    this.search,
    this.id,
  }) {
    reset();
  }

  void reset() {}

  void increment() {}

  @override
  String toString() {
    return '''
APagination(
  page: $page,
  total: $total,
  size: $size,
)''';
  }
}

class CustomError {
  final String? message;

  CustomError({
    required this.message,
  });

  factory CustomError.fromJson(Map<String, dynamic> data) {
    return CustomError(
      message: data['message'],
    );
  }
}
