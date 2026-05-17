<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('reservations', function (Blueprint $table) {
            $table->enum('type_trajet', ['aller_simple', 'aller_retour'])
                  ->default('aller_simple')
                  ->after('vol_id');
            $table->foreignId('vol_retour_id')
                  ->nullable()
                  ->after('type_trajet')
                  ->constrained('vols')
                  ->onDelete('set null');
            $table->foreignId('guide_id')
                  ->nullable()
                  ->after('hotel_id')
                  ->constrained('guides')
                  ->onDelete('set null');
        });
    }

    public function down(): void
    {
        Schema::table('reservations', function (Blueprint $table) {
            $table->dropForeign(['vol_retour_id']);
            $table->dropForeign(['guide_id']);
            $table->dropColumn(['type_trajet', 'vol_retour_id', 'guide_id']);
        });
    }
};