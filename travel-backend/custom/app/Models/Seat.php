<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Seat extends Model
{
    protected $fillable = [
        'vol_id', 'numero', 'rangee', 'colonne', 'classe',
        'statut', 'reservation_id', 'bloque_jusqu_a',
    ];

    protected function casts(): array
    {
        return [
            'bloque_jusqu_a' => 'datetime',
            'rangee'         => 'integer',
        ];
    }

    public function vol(): BelongsTo
    {
        return $this->belongsTo(Vol::class);
    }

    public function reservation(): BelongsTo
    {
        return $this->belongsTo(Reservation::class);
    }

    public function passenger(): \Illuminate\Database\Eloquent\Relations\HasOne
    {
        return $this->hasOne(Passenger::class);
    }

    /**
     * Un siège est disponible si :
     *  - son statut est 'disponible', OU
     *  - son statut est 'bloque' MAIS le verrou a expiré.
     */
    public function isDisponible(): bool
    {
        if ($this->statut === 'reserve') {
            return false;
        }
        if ($this->statut === 'bloque' && $this->bloque_jusqu_a?->isFuture()) {
            return false;
        }
        return true;
    }
}