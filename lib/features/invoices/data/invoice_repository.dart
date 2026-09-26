import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/invoice.dart';

class InvoiceRepository {
  final SupabaseClient _client;
  InvoiceRepository(this._client);

  Stream<List<Invoice>> watchInvoices() {
    return _client
        .from('invoices')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => Invoice.fromJson(json)).toList());
  }
  
  Future<List<Invoice>> getInvoicesWithClients() async {
    final res = await _client.from('invoices').select('*, clients(*)').order('created_at', ascending: false);
    return res.map((json) => Invoice.fromJson(json)).toList();
  }
  
  Stream<List<Invoice>> watchInvoicesWithClients() {
     // Stream does not support joins natively in Supabase right now without a view or rpc.
     // To get real-time joins, we can either use a view, or listen to changes and re-fetch.
     // For simplicity and immediate consistency, we'll expose a FutureProvider, or fetch on stream event.
     // We will return an empty stream here, and handle it via Riverpod provider that re-fetches.
     throw UnimplementedError('Handled via Riverpod combined providers');
  }

  Future<void> addInvoice(Map<String, dynamic> invoiceData) async {
    final userId = _client.auth.currentUser!.id;
    invoiceData['user_id'] = userId;
    await _client.from('invoices').insert(invoiceData);
  }

  Future<void> updateInvoice(String id, Map<String, dynamic> invoiceData) async {
    await _client.from('invoices').update(invoiceData).eq('id', id);
  }

  Future<void> deleteInvoice(String id) async {
    await _client.from('invoices').delete().eq('id', id);
  }
}
