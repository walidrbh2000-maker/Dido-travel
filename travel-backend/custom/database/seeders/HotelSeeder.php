<?php

namespace Database\Seeders;

use App\Models\Destination;
use App\Models\Hotel;
use Illuminate\Database\Seeder;

class HotelSeeder extends Seeder
{
    private const CHAINS = [
        'Grand Hôtel', 'Le Royal', 'Ibis', 'Novotel', 'Sofitel',
        'Sheraton', 'Hilton', 'Mercure', 'Best Western', 'Radisson',
        'Marriott', 'Hyatt',
    ];

    private const AMENITY_SETS = [
        'WiFi,Parking,Restaurant,Climatisation,Réception 24h',
        'WiFi,Piscine,Spa,Restaurant,Bar,Room service',
        'WiFi,Parking,Salle de sport,Restaurant,Climatisation',
        'WiFi,Piscine,Restaurant,Room service,Bar,Parking',
        'WiFi,Parking,Spa,Piscine,Restaurant,Salle de sport,Bar',
        'WiFi,Restaurant,Climatisation,Réception 24h,Parking',
        'WiFi,Piscine,Restaurant,Spa,Bar,Climatisation',
    ];

    /**
     * Prix de base par nuit en DZD, par pays : [min, max].
     * Un multiplicateur est appliqué selon le nombre d'étoiles.
     */
    private const PRICE_TIERS = [
        'Algérie'             => [3_500,   8_000],
        'Tunisie'             => [8_000,  18_000],
        'Maroc'               => [8_000,  20_000],
        'Égypte'              => [9_000,  22_000],
        'Turquie'             => [12_000, 30_000],
        'France'              => [15_000, 45_000],
        'Espagne'             => [14_000, 40_000],
        'Italie'              => [15_000, 42_000],
        'Royaume-Uni'         => [18_000, 55_000],
        'Émirats arabes unis' => [20_000, 70_000],
        'États-Unis'          => [22_000, 75_000],
    ];

    private const STREETS = [
        'Rue Didouche Mourad',  'Avenue de l\'Indépendance',
        'Boulevard Mohamed V',  'Rue Larbi Ben M\'hidi',
        'Avenue du 1er Novembre', 'Rue des Frères Bouadou',
        'Boulevard Amirouche',  'Avenue de la Révolution',
        'Rue Ben Mhidi',        'Place de la République',
    ];

    public function run(): void
    {
        if (Hotel::count() > 0) {
            $this->command->warn('⚠️  Hôtels déjà présents — HotelSeeder ignoré.');
            return;
        }

        $destinations = Destination::all();
        $inserted     = 0;

        foreach ($destinations as $destination) {
            $isAlgerian = $destination->country === 'Algérie';
            $count      = $isAlgerian ? random_int(3, 5) : random_int(2, 3);
            $usedChains = [];

            for ($i = 0; $i < $count; $i++) {
                $chain       = $this->pickChain($usedChains);
                $usedChains[] = $chain;

                $stars      = random_int(3, 5);
                [$min, $max] = self::PRICE_TIERS[$destination->country] ?? [10_000, 30_000];

                $basePrix = random_int($min, $max);
                $prix     = round(match ($stars) {
                    5 => $basePrix * 2.0,
                    4 => $basePrix * 1.4,
                    default => (float) $basePrix,
                }, 2);

                Hotel::create([
                    'nom'            => "{$chain} {$destination->name}",
                    'destination_id' => $destination->id,
                    'etoiles'        => $stars,
                    'prix_nuit'      => $prix,
                    'adresse'        => $this->generateAddress($destination->name, $i),
                    'description'    => $this->generateDescription($destination->name, $stars, $chain),
                    'amenities'      => self::AMENITY_SETS[array_rand(self::AMENITY_SETS)],
                    'note'           => round(random_int(65, 95) / 10, 1),  // /10
                    'nb_avis'        => random_int(40, 600),
                    'image'          => null,   // URL construite côté Flutter via ImageMapper
                    'disponible'     => true,
                ]);

                $inserted++;
            }
        }

        $this->command->info("✅  {$inserted} hôtels générés avec succès.");
    }

    // ─────────────────────────────────────────────────────────────────

    /** Sélectionne une chaîne non encore utilisée pour cette destination. */
    private function pickChain(array $used): string
    {
        $available = array_values(array_diff(self::CHAINS, $used));
        if (empty($available)) {
            return self::CHAINS[array_rand(self::CHAINS)];
        }
        return $available[array_rand($available)];
    }

    private function generateAddress(string $city, int $index): string
    {
        $num    = ($index + 1) * 12 + random_int(1, 9);
        $street = self::STREETS[$index % count(self::STREETS)];
        return "{$num} {$street}, {$city}";
    }

    private function generateDescription(string $city, int $stars, string $chain): string
    {
        $quality = match ($stars) {
            5 => 'luxueux 5 étoiles',
            4 => 'confortable 4 étoiles',
            default => 'accueillant 3 étoiles',
        };
        return "{$chain} {$city} est un établissement {$quality} idéalement situé "
             . 'au cœur de la ville, proposant des chambres modernes et un service '
             . 'irréprochable pour les voyageurs d\'affaires et de loisirs.';
    }
}