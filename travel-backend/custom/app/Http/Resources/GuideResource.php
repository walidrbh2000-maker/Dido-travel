<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class GuideResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id'                => $this->id,
            'nom'               => $this->nom,
            'destination_id'    => $this->destination_id,
            'destination'       => $this->whenLoaded('destination', fn ($d) => [
                'id'      => $d->id,
                'name'    => $d->name,
                'country' => $d->country,
            ]),
            'langues'           => $this->langues,
            'experience_annees' => (int) $this->experience_annees,
            'tarif_jour'        => (float) $this->tarif_jour,   // FIX: decimal:2 → float
            'description'       => $this->description,
            'image'             => $this->image,
            'disponible'        => (bool) $this->disponible,
        ];
    }
}