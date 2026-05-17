<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Hotel extends Model
{
    use HasFactory;

    protected $fillable = [
        'nom',
        'destination_id',
        'etoiles',
        'prix_nuit',
        'adresse',
        'description',
        'amenities',
        'note',
        'nb_avis',
        'image',
        'disponible',
    ];

    protected function casts(): array
    {
        return [
            'prix_nuit'  => 'decimal:2',
            'note'       => 'decimal:1',
            'disponible' => 'boolean',
        ];
    }

    public function destination()  { return $this->belongsTo(Destination::class); }
    public function reservations() { return $this->hasMany(Reservation::class); }
}