<?php

namespace App\Http\Requests;

use Carbon\Carbon;
use Illuminate\Foundation\Http\FormRequest;

class StoreReservationRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            // Trajet
            'type_trajet'      => 'required|in:aller_simple,aller_retour',
            'vol_id'           => 'required|exists:vols,id',
            'vol_retour_id'    => 'required_if:type_trajet,aller_retour|nullable|exists:vols,id|different:vol_id',

            // Dates
            'date_debut' => 'required|date|after_or_equal:today',
            'date_fin'   => 'required|date|after:date_debut',

            // Optionnels
            'hotel_id' => 'nullable|exists:hotels,id',
            'guide_id' => 'nullable|exists:guides,id',

            // Passagers (1–6)
            'passengers'                          => 'required|array|min:1|max:6',
            'passengers.*.prenom'                 => 'required|string|max:100',
            'passengers.*.nom'                    => 'required|string|max:100',
            'passengers.*.date_naissance'         => 'required|date|before:today',
            'passengers.*.genre'                  => 'required|in:homme,femme',
            'passengers.*.numero_passeport'       => 'nullable|string|max:20',
            'passengers.*.nationalite'            => 'nullable|string|size:2',
            'passengers.*.seat_id'                => 'nullable|exists:seats,id',
            'passengers.*.seat_retour_id'         => 'nullable|exists:seats,id',
            'passengers.*.est_contact_principal'  => 'boolean',
        ];
    }

    /**
     * Validation métier :
     *  1. Au moins 1 adulte (≥ 12 ans).
     *  2. Un mineur seul (12-17 ans) ne peut pas voyager sans adulte.
     *  3. Un bébé (< 2 ans) ne peut pas avoir de siège propre.
     *  4. Maximum 6 passagers.
     *  5. Nombre de bébés ≤ nombre d'adultes.
     */
    public function withValidator($validator): void
    {
        $validator->after(function ($v) {
            $passengers = collect($this->input('passengers', []));

            $adultes = $passengers->filter(fn($p) =>
                Carbon::parse($p['date_naissance'])->diffInYears(now()) >= 12
            );
            $mineurs = $passengers->filter(fn($p) => {
                $age = Carbon::parse($p['date_naissance'])->diffInYears(now());
                return $age >= 12 && $age < 18;
            });
            $bebes   = $passengers->filter(fn($p) =>
                Carbon::parse($p['date_naissance'])->diffInYears(now()) < 2
            );

            if ($adultes->isEmpty()) {
                $v->errors()->add('passengers', 'Au moins un passager adulte (≥ 12 ans) est requis.');
            }

            if ($adultes->count() === 0 && $mineurs->count() > 0) {
                $v->errors()->add('passengers', 'Un mineur ne peut pas voyager sans adulte.');
            }

            if ($bebes->count() > $adultes->count()) {
                $v->errors()->add('passengers', 'Chaque bébé doit être accompagné d\'un adulte.');
            }

            // Vérifier qu'aucun bébé n'a un siège réservé
            foreach ($bebes as $bebe) {
                if (!empty($bebe['seat_id'])) {
                    $v->errors()->add('passengers', 'Les bébés (< 2 ans) n\'ont pas droit à un siège individuel.');
                }
            }
        });
    }

    public function messages(): array
    {
        return [
            'vol_id.required'           => 'Le vol est obligatoire',
            'vol_id.exists'             => "Le vol sélectionné n'existe pas",
            'vol_retour_id.required_if' => 'Le vol retour est obligatoire pour un aller-retour',
            'date_debut.required'       => 'La date de début est obligatoire',
            'date_debut.after_or_equal' => "La date doit être aujourd'hui ou ultérieure",
            'date_fin.required'         => 'La date de fin est obligatoire',
            'date_fin.after'            => 'La date de fin doit être après le début',
            'passengers.required'       => 'Au moins un passager est requis',
            'passengers.max'            => 'Maximum 6 passagers par réservation',
        ];
    }
}