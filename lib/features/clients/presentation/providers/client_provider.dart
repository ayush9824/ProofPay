import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/supabase_config.dart';
import '../../../../core/models/client.dart';
import '../../data/client_repository.dart';

final clientRepositoryProvider = Provider<ClientRepository>((ref) {
  return ClientRepository(SupabaseConfig.client);
});

final clientsStreamProvider = StreamProvider<List<Client>>((ref) {
  final repo = ref.watch(clientRepositoryProvider);
  return repo.watchClients();
});
