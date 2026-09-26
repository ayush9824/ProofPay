import 'package:flutter_test/flutter_test.dart';
import 'package:proofpay/core/models/invoice.dart';
import 'package:proofpay/features/invoices/presentation/providers/invoice_provider.dart';

void main() {
  group('Invoice Status Calculation Tests', () {
    Invoice createInvoice({required DateTime dueDate, DateTime? paidAt, InvoiceStatus status = InvoiceStatus.draft}) {
      return Invoice(
        id: '1',
        userId: '1',
        clientId: '1',
        invoiceNumber: 'INV-001',
        projectName: 'Test Project',
        amount: 1000,
        invoiceDate: DateTime.now().subtract(const Duration(days: 30)),
        dueDate: dueDate,
        status: status,
        paidAt: paidAt,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }

    test('Due date more than 7 days away (Upcoming)', () {
      final inv = createInvoice(dueDate: DateTime.now().add(const Duration(days: 8)));
      expect(calculateInvoiceStatus(inv), InvoiceStatus.upcoming);
    });

    test('Due date exactly 7 days away (Due Soon)', () {
      final inv = createInvoice(dueDate: DateTime.now().add(const Duration(days: 7)));
      expect(calculateInvoiceStatus(inv), InvoiceStatus.dueSoon);
    });

    test('Due date within 7 days (Due Soon)', () {
      final inv = createInvoice(dueDate: DateTime.now().add(const Duration(days: 3)));
      expect(calculateInvoiceStatus(inv), InvoiceStatus.dueSoon);
    });

    test('Due date today (Due)', () {
      final inv = createInvoice(dueDate: DateTime.now());
      expect(calculateInvoiceStatus(inv), InvoiceStatus.due);
    });

    test('Due date yesterday (Overdue)', () {
      final inv = createInvoice(dueDate: DateTime.now().subtract(const Duration(days: 1)));
      expect(calculateInvoiceStatus(inv), InvoiceStatus.overdue);
    });

    test('Due date several days ago (Overdue)', () {
      final inv = createInvoice(dueDate: DateTime.now().subtract(const Duration(days: 10)));
      expect(calculateInvoiceStatus(inv), InvoiceStatus.overdue);
    });

    test('Paid invoice with past due date (Paid)', () {
      final inv = createInvoice(dueDate: DateTime.now().subtract(const Duration(days: 10)), paidAt: DateTime.now(), status: InvoiceStatus.paid);
      expect(calculateInvoiceStatus(inv), InvoiceStatus.paid);
    });

    test('Paid invoice with future due date (Paid)', () {
      final inv = createInvoice(dueDate: DateTime.now().add(const Duration(days: 10)), paidAt: DateTime.now(), status: InvoiceStatus.paid);
      expect(calculateInvoiceStatus(inv), InvoiceStatus.paid);
    });

    test('Changing due date from overdue to upcoming', () {
      var inv = createInvoice(dueDate: DateTime.now().subtract(const Duration(days: 5)));
      expect(calculateInvoiceStatus(inv), InvoiceStatus.overdue);
      
      // Simulate edit
      inv = createInvoice(dueDate: DateTime.now().add(const Duration(days: 10)));
      expect(calculateInvoiceStatus(inv), InvoiceStatus.upcoming);
    });
    
    test('Marking invoice paid', () {
      var inv = createInvoice(dueDate: DateTime.now().subtract(const Duration(days: 5)));
      expect(calculateInvoiceStatus(inv), InvoiceStatus.overdue);
      
      // Simulate mark paid
      inv = createInvoice(dueDate: inv.dueDate, paidAt: DateTime.now(), status: InvoiceStatus.paid);
      expect(calculateInvoiceStatus(inv), InvoiceStatus.paid);
    });
    
    test('Changing paid invoice back to unpaid', () {
      var inv = createInvoice(dueDate: DateTime.now().subtract(const Duration(days: 5)), paidAt: DateTime.now(), status: InvoiceStatus.paid);
      expect(calculateInvoiceStatus(inv), InvoiceStatus.paid);
      
      // Simulate mark unpaid
      inv = createInvoice(dueDate: inv.dueDate, paidAt: null, status: InvoiceStatus.draft);
      expect(calculateInvoiceStatus(inv), InvoiceStatus.overdue);
    });
  });
}
