import '../utils/json_utils.dart';

class Loan {
  final int id;
  final int? readerId;
  final String? readerName;
  final int? bookId;
  final String? bookTitle;
  final DateTime issuedAt;
  final DateTime dueAt;
  final DateTime? returnedAt;
  final String status;
  final DateTime? deletedAt;

  const Loan({
    required this.id,
    required this.issuedAt,
    required this.dueAt,
    required this.status,
    this.readerId,
    this.readerName,
    this.bookId,
    this.bookTitle,
    this.returnedAt,
    this.deletedAt,
  });

  bool get isActive => status == 'active' || status == 'overdue';

  factory Loan.fromJson(Map<String, dynamic> json) {
    final reader = json['reader'];
    final book = json['book'];
    return Loan(
      id: asInt(json['id']),
      readerId: reader is Map ? asInt(reader['id']) : asInt(json['readerId']),
      readerName: reader is Map ? asString(reader['fullName']) : null,
      bookId: book is Map ? asInt(book['id']) : asInt(json['bookId']),
      bookTitle: book is Map ? asString(book['title']) : null,
      issuedAt: asDateTime(json['issuedAt']) ?? DateTime.now(),
      dueAt: asDateTime(json['dueAt']) ?? DateTime.now(),
      returnedAt: asDateTime(json['returnedAt']),
      status: asString(json['status'], 'active'),
      deletedAt: asDateTime(json['deletedAt']),
    );
  }
}
