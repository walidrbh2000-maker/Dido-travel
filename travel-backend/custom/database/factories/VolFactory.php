<?php

namespace Database\Factories;

use App\Models\Destination;
use Illuminate\Database\Eloquent\Factories\Factory;

class VolFactory extends Factory
{
    public function definition(): array
    {
        $compagnies = ['Air France', 'Royal Air Maroc', 'Emirates', 'Turkish Airlines', 'Lufthansa', 'Air Algérie'];
        $depart     = fake()->dateTimeBetween('+1 week', '+3 months');
        $arrivee    = (clone $depart)->modify('+' . fake()->numberBetween(2, 14) . ' hours');

        return [
            'compagnie'          => fake()->randomElement($compagnies),
            'numero_vol'         => strtoupper(fake()->lexify('??')) . fake()->numerify('####'),
            'destination_id'     => Destination::inRandomOrder()->first()?->id
                                    ?? Destination::factory(),
            'date_depart'        => $depart,
            'date_arrivee'       => $arrivee,
            'prix'               => fake()->randomFloat(2, 150, 2500),
            'places_disponibles' => fake()->numberBetween(20, 250),
            'classe'             => fake()->randomElement(['economique', 'affaires', 'premiere']),
            'statut'             => 'programme',
        ];
    }
}
