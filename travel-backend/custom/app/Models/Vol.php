<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Vol extends Model
{
    use HasFactory;

    protected $fillable = [
        'compagnie', 'numero_vol', 'destination_id',
        'date_depart', 'date_arrivee', 'prix',
        'places_disponibles', 'classe', 'statut',
    ];

    protected function casts(): array
    {
        return [
            'date_depart'  => 'datetime',
            'date_arrivee' => 'datetime',
            'prix'         => 'decimal:2',
        ];
    }

    public function destination()  { return $this->belongsTo(Destination::class); }
    public function reservations() { return $this->hasMany(Reservation::class); }

    public function decrementSeats(int $count = 1): bool
    {
        return $this->decrement('places_disponibles', $count);
    }
}
