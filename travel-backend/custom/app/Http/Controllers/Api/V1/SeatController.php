<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\{Vol, Seat};
use App\Services\SeatService;
use Illuminate\Http\JsonResponse;

class SeatController extends Controller
{
    public function __construct(
        private readonly SeatService $seatService
    ) {}

    /**
     * GET /vols/{vol}/seats
     * Carte des sièges (public). Génère automatiquement les sièges si absents.
     */
    public function index(Vol $vol): JsonResponse
    {
        $this->seatService->genererSiegesPourVol($vol);

        $sieges = $this->seatService->getCarteSieges($vol->id);

        $grouped = $sieges
            ->groupBy('classe')
            ->map(fn($classeSeats) =>
                $classeSeats
                    ->groupBy('rangee')
                    ->map(fn($row) => $row->values())
            );

        return response()->json([
            'vol_id'      => $vol->id,
            'total'       => $sieges->count(),
            'disponibles' => $sieges->where('statut', 'disponible')->count(),
            'sieges'      => $grouped,
        ]);
    }

    /**
     * POST /vols/{vol}/seats/{seat}/lock
     * Bloque un siège pendant 10 minutes (authentifié).
     */
    public function lock(Vol $vol, Seat $seat): JsonResponse
    {
        abort_if($seat->vol_id !== $vol->id, 422, 'Ce siège n\'appartient pas à ce vol.');

        try {
            $siege = $this->seatService->bloquerSiege($seat->id);

            return response()->json([
                'message'   => 'Siège bloqué pendant 10 minutes',
                'siege'     => $siege,
                'expire_at' => $siege->bloque_jusqu_a->toIso8601String(),
            ]);
        } catch (\RuntimeException $e) {
            return response()->json(['message' => $e->getMessage()], 409);
        }
    }

    /**
     * DELETE /vols/{vol}/seats/{seat}/lock
     * Libère un verrou temporaire.
     */
    public function unlock(Vol $vol, Seat $seat): JsonResponse
    {
        abort_if($seat->vol_id !== $vol->id, 422, 'Ce siège n\'appartient pas à ce vol.');

        $this->seatService->libererSiege($seat->id);

        return response()->json(['message' => 'Siège libéré']);
    }
}