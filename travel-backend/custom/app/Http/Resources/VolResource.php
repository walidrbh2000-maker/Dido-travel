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
            'destination'        => [
                'id'      => $this->whenLoaded('destination')?->id,
                'name'    => $this->whenLoaded('destination')?->name,
                'country' => $this->whenLoaded('destination')?->country,
            ],
            'date_depart'        => $this->date_depart?->toIso8601String(),
            'date_arrivee'       => $this->date_arrivee?->toIso8601String(),
            'prix'               => (float) $this->prix,
            'places_disponibles' => $this->places_disponibles,
            'classe'             => $this->classe,
            'statut'             => $this->statut,
        ];
    }
}
