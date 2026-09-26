import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/widgets/empty_state.dart';
import 'providers/client_provider.dart';

class ClientsScreen extends ConsumerWidget {
  const ClientsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsAsync = ref.watch(clientsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Clients')),
      body: clientsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (clients) {
          if (clients.isEmpty) {
            return EmptyState(
              title: 'No clients yet',
              message: 'Add your first client to start creating invoices.',
              icon: Icons.people_outline,
              actionLabel: 'Add Client',
              onAction: () => context.go('/clients/add'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: clients.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final client = clients[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    child: Text(client.name[0].toUpperCase(), style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                  ),
                  title: Text(client.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(client.email ?? client.phone ?? 'No contact info'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () {
                      ref.read(clientRepositoryProvider).deleteClient(client.id);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/clients/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
