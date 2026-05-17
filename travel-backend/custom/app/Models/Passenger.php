<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Passenger extends Model
{
    protected $fillable = [
        'reservation_id', 'seat_id', 'seat_retour_id',
        'prenom', 'nom', 'date_naissance', 'type_passager',
        'numero_passeport', 'nationalite', 'genre', 'est_contact_principal',
    ];

    protected function casts(): array
    {
        return [
            'date_naissance'        => 'date',
            'est_contact_principal' => 'boolean',
        ];
    }

    public function reservation(): BelongsTo
    {
        return $this->belongsTo(Reservation::class);
    }

    public function seat(): BelongsTo
    {
        return $this->belongsTo(Seat::class);
    }

    public function seatRetour(): BelongsTo
    {
        return $this->belongsTo(Seat::class, 'seat_retour_id');
    }

    /**
     * Détermine automatiquement le type du passager selon son âge
     * à la date du vol (ou aujourd'hui par défaut).
     */
    public static function determinerType(Carbon $dateNaissance, ?Carbon $dateVol = null): string
    {
        $age = $dateNaissance->diffInYears($dateVol ?? now());

        if ($age < 2)  return 'bebe';
        if ($age < 12) return 'enfant';
        return 'adulte';
    }
}