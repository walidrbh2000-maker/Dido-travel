<?php

namespace Database\Seeders;

use App\Models\Destination;
use Illuminate\Database\Seeder;

class DestinationSeeder extends Seeder
{
    /**
     * [name, country, is_popular, description]
     */
    private const DESTINATIONS = [
        // ── Destinations algériennes (domestiques) ──────────────────
        ['Oran',        'Algérie', true,  'Deuxième ville d\'Algérie, réputée pour ses plages et son art de vivre méditerranéen.'],
        ['Constantine', 'Algérie', false, 'Ville des ponts suspendus, joyau architectural perché sur un plateau rocheux.'],
        ['Annaba',      'Algérie', false, 'Cité balnéaire verdoyante baignée par la Méditerranée.'],
        ['Tlemcen',     'Algérie', false, 'Perle du Maghreb, riche d\'un patrimoine islamique et andalou exceptionnel.'],
        ['Béjaïa',      'Algérie', false, 'Porte de la Kabylie, entre mer turquoise et montagnes du Djurdjura.'],
        ['Sétif',       'Algérie', false, 'Carrefour des Hauts Plateaux, ville dynamique au cœur de l\'Algérie.'],
        ['Ghardaïa',    'Algérie', false, 'Cité mozabite classée au patrimoine mondial de l\'UNESCO.'],
        ['Tamanrasset', 'Algérie', false, 'Porte du Sahara, destination incontournable pour les aventuriers du désert.'],

        // ── Destinations internationales ─────────────────────────────
        ['Paris',      'France',                'true',  'La Ville Lumière, capitale mondiale de la culture et de la gastronomie.'],
        ['Marseille',  'France',                'true',  'Premier port de France, porte de la Méditerranée aux mille saveurs.'],
        ['Lyon',       'France',                'false', 'Capitale gastronomique mondiale nichée entre le Rhône et la Saône.'],
        ['Londres',    'Royaume-Uni',           'true',  'Métropole cosmopolite, berceau du Big Ben et de la culture britannique.'],
        ['Madrid',     'Espagne',               'true',  'Ville royale vibrante, musées de renommée mondiale et joie de vivre ibérique.'],
        ['Rome',       'Italie',                'true',  'Cité éternelle, berceau de la civilisation occidentale et de la haute cuisine.'],
        ['Dubaï',      'Émirats arabes unis',   'true',  'Mégapole futuriste du Golfe, symbole du luxe et de l\'innovation.'],
        ['Istanbul',   'Turquie',               'true',  'Carrefour des civilisations entre Orient et Occident sur deux continents.'],
        ['Le Caire',   'Égypte',                'false', 'Porte des pyramides, capitale arabe aux mille et une facettes.'],
        ['Tunis',      'Tunisie',               'false', 'Capitale méditerranéenne alliant modernité et médina classée à l\'UNESCO.'],
        ['Casablanca', 'Maroc',                 'false', 'Métropole économique du Maroc, ville de contrastes et de modernité.'],
        ['New York',   'États-Unis',            'true',  'La ville qui ne dort jamais, capitale mondiale de la finance et de l\'innovation.'],
    ];

    public function run(): void
    {
        if (Destination::count() > 0) {
            $this->command->warn('⚠️  Destinations déjà présentes — DestinationSeeder ignoré.');
            return;
        }

        foreach (self::DESTINATIONS as [$name, $country, $isPopular, $description]) {
            Destination::create([
                'name'        => $name,
                'country'     => $country,
                'description' => $description,
                'is_popular'  => (bool) $isPopular,
                'image'       => null,
            ]);
        }

        $this->command->info('✅  ' . Destination::count() . ' destinations insérées.');
    }
}