<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // ── Compte admin — idempotent (safe même après migrate:fresh) ──
        User::firstOrCreate(
            ['email' => 'admin@travelapp.com'],
            [
                'name'     => 'Admin',
                'password' => Hash::make('password'),
                'role'     => 'admin',
            ]
        );

        // ── Données de référence puis données générées ──────────────────
        // Chaque seeder vérifie lui-même si les tables sont déjà remplies.
        $this->call([
            DestinationSeeder::class,   // 1. villes (référence)
            VolSeeder::class,            // 2. 60 jours de vols (dépend des destinations)
            HotelSeeder::class,          // 3. hôtels par destination
        ]);
    }
}