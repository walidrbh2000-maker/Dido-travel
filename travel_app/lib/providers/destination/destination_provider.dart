import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyageur/data/models/destination_model.dart';
import 'package:voyageur/data/repositories/destination_repository.dart';
import 'package:voyageur/providers/auth/auth_provider.dart';

final destinationRepositoryProvider = Provider<DestinationRepository>((ref) {
  return DestinationRepository(apiClient: ref.watch(apiClientProvider));
});

final destinationsProvider =
    AsyncNotifierProvider<DestinationsNotifier, List<DestinationModel>>(() {
  return DestinationsNotifier();
});

class DestinationsNotifier extends AsyncNotifier<List<DestinationModel>> {
  @override
  Future<List<DestinationModel>> build() async {
    final repo = ref.watch(destinationRepositoryProvider);
    final result = await repo.getDestinations();
    return result.fold((l) => throw Exception(l), (r) => r);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final repo = ref.read(destinationRepositoryProvider);
    final result = await repo.getDestinations();
    result.fold(
      (l) => state = AsyncError(l, StackTrace.current),
      (r) => state = AsyncData(r),
    );
  }
}

final destinationDetailProvider =
    FutureProvider.family<DestinationModel, int>((ref, id) async {
  final repo = ref.watch(destinationRepositoryProvider);
  final result = await repo.getDestinationDetail(id);
  return result.fold(
    (l) => throw Exception(l),
    (r) => r,
  );
});
