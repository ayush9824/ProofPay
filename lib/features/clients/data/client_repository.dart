import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/models/client.dart';

class ClientRepository {
  final SupabaseClient _client;
  ClientRepository(this._client);

  Stream<List<Client>> watchClients() {
    return _client
        .from('clients')
        .stream(primaryKey: ['id'])
        .order('name', ascending: true)
        .map((data) => data.map((json) => Client.fromJson(json)).toList());
  }

  Future<void> addClient(Map<String, dynamic> clientData) async {
    final userId = _client.auth.currentUser!.id;
    clientData['user_id'] = userId;
    await _client.from('clients').insert(clientData);
  }

  Future<void> updateClient(String id, Map<String, dynamic> clientData) async {
    await _client.from('clients').update(clientData).eq('id', id);
  }

  Future<void> deleteClient(String id) async {
    await _client.from('clients').delete().eq('id', id);
  }
}
