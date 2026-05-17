<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('seats', function (Blueprint $table) {
            $table->id();
            $table->foreignId('vol_id')->constrained('vols')->onDelete('cascade');
            $table->string('numero', 4);           // ex: "12A"
            $table->unsignedTinyInteger('rangee');
            $table->char('colonne', 1);             // A–F
            $table->enum('classe', ['economique', 'affaires', 'premiere']);
            $table->enum('statut', ['disponible', 'bloque', 'reserve'])->default('disponible');
            $table->foreignId('reservation_id')
                  ->nullable()
                  ->constrained('reservations')
                  ->onDelete('set null');
            $table->timestamp('bloque_jusqu_a')->nullable();
            $table->timestamps();

            $table->unique(['vol_id', 'numero']);
            $table->index(['vol_id', 'statut', 'classe']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('seats');
    }
};