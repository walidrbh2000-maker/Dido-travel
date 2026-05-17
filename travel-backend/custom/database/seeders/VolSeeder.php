<?php

namespace Database\Seeders;

use App\Models\Destination;
use App\Models\Vol;
use Carbon\Carbon;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class VolSeeder extends Seeder
{
    private const TOTAL_DAYS = 60;
    private const CHUNK_SIZE = 500;   // lignes par INSERT batch

    /** Compagnie → préfixe IATA */
    private const AIRLINES = [
        'Air Algérie'      => 'AH',
        'Tassili Airlines' => 'SF',
        'Air France'       => 'AF',
        'Royal Air Maroc'  => 'AT',
        'Emirates'         => 'EK',
        'Turkish Airlines' => 'TK',
        'Lufthansa'        => 'LH',
        'Transavia'        => 'TO',
        'Vueling'          => 'VY',
    ];

    /**
     * Routes domestiques : [destination, duréeH, prixMinDZD, prixMaxDZD, vols/jour]
     * Point de départ implicite : Alger.
     */
    private const DOMESTIC_ROUTES = [
        ['Oran',        1.0, 4_500,  12_000, 3],
        ['Constantine', 1.2, 5_000,  13_000, 3],
        ['Annaba',      1.5, 5_500,  14_000, 2],
        ['Tlemcen',     1.5, 5_000,  13_000, 2],
        ['Béjaïa',      1.0, 4_500,  11_000, 2],
        ['Sétif',       1.0, 4_500,  11_000, 2],
        ['Ghardaïa',    1.5, 6_000,  14_000, 2],
        ['Tamanrasset', 2.5, 9_000,  20_000, 1],
    ];

    /**
     * Routes internationales : [destination, duréeH, prixMinDZD, prixMaxDZD, vols/jour]
     */
    private const INTERNATIONAL_ROUTES = [
        ['Paris',      3.5,  25_000,  65_000, 2],
        ['Marseille',  2.75, 20_000,  55_000, 2],
        ['Lyon',       3.0,  22_000,  58_000, 1],
        ['Londres',    4.0,  35_000,  85_000, 1],
        ['Madrid',     3.5,  28_000,  70_000, 1],
        ['Rome',       3.0,  25_000,  65_000, 1],
        ['Dubaï',      6.5,  45_000, 110_000, 1],
        ['Istanbul',   4.5,  32_000,  78_000, 1],
        ['Le Caire',   3.5,  28_000,  68_000, 1],
        ['Tunis',      1.5,  15_000,  40_000, 2],
        ['Casablanca', 2.5,  18_000,  48_000, 1],
        ['New York',  10.5,  85_000, 180_000, 1],
    ];

    /** Créneaux horaires répartis sur la journée (index = $slotIndex % count) */
    private const DEPARTURE_SLOTS = [
        '06:15', '07:30', '09:00', '10:45',
        '12:30', '14:15', '16:00', '17:45',
        '19:30', '21:00',
    ];

    public function run(): void
    {
        if (Vol::count() > 0) {
            $this->command->warn('⚠️  Vols déjà présents — VolSeeder ignoré.');
            return;
        }

        $this->command->info(sprintf(
            '✈️  Génération des vols pour %d jours (%d routes)…',
            self::TOTAL_DAYS,
            count(self::DOMESTIC_ROUTES) + count(self::INTERNATIONAL_ROUTES)
        ));

        $destinations  = Destination::all()->keyBy('name');
        $allRoutes     = array_merge(self::DOMESTIC_ROUTES, self::INTERNATIONAL_ROUTES);
        $now           = Carbon::now()->startOfDay();
        $chunk         = [];
        $totalInserted = 0;

        for ($day = 0; $day < self::TOTAL_DAYS; $day++) {
            $date = $now->copy()->addDays($day);

            foreach ($allRoutes as $route) {
                $dest = $destinations->get($route[0]);
                if (! $dest) continue; // destination non encore seedée

                for ($f = 0; $f < $route[4]; $f++) {
                    $chunk[] = $this->buildRow($dest->id, $date, $route, $f);
                }
            }

            // Vidage du chunk pour éviter la consommation mémoire excessive
            if (count($chunk) >= self::CHUNK_SIZE) {
                DB::table('vols')->insert($chunk);
                $totalInserted += count($chunk);
                $chunk = [];
                $this->command->line("   → {$totalInserted} vols insérés…");
            }
        }

        // Dernier chunk résiduel
        if (! empty($chunk)) {
            DB::table('vols')->insert($chunk);
            $totalInserted += count($chunk);
        }

        $this->command->info("✅  {$totalInserted} vols générés avec succès.");
    }

    // ─────────────────────────────────────────────────────────────────

    /**
     * Construit un tableau de colonnes pour l'INSERT batch.
     *
     * @param  array{0:string,1:float,2:int,3:int,4:int}  $route
     */
    private function buildRow(int $destId, Carbon $date, array $route, int $slotIdx): array
    {
        [, $durationHours, $minPrice, $maxPrice] = $route;

        $slot        = self::DEPARTURE_SLOTS[$slotIdx % count(self::DEPARTURE_SLOTS)];
        $departureAt = Carbon::parse($date->toDateString() . ' ' . $slot);
        $arrivalAt   = $departureAt->copy()->addMinutes((int) round($durationHours * 60));

        $airlineNames = array_keys(self::AIRLINES);
        $airlineName  = $airlineNames[array_rand($airlineNames)];
        $iata         = self::AIRLINES[$airlineName];

        $classe    = $this->drawClasse();
        $basePrice = random_int($minPrice, $maxPrice);
        $prix      = round(match ($classe) {
            'affaires' => $basePrice * 2.2,
            'premiere' => $basePrice * 4.0,
            default    => (float) $basePrice,
        }, 2);

        $ts = now()->format('Y-m-d H:i:s');

        return [
            'compagnie'          => $airlineName,
            'numero_vol'         => $iata . random_int(100, 9999),
            'destination_id'     => $destId,
            'date_depart'        => $departureAt->format('Y-m-d H:i:s'),
            'date_arrivee'       => $arrivalAt->format('Y-m-d H:i:s'),
            'prix'               => $prix,
            'places_disponibles' => random_int(20, 220),
            'classe'             => $classe,
            'statut'             => 'programme',
            'created_at'         => $ts,
            'updated_at'         => $ts,
        ];
    }

    /** Tirage pondéré : 70 % économique · 22 % affaires · 8 % première */
    private function drawClasse(): string
    {
        $n = random_int(1, 100);
        return match (true) {
            $n <= 70 => 'economique',
            $n <= 92 => 'affaires',
            default  => 'premiere',
        };
    }
}