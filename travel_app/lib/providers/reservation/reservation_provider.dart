import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voyageur/data/datasources/remote/reservation_remote_datasource.dart';
import 'package:voyageur/data/repositories/reservation_repository.dart';
import 'package:voyageur/domain/entities/reservation_entity.dart';
import 'package:voyageur/domain/usecases/reservation/create_reservation_usecase.dart';
import 'package:voyageur/domain/usecases/reservation/get_reservations_usecase.dart';
import 'package:voyageur/providers/auth/auth_provider.dart';

final reservationRepositoryProvider = Provider<ReservationRepository>((ref) {
  return ReservationRepository(
    remoteDatasource: ReservationRemoteDatasource(
      apiClient: ref.watch(apiClientProvider),
    ),
  );
});

final createReservationUseCaseProvider =
    Provider<CreateReservationUsecase>((ref) {
  return CreateReservationUsecase(
    repository: ref.watch(reservationRepositoryProvider),
  );
});

final getReservationsUseCaseProvider = Provider<GetReservationsUsecase>((ref) {
  return GetReservationsUsecase(
    repository: ref.watch(reservationRepositoryProvider),
  );
});

final reservationsProvider =
    AsyncNotifierProvider<ReservationsNotifier, List<ReservationEntity>>(
        ReservationsNotifier.new);

class ReservationsNotifier extends AsyncNotifier<List<ReservationEntity>> {
  @override
  Future<List<ReservationEntity>> build() async {
    final usecase = ref.watch(getReservationsUseCaseProvider);
    final result = await usecase();
    return result.fold((l) => [], (r) => r);
  }

  Future<void> refresh() async {
    final usecase = ref.read(getReservationsUseCaseProvider);
    final result = await usecase();
    result.fold(
      (l) => state = AsyncError(l, StackTrace.current),
      (r) => state = AsyncData(r),
    );
  }

  Future<bool> create(Map<String, dynamic> data) async {
    final usecase = ref.read(createReservationUseCaseProvider);
    final result = await usecase(data);
    return result.fold(
      (l) => false,
      (r) {
        refresh();
        return true;
      },
    );
  }

  Future<bool> cancel(int id) async {
    final repo = ref.read(reservationRepositoryProvider);
    final result = await repo.cancelReservation(id);
    return result.fold(
      (l) => false,
      (_) {
        refresh();
        return true;
      },
    );
  }
}
