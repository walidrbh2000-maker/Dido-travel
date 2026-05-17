<?php

namespace App\Services;

use App\Models\{Payment, Reservation};
use Illuminate\Support\Facades\DB;
use Stripe\Charge;
use Stripe\Stripe;

class PaymentService
{
    public function __construct()
    {
        Stripe::setApiKey(config('services.stripe.secret'));
    }

    public function processPayment(int $reservationId, string $methode, string $token): Payment
    {
        $reservation = Reservation::findOrFail($reservationId);

        if ($reservation->statut === 'payee') {
            throw new \Exception('Cette réservation est déjà payée');
        }

        return DB::transaction(function () use ($reservation, $methode, $token) {
            try {
                $charge = Charge::create([
                    'amount' => (int) ($reservation->prix_total * 100),
                    'currency' => 'eur',
                    'source' => $token,
                    'description' => "Réservation {$reservation->reference}",
                ]);

                $payment = Payment::create([
                    'reservation_id' => $reservation->id,
                    'montant' => $reservation->prix_total,
                    'methode' => $methode,
                    'stripe_payment_id' => $charge->id,
                    'statut' => 'succeeded',
                ]);

                $reservation->update(['statut' => 'confirmee']);

                return $payment;
            } catch (\Exception $e) {
                Payment::create([
                    'reservation_id' => $reservation->id,
                    'montant' => $reservation->prix_total,
                    'methode' => $methode,
                    'stripe_payment_id' => null,
                    'statut' => 'failed',
                ]);

                throw new \Exception('Le paiement a échoué : ' . $e->getMessage());
            }
        });
    }
}
