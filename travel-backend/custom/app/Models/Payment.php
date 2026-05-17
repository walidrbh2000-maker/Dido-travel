<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    protected $fillable = [
        'reservation_id', 'montant', 'methode',
        'stripe_payment_id', 'statut',
    ];

    protected function casts(): array
    {
        return ['montant' => 'decimal:2'];
    }

    public function reservation() { return $this->belongsTo(Reservation::class); }
    public function isSuccessful(): bool { return $this->statut === 'succeeded'; }
}
