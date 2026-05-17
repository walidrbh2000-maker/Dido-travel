<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class VolResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'                 => $this->id,
            'compagnie'          => $this->compagnie,
            'numero_vol'         => $this->numero_vol,
            // BUG 5 FIX: always include destination_id as a top-level scalar
            'destination_id'     => $this->destination_id,
            // BUG 5 FIX: omit the key entirely when destination is not loaded
            // instead of sending {"id": null, "name": null, "country": null}
            'destination'        => $this->whenLoaded('destination', fn ($d) => [
                'id'      => $d->id,
                'name'    => $d->name,
                'country' => $d->country,
            ]),
            'date_depart'        => $this->date_depart?->toIso8601String(),
            'date_arrivee'       => $this->date_arrivee?->toIso8601String(),
            'prix'               => (float) $this->prix,
            'places_disponibles' => $this->places_disponibles,
            'classe'             => $this->classe,
            'statut'             => $this->statut,
        ];
    }
}