import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/empty_state.dart';
import 'providers/invoice_provider.dart';

class InvoicesScreen extends ConsumerWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(invoicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Invoices')),
      body: invoicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (invoices) {
          if (invoices.isEmpty) {
            return EmptyState(
              title: 'No invoices yet',
              message: 'Create your first invoice to get started.',
              icon: Icons.receipt_long,
              actionLabel: 'Create Invoice',
              onAction: () => context.go('/invoices/add'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: invoices.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final invoice = invoices[index];
              return Card(
                child: ListTile(
                  onTap: () => context.go('/invoices/${invoice.id}'),
                  title: Text(invoice.client?.name ?? 'Unknown Client', style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${invoice.projectName}\nDue: ${invoice.dueDate.toString().split(' ')[0]}'),
                  isThreeLine: true,
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('\$${invoice.amount}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      StatusBadge(status: invoice.status),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/invoices/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
