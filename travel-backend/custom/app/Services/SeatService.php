<?php

namespace App\Services;

use App\Models\{Seat, Vol, Reservation};
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

class SeatService
{
    /**
     * Layout avion : [rangeeDebut, rangeeFin, colonnes]
     */
    private const LAYOUT = [
        'premiere'   => ['debut' => 1,  'fin' => 3,  'colonnes' => ['A', 'B']],
        'affaires'   => ['debut' => 4,  'fin' => 9,  'colonnes' => ['A', 'B', 'C', 'D']],
        'economique' => ['debut' => 10, 'fin' => 40, 'colonnes' => ['A', 'B', 'C', 'D', 'E', 'F']],
    ];

    /**
     * Génère tous les sièges d'un vol si absents (idempotent).
     */
    public function genererSiegesPourVol(Vol $vol): void
    {
        if (Seat::where('vol_id', $vol->id)->exists()) {
            return;
        }

        $rows = [];
        $now  = now()->format('Y-m-d H:i:s');

        foreach (self::LAYOUT as $classe => $config) {
            for ($rangee = $config['debut']; $rangee <= $config['fin']; $rangee++) {
                foreach ($config['colonnes'] as $colonne) {
                    $rows[] = [
                        'vol_id'     => $vol->id,
                        'numero'     => $rangee . $colonne,
                        'rangee'     => $rangee,
                        'colonne'    => $colonne,
                        'classe'     => $classe,
                        'statut'     => 'disponible',
                        'created_at' => $now,
                        'updated_at' => $now,
                    ];
                }
            }
        }

        foreach (array_chunk($rows, 500) as $chunk) {
            Seat::insert($chunk);
        }
    }

    /**
     * Retourne la carte des sièges groupée par classe → rangée.
     * Libère automatiquement les verrous expirés.
     */
    public function getCarteSieges(int $volId): Collection
    {
        // Nettoyer les verrous expirés
        Seat::where('vol_id', $volId)
            ->where('statut', 'bloque')
            ->where('bloque_jusqu_a', '<', now())
            ->update([
                'statut'         => 'disponible',
                'bloque_jusqu_a' => null,
                'reservation_id' => null,
            ]);

        return Seat::where('vol_id', $volId)
            ->orderBy('rangee')
            ->orderBy('colonne')
            ->get();
    }

    /**
     * Bloque un siège de façon atomique pendant 10 minutes.
     * Lève \RuntimeException si le siège n'est plus disponible (race condition).
     */
    public function bloquerSiege(int $siegeId): Seat
    {
        return DB::transaction(function () use ($siegeId) {
            /** @var Seat $siege */
            $siege = Seat::lockForUpdate()->findOrFail($siegeId);

            if (! $siege->isDisponible()) {
                throw new \RuntimeException('Ce siège n\'est plus disponible.');
            }

            $siege->update([
                'statut'         => 'bloque',
                'bloque_jusqu_a' => now()->addMinutes(10),
            ]);

            return $siege->fresh();
        });
    }

    /**
     * Libère un verrou temporaire.
     */
    public function libererSiege(int $siegeId): void
    {
        DB::transaction(function () use ($siegeId) {
            $siege = Seat::lockForUpdate()->find($siegeId);

            if ($siege && $siege->statut === 'bloque') {
                $siege->update([
                    'statut'         => 'disponible',
                    'bloque_jusqu_a' => null,
                    'reservation_id' => null,
                ]);
            }
        });
    }

    /**
     * Confirme définitivement un siège lors de la création de réservation.
     */
    public function confirmerReservation(int $siegeId, int $reservationId): Seat
    {
        return DB::transaction(function () use ($siegeId, $reservationId) {
            $siege = Seat::lockForUpdate()->findOrFail($siegeId);

            if ($siege->statut === 'reserve' && $siege->reservation_id !== $reservationId) {
                throw new \RuntimeException('Ce siège est déjà réservé par quelqu\'un d\'autre.');
            }

            $siege->update([
                'statut'         => 'reserve',
                'reservation_id' => $reservationId,
                'bloque_jusqu_a' => null,
            ]);

            return $siege->fresh();
        });
    }
}