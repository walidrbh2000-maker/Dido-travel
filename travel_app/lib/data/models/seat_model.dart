/// Modèle de siège — pas de code généré requis.
class SeatModel {
  final int id;
  final int volId;
  final String numero;
  final int rangee;
  final String colonne;
  final String classe;   // 'economique' | 'affaires' | 'premiere'
  final String statut;   // 'disponible' | 'bloque' | 'reserve'
  final int? reservationId;
  final String? bloqueJusqua;

  const SeatModel({
    required this.id,
    required this.volId,
    required this.numero,
    required this.rangee,
    required this.colonne,
    required this.classe,
    required this.statut,
    this.reservationId,
    this.bloqueJusqua,
  });

  factory SeatModel.fromJson(Map<String, dynamic> json) => SeatModel(
    id:            (json['id'] as num).toInt(),
    volId:         (json['vol_id'] as num).toInt(),
    numero:        json['numero'] as String,
    rangee:        (json['rangee'] as num).toInt(),
    colonne:       json['colonne'] as String,
    classe:        json['classe'] as String,
    statut:        json['statut'] as String,
    reservationId: (json['reservation_id'] as num?)?.toInt(),
    bloqueJusqua:  json['bloque_jusqu_a'] as String?,
  );

  bool get isDisponible => statut == 'disponible';
  bool get isBloque     => statut == 'bloque';
  bool get isReserve    => statut == 'reserve';

  SeatModel copyWith({String? statut}) => SeatModel(
    id: id, volId: volId, numero: numero, rangee: rangee,
    colonne: colonne, classe: classe,
    statut: statut ?? this.statut,
    reservationId: reservationId, bloqueJusqua: bloqueJusqua,
  );
}

/// Réponse complète de la carte des sièges.
class SeatMapResponse {
  final int volId;
  final int total;
  final int disponibles;
  /// classe → rangée → liste de sièges
  final Map<String, Map<int, List<SeatModel>>> sieges;

  const SeatMapResponse({
    required this.volId,
    required this.total,
    required this.disponibles,
    required this.sieges,
  });

  factory SeatMapResponse.fromJson(Map<String, dynamic> json) {
    final rawSieges = json['sieges'] as Map<String, dynamic>;

    final sieges = rawSieges.map((classe, rangees) {
      final rangeMap = (rangees as Map<String, dynamic>).map((rangeeStr, seats) {
        final seatList = (seats as List)
            .map((s) => SeatModel.fromJson(s as Map<String, dynamic>))
            .toList();
        return MapEntry(int.parse(rangeeStr), seatList);
      });
      return MapEntry(classe, rangeMap);
    });

    return SeatMapResponse(
      volId:       (json['vol_id'] as num).toInt(),
      total:       (json['total'] as num).toInt(),
      disponibles: (json['disponibles'] as num).toInt(),
      sieges:      sieges,
    );
  }
}