<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class HotelResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'             => $this->id,
            'nom'            => $this->nom,
            'destination_id' => $this->destination_id,
            'destination'    => $this->whenLoaded('destination', fn ($d) => [
                'id'      => $d->id,
                'name'    => $d->name,
                'country' => $d->country,
            ]),
            'etoiles'     => (int) $this->etoiles,
            'prix_nuit'   => (float) $this->prix_nuit,   // FIX: decimal:2 → float
            'adresse'     => $this->adresse,
            'description' => $this->description,
            'image'       => $this->image,
            'amenities'   => $this->amenities,
            'note'        => $this->note !== null ? (float) $this->note : null,
            'nb_avis'     => (int) ($this->nb_avis ?? 0),
            'disponible'  => (bool) $this->disponible,
        ];
    }
}