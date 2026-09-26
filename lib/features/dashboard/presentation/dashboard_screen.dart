import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/models/invoice.dart';
import '../../invoices/presentation/providers/invoice_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(invoicesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: invoicesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (invoices) {
          final outstanding = invoices.where((i) => i.status != InvoiceStatus.paid).fold(0.0, (sum, i) => sum + i.amount);
          final dueSoon = invoices.where((i) => i.status == InvoiceStatus.dueSoon).fold(0.0, (sum, i) => sum + i.amount);
          final overdue = invoices.where((i) => i.status == InvoiceStatus.overdue).fold(0.0, (sum, i) => sum + i.amount);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: _StatCard(title: 'Outstanding', amount: '\$${outstanding.toStringAsFixed(2)}', color: Colors.orange)),
                    const SizedBox(width: 16),
                    Expanded(child: _StatCard(title: 'Due Soon', amount: '\$${dueSoon.toStringAsFixed(2)}', color: Colors.amber)),
                  ],
                ),
                const SizedBox(height: 16),
                _StatCard(title: 'Overdue', amount: '\$${overdue.toStringAsFixed(2)}', color: Colors.red),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Recent Invoices', style: Theme.of(context).textTheme.titleLarge),
                    TextButton(onPressed: () => context.go('/invoices'), child: const Text('View All')),
                  ],
                ),
                const SizedBox(height: 8),
                if (invoices.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Center(child: Text('No invoices yet.')),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: invoices.take(3).length,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final invoice = invoices[index];
                      return Card(
                        child: ListTile(
                          onTap: () => context.go('/invoices/${invoice.id}'),
                          title: Text(invoice.client?.name ?? 'Unknown', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Due: ${invoice.dueDate.toString().split(' ')[0]}'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('\$${invoice.amount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 4),
                              StatusBadge(status: invoice.status),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        }
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String amount;
  final Color color;

  const _StatCard({required this.title, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(amount, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color, fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
