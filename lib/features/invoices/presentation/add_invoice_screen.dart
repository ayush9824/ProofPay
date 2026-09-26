import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../clients/presentation/providers/client_provider.dart';
import '../../../core/models/client.dart';
import 'providers/invoice_provider.dart';
import 'package:intl/intl.dart';

class AddInvoiceScreen extends ConsumerStatefulWidget {
  const AddInvoiceScreen({super.key});

  @override
  ConsumerState<AddInvoiceScreen> createState() => _AddInvoiceScreenState();
}

class _AddInvoiceScreenState extends ConsumerState<AddInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _projectController = TextEditingController();
  final _amountController = TextEditingController();
  
  Client? _selectedClient;
  DateTime _invoiceDate = DateTime.now();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 14));
  bool _isLoading = false;

  @override
  void dispose() {
    _projectController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedClient == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a client')));
      return;
    }
    
    if (_dueDate.isBefore(_invoiceDate)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Due date cannot be before invoice date')));
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      await ref.read(invoiceRepositoryProvider).addInvoice({
        'client_id': _selectedClient!.id,
        'invoice_number': 'INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}', // basic generator
        'project_name': _projectController.text.trim(),
        'amount': double.parse(_amountController.text.trim()),
        'invoice_date': _invoiceDate.toIso8601String().split('T')[0],
        'due_date': _dueDate.toIso8601String().split('T')[0],
        'currency': 'USD',
        'status': 'draft',
      });
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final clientsAsync = ref.watch(clientsStreamProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Create Invoice')),
      body: clientsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (clients) {
          if (clients.isEmpty) {
            return const Center(child: Text('Please add a client first.'));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<Client>(
                    decoration: const InputDecoration(labelText: 'Client *'),
                    initialValue: _selectedClient,
                    items: clients.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                    onChanged: (val) => setState(() => _selectedClient = val),
                    validator: (val) => val == null ? 'Client is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _projectController,
                    decoration: const InputDecoration(labelText: 'Project Name *'),
                    validator: (val) => val == null || val.isEmpty ? 'Project is required' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(labelText: 'Amount *'),
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val == null || val.isEmpty) return 'Amount is required';
                      final num = double.tryParse(val);
                      if (num == null || num <= 0) return 'Must be > 0';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    title: const Text('Invoice Date'),
                    subtitle: Text(DateFormat.yMMMd().format(_invoiceDate)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(context: context, initialDate: _invoiceDate, firstDate: DateTime(2020), lastDate: DateTime(2101));
                      if (picked != null) setState(() => _invoiceDate = picked);
                    },
                  ),
                  ListTile(
                    title: const Text('Due Date'),
                    subtitle: Text(DateFormat.yMMMd().format(_dueDate)),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(context: context, initialDate: _dueDate, firstDate: DateTime(2020), lastDate: DateTime(2101));
                      if (picked != null) setState(() => _dueDate = picked);
                    },
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading ? const CircularProgressIndicator() : const Text('Save Invoice'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
