<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('passengers', function (Blueprint $table) {
            $table->id();
            $table->foreignId('reservation_id')->constrained('reservations')->onDelete('cascade');
            $table->foreignId('seat_id')
                  ->nullable()
                  ->constrained('seats')
                  ->onDelete('set null');
            $table->foreignId('seat_retour_id')
                  ->nullable()
                  ->constrained('seats')
                  ->onDelete('set null');
            $table->string('prenom');
            $table->string('nom');
            $table->date('date_naissance');
            // adulte: ≥12 ans | enfant: 2-11 ans | bebe: <2 ans (pas de siège)
            $table->enum('type_passager', ['adulte', 'enfant', 'bebe']);
            $table->string('numero_passeport')->nullable();
            $table->char('nationalite', 2)->nullable(); // ISO 3166-1 alpha-2
            $table->enum('genre', ['homme', 'femme']);
            $table->boolean('est_contact_principal')->default(false);
            $table->timestamps();

            $table->index('reservation_id');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('passengers');
    }
};
