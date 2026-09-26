import 'client.dart';

enum InvoiceStatus {
  draft,
  upcoming,
  dueSoon,
  due,
  overdue,
  paid;

  String get toSupabaseString {
    switch (this) {
      case InvoiceStatus.draft: return 'draft';
      case InvoiceStatus.upcoming: return 'upcoming';
      case InvoiceStatus.dueSoon: return 'due_soon';
      case InvoiceStatus.due: return 'due';
      case InvoiceStatus.overdue: return 'overdue';
      case InvoiceStatus.paid: return 'paid';
    }
  }

  static InvoiceStatus fromSupabaseString(String status) {
    switch (status) {
      case 'draft': return InvoiceStatus.draft;
      case 'upcoming': return InvoiceStatus.upcoming;
      case 'due_soon': return InvoiceStatus.dueSoon;
      case 'due': return InvoiceStatus.due;
      case 'overdue': return InvoiceStatus.overdue;
      case 'paid': return InvoiceStatus.paid;
      default: return InvoiceStatus.draft;
    }
  }
}

class Invoice {
  final String id;
  final String userId;
  final String clientId;
  final Client? client; // Joined relation
  final String invoiceNumber;
  final String projectName;
  final double amount;
  final String currency;
  final DateTime invoiceDate;
  final DateTime dueDate;
  final InvoiceStatus status;
  final String? notes;
  final DateTime? paidAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  Invoice({
    required this.id,
    required this.userId,
    required this.clientId,
    this.client,
    required this.invoiceNumber,
    required this.projectName,
    required this.amount,
    this.currency = 'USD',
    required this.invoiceDate,
    required this.dueDate,
    required this.status,
    this.notes,
    this.paidAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      clientId: json['client_id'] as String,
      client: json['clients'] != null ? Client.fromJson(json['clients'] as Map<String, dynamic>) : null,
      invoiceNumber: json['invoice_number'] as String,
      projectName: json['project_name'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      invoiceDate: DateTime.parse(json['invoice_date'] as String),
      dueDate: DateTime.parse(json['due_date'] as String),
      status: InvoiceStatus.fromSupabaseString(json['status'] as String),
      notes: json['notes'] as String?,
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at'] as String) : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'client_id': clientId,
      'invoice_number': invoiceNumber,
      'project_name': projectName,
      'amount': amount,
      'currency': currency,
      'invoice_date': invoiceDate.toIso8601String().split('T')[0],
      'due_date': dueDate.toIso8601String().split('T')[0],
      'status': status.toSupabaseString,
      if (notes != null && notes!.isNotEmpty) 'notes': notes,
      if (paidAt != null) 'paid_at': paidAt!.toIso8601String(),
    };
  }
}
