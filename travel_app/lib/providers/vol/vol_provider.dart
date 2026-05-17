import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyageur/data/datasources/remote/vol_remote_datasource.dart';
import 'package:voyageur/data/repositories/vol_repository.dart';
import 'package:voyageur/domain/entities/vol_entity.dart';
import 'package:voyageur/domain/usecases/vol/search_vols_usecase.dart';
import 'package:voyageur/domain/usecases/vol/get_vol_details_usecase.dart';
import 'package:voyageur/providers/auth/auth_provider.dart';

final volRepositoryProvider = Provider<VolRepository>((ref) {
  return VolRepository(
    remoteDatasource: VolRemoteDatasource(
      apiClient: ref.watch(apiClientProvider),
    ),
  );
});

final searchVolsUseCaseProvider = Provider<SearchVolsUsecase>((ref) {
  return SearchVolsUsecase(repository: ref.watch(volRepositoryProvider));
});

final getVolDetailsUseCaseProvider = Provider<GetVolDetailsUsecase>((ref) {
  return GetVolDetailsUsecase(repository: ref.watch(volRepositoryProvider));
});

final volsProvider =
    AsyncNotifierProvider<VolsNotifier, List<VolEntity>>(VolsNotifier.new);

class VolsNotifier extends AsyncNotifier<List<VolEntity>> {
  @override
  Future<List<VolEntity>> build() async {
    final usecase = ref.watch(searchVolsUseCaseProvider);
    final result = await usecase();
    return result.fold((l) => [], (r) => r);
  }

  Future<void> search({Map<String, dynamic>? filters}) async {
    state = const AsyncLoading();
    final usecase = ref.read(searchVolsUseCaseProvider);
    final result = await usecase(filters: filters);
    result.fold(
      (l) => state = AsyncError(l, StackTrace.current),
      (r) => state = AsyncData(r),
    );
  }
}

final volDetailProvider =
    FutureProvider.family<VolEntity, int>((ref, id) async {
  final usecase = ref.watch(getVolDetailsUseCaseProvider);
  final result = await usecase(id);
  return result.fold(
    (l) => throw Exception(l),
    (r) => r,
  );
});
