const expenseCategories = <String>[
  'Sinh hoạt',
  'Đi lại',
  'Học tập',
  'Sức Khỏe',
  'Khác'
];

class Expense {
  const Expense({
    this.id,
    required this.title,
    required this.price,
    required this.category,
    required this.day,
  });

  final int? id;
  final String title;
  final double price;
  final String category;
  final DateTime day;

  factory Expense.fromMap(Map<String, Object?> map) {
    return Expense(
      id: map['id'] as int?,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      category: map['category'] as String,
      day: DateTime.parse(map['day'] as String),
    );
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'price': price,
      'category': category,
      'day': day.toIso8601String(),
    };
  }

  Expense copyWith({
    int? id,
    String? title,
    double? price,
    String? category,
    DateTime? day,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      category: category ?? this.category,
      day: day ?? this.day,
    );
  }
}
