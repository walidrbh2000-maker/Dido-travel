<?php

namespace Database\Factories;

use App\Models\Destination;
use Illuminate\Database\Eloquent\Factories\Factory;

class GuideFactory extends Factory
{
    public function definition(): array
    {
        return [
            'nom'                => fake()->name(),
            'destination_id'     => Destination::inRandomOrder()->first()?->id
                                    ?? Destination::factory(),
            'langues'            => fake()->randomElements(
                                        ['fr', 'en', 'ar', 'es', 'de', 'it'],
                                        fake()->numberBetween(1, 3)
                                    ),
            'experience_annees'  => fake()->numberBetween(1, 20),
            'tarif_jour'         => fake()->randomFloat(2, 50, 300),
            'description'        => fake()->paragraph(),
            'image'              => null,
            'disponible'         => true,
        ];
    }
}
