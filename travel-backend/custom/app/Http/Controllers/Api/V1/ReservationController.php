<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreReservationRequest;
use App\Services\ReservationService;
use App\Services\TicketService;
use App\Models\Reservation;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ReservationController extends Controller
{
    public function __construct(
        private ReservationService $reservationService,
        private TicketService $ticketService
    ) {}

    public function index(Request $request): JsonResponse
    {
        $reservations = Reservation::with(['vol.destination', 'hotel'])
            ->where('user_id', auth()->id())
            ->orderBy('created_at', 'desc')
            ->paginate($request->integer('per_page', 15));

        return response()->json($reservations);
    }

    public function store(StoreReservationRequest $request): JsonResponse
    {
        $reservation = $this->reservationService->createReservation(
            auth()->user(),
            $request->validated()
        );

        return response()->json([
            'message'     => 'Réservation créée avec succès',
            'reservation' => $reservation->load(['vol.destination', 'hotel']),
        ], 201);
    }

    public function show(Reservation $reservation): JsonResponse
    {
        $this->authorizeReservation($reservation);

        return response()->json(
            $reservation->load(['vol.destination', 'hotel', 'payments'])
        );
    }

    public function update(StoreReservationRequest $request, Reservation $reservation): JsonResponse
    {
        $this->authorizeReservation($reservation);

        $reservation = $this->reservationService->updateReservation(
            $reservation, $request->validated()
        );

        return response()->json([
            'message'     => 'Réservation mise à jour',
            'reservation' => $reservation->load(['vol.destination', 'hotel']),
        ]);
    }

    public function destroy(Reservation $reservation): JsonResponse
    {
        $this->authorizeReservation($reservation);
        $this->reservationService->cancelReservation($reservation);

        return response()->json(['message' => 'Réservation annulée']);
    }

    public function ticket(Reservation $reservation)
    {
        $this->authorizeReservation($reservation);

        return $this->ticketService->generatePdf($reservation);
    }

    private function authorizeReservation(Reservation $reservation): void
    {
        if ($reservation->user_id !== auth()->id() && !auth()->user()->isAdmin()) {
            abort(403, 'Accès non autorisé');
        }
    }
}
