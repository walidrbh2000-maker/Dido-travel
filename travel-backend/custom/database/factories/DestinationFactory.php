<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;

class DestinationFactory extends Factory
{
    public function definition(): array
    {
        $data = fake()->randomElement([
            ['Paris',     'France'],
            ['Rome',      'Italie'],
            ['Barcelone', 'Espagne'],
            ['Istanbul',  'Turquie'],
            ['Dubaï',     'Émirats'],
            ['Tokyo',     'Japon'],
            ['New York',  'États-Unis'],
            ['Marrakech', 'Maroc'],
            ['Bangkok',   'Thaïlande'],
            ['Lisbonne',  'Portugal'],
        ]);

        return [
            'name'        => $data[0],
            'country'     => $data[1],
            'description' => fake()->paragraph(),
            'image'       => null,
            'is_popular'  => fake()->boolean(40),
        ];
    }
}
