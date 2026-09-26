
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/models/invoice.dart';
import '../../data/invoice_repository.dart';
import '../../../clients/presentation/providers/client_provider.dart';

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepository(SupabaseConfig.client);
});

// A provider that fetches invoices and attaches the client locally, 
// updating whenever the invoices stream or clients stream updates.
final invoicesProvider = StreamProvider<List<Invoice>>((ref) async* {
  final invoiceRepo = ref.watch(invoiceRepositoryProvider);
  final clients = await ref.watch(clientsStreamProvider.future);
  
  await for (final invoicesData in invoiceRepo.watchInvoices()) {
    final enrichedInvoices = invoicesData.map((inv) {
      final client = clients.where((c) => c.id == inv.clientId).firstOrNull;
      // We manually attach the client object
      return Invoice(
        id: inv.id,
        userId: inv.userId,
        clientId: inv.clientId,
        client: client,
        invoiceNumber: inv.invoiceNumber,
        projectName: inv.projectName,
        amount: inv.amount,
        currency: inv.currency,
        invoiceDate: inv.invoiceDate,
        dueDate: inv.dueDate,
        status: calculateInvoiceStatus(inv), // dynamically calculate status based on dates!
        notes: inv.notes,
        paidAt: inv.paidAt,
        createdAt: inv.createdAt,
        updatedAt: inv.updatedAt,
      );
    }).toList();
    yield enrichedInvoices;
  }
});

// Pure function to calculate dynamic status
InvoiceStatus calculateInvoiceStatus(Invoice inv) {
  if (inv.paidAt != null || inv.status == InvoiceStatus.paid) {
    return InvoiceStatus.paid;
  }

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final due = DateTime(inv.dueDate.year, inv.dueDate.month, inv.dueDate.day);
  
  final difference = due.difference(today).inDays;

  if (difference < 0) {
    return InvoiceStatus.overdue;
  } else if (difference == 0) {
    return InvoiceStatus.due;
  } else if (difference <= 7) {
    return InvoiceStatus.dueSoon;
  } else {
    return InvoiceStatus.upcoming;
  }
}
