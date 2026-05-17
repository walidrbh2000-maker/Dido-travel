<?php

namespace Database\Factories;

use App\Models\Destination;
use Illuminate\Database\Eloquent\Factories\Factory;

class HotelFactory extends Factory
{
    public function definition(): array
    {
        return [
            'nom'            => fake()->company() . ' Hotel',
            'destination_id' => Destination::inRandomOrder()->first()?->id
                                ?? Destination::factory(),
            'etoiles'        => fake()->numberBetween(2, 5),
            'prix_nuit'      => fake()->randomFloat(2, 50, 800),
            'adresse'        => fake()->address(),
            'description'    => fake()->paragraph(),
            'image'          => null,
            'disponible'     => true,
        ];
    }
}
