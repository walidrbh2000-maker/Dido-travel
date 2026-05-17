<?php

namespace App\Services;

use App\Models\Reservation;
use Barryvdh\DomPDF\Facade\Pdf;

class TicketService
{
    public function generatePdf(Reservation $reservation)
    {
        $reservation->load(['user', 'vol.destination', 'hotel']);

        $pdf = Pdf::loadView('tickets.reservation', [
            'reservation' => $reservation,
        ]);

        return $pdf->download("ticket-{$reservation->reference}.pdf");
    }

    public function generateHtml(Reservation $reservation): string
    {
        $reservation->load(['user', 'vol.destination', 'hotel']);

        return view('tickets.reservation', [
            'reservation' => $reservation,
        ])->render();
    }
}
