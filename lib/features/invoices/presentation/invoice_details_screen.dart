import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/models/invoice.dart';
import 'providers/invoice_provider.dart';
import 'package:go_router/go_router.dart';

class InvoiceDetailsScreen extends ConsumerStatefulWidget {
  final String invoiceId;
  const InvoiceDetailsScreen({super.key, required this.invoiceId});

  @override
  ConsumerState<InvoiceDetailsScreen> createState() => _InvoiceDetailsScreenState();
}

class _InvoiceDetailsScreenState extends ConsumerState<InvoiceDetailsScreen> {
  bool _isLoading = false;

  String _getDaysText(Invoice invoice) {
    if (invoice.status == InvoiceStatus.paid) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(invoice.dueDate.year, invoice.dueDate.month, invoice.dueDate.day);
    final difference = due.difference(today).inDays;

    if (difference < 0) {
      return '${difference.abs()} days overdue';
    } else if (difference == 0) {
      return 'Due today';
    } else {
      return 'Due in $difference days';
    }
  }

  String _formatDate(DateTime date) {
    final months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return '${months[date.month - 1]} ${date.day}';
  }

  Future<void> _updatePaymentStatus(Invoice invoice, bool isPaid) async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(invoiceRepositoryProvider);
      if (isPaid) {
        await repo.updateInvoice(invoice.id, {
          'status': 'paid',
          'paid_at': DateTime.now().toIso8601String(),
        });
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice marked as paid.')));
      } else {
        await repo.updateInvoice(invoice.id, {
          'status': 'draft',
          'paid_at': null,
        });
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice marked as unpaid.')));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating status: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final invoicesAsync = ref.watch(invoicesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () async {
              await ref.read(invoiceRepositoryProvider).deleteInvoice(widget.invoiceId);
              if (context.mounted) context.go('/invoices');
            },
          )
        ],
      ),
      body: invoicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (invoices) {
          final invoice = invoices.where((i) => i.id == widget.invoiceId).firstOrNull;
          if (invoice == null) return const Center(child: Text('Invoice not found'));
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(invoice.projectName, style: Theme.of(context).textTheme.titleLarge)),
                    StatusBadge(status: invoice.status),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Client Name', style: Theme.of(context).textTheme.bodySmall),
                        Text(invoice.client?.name ?? 'Unknown', style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 12),
                        Text('Invoice Number', style: Theme.of(context).textTheme.bodySmall),
                        Text(invoice.invoiceNumber, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 12),
                        Text('Amount', style: Theme.of(context).textTheme.bodySmall),
                        Text('\$${invoice.amount.toStringAsFixed(2)} ${invoice.currency}', style: Theme.of(context).textTheme.titleLarge),
                        const SizedBox(height: 12),
                        Text('Invoice Date', style: Theme.of(context).textTheme.bodySmall),
                        Text(_formatDate(invoice.invoiceDate), style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 12),
                        if (invoice.status == InvoiceStatus.paid && invoice.paidAt != null) ...[
                          Text('Paid Date', style: Theme.of(context).textTheme.bodySmall),
                          Text('Paid ${_formatDate(invoice.paidAt!)}', style: Theme.of(context).textTheme.bodyLarge),
                        ] else ...[
                          Text('Due Date', style: Theme.of(context).textTheme.bodySmall),
                          Text('Due ${_formatDate(invoice.dueDate)}', style: Theme.of(context).textTheme.bodyLarge),
                          const SizedBox(height: 4),
                          Text(_getDaysText(invoice), style: TextStyle(
                            color: invoice.status == InvoiceStatus.overdue ? Colors.red : Colors.grey[700],
                            fontWeight: FontWeight.bold
                          )),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (invoice.status != InvoiceStatus.paid)
                  ElevatedButton(
                    onPressed: () => _updatePaymentStatus(invoice, true),
                    child: const Center(child: Text('Mark as Paid')),
                  )
                else
                  TextButton(
                    onPressed: () => _updatePaymentStatus(invoice, false),
                    child: const Center(child: Text('Mark as Unpaid')),
                  ),
              ],
            ),
          );
        }
      ),
    );
  }
}
