import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyageur/data/datasources/remote/hotel_remote_datasource.dart';
import 'package:voyageur/data/repositories/hotel_repository.dart';
import 'package:voyageur/domain/entities/hotel_entity.dart';
import 'package:voyageur/domain/usecases/hotel/search_hotels_usecase.dart';
import 'package:voyageur/domain/usecases/hotel/get_hotel_details_usecase.dart';
import 'package:voyageur/providers/auth/auth_provider.dart';

final hotelRepositoryProvider = Provider<HotelRepository>((ref) {
  return HotelRepository(
    remoteDatasource: HotelRemoteDatasource(
      apiClient: ref.watch(apiClientProvider),
    ),
  );
});

final searchHotelsUseCaseProvider = Provider<SearchHotelsUsecase>((ref) {
  return SearchHotelsUsecase(repository: ref.watch(hotelRepositoryProvider));
});

final getHotelDetailsUseCaseProvider = Provider<GetHotelDetailsUsecase>((ref) {
  return GetHotelDetailsUsecase(repository: ref.watch(hotelRepositoryProvider));
});

final hotelsProvider =
    AsyncNotifierProvider<HotelsNotifier, List<HotelEntity>>(HotelsNotifier.new);

class HotelsNotifier extends AsyncNotifier<List<HotelEntity>> {
  @override
  Future<List<HotelEntity>> build() async {
    final usecase = ref.watch(searchHotelsUseCaseProvider);
    final result = await usecase();
    return result.fold((l) => [], (r) => r);
  }

  Future<void> search({Map<String, dynamic>? filters}) async {
    state = const AsyncLoading();
    final usecase = ref.read(searchHotelsUseCaseProvider);
    final result = await usecase(filters: filters);
    result.fold(
      (l) => state = AsyncError(l, StackTrace.current),
      (r) => state = AsyncData(r),
    );
  }
}

final hotelDetailProvider =
    FutureProvider.family<HotelEntity, int>((ref, id) async {
  final usecase = ref.watch(getHotelDetailsUseCaseProvider);
  final result = await usecase(id);
  return result.fold(
    (l) => throw Exception(l),
    (r) => r,
  );
});
