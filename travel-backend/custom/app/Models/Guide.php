<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Guide extends Model
{
    use HasFactory;

    protected $fillable = [
        'nom', 'destination_id', 'langues',
        'experience_annees', 'tarif_jour', 'description', 'image', 'disponible',
    ];

    protected function casts(): array
    {
        return [
            'langues'    => 'array',
            'tarif_jour' => 'decimal:2',
            'disponible' => 'boolean',
        ];
    }

    public function destination() { return $this->belongsTo(Destination::class); }
}
