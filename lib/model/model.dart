abstract class APagination {
  int get page;
  set page(int value);

  int get total;
  set total(int value);
  int get size;
  set size(int value);
  String? search;
  String? id;

  APagination({
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
