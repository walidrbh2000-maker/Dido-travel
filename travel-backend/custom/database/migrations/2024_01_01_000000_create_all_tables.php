<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('destinations', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('country');
            $table->text('description')->nullable();
            $table->string('image')->nullable();
            $table->boolean('is_popular')->default(false);
            $table->timestamps();
        });

        Schema::create('vols', function (Blueprint $table) {
            $table->id();
            $table->string('compagnie');
            $table->string('numero_vol');
            $table->foreignId('destination_id')->constrained()->onDelete('cascade');
            $table->datetime('date_depart');
            $table->datetime('date_arrivee');
            $table->decimal('prix', 10, 2);
            $table->integer('places_disponibles');
            $table->enum('classe', ['economique', 'affaires', 'premiere'])->default('economique');
            $table->enum('statut', ['programme', 'en_vol', 'atterri', 'annule'])->default('programme');
            $table->timestamps();
        });

        Schema::create('hotels', function (Blueprint $table) {
            $table->id();
            $table->string('nom');
            $table->foreignId('destination_id')->constrained()->onDelete('cascade');
            $table->integer('etoiles')->default(3);
            $table->decimal('prix_nuit', 10, 2);
            $table->string('adresse');
            $table->text('description')->nullable();
            $table->string('image')->nullable();
            $table->boolean('disponible')->default(true);
            $table->timestamps();
        });

        Schema::create('guides', function (Blueprint $table) {
            $table->id();
            $table->string('nom');
            $table->foreignId('destination_id')->constrained()->onDelete('cascade');
            $table->json('langues');
            $table->integer('experience_annees')->default(0);
            $table->decimal('tarif_jour', 10, 2);
            $table->text('description')->nullable();
            $table->string('image')->nullable();
            $table->boolean('disponible')->default(true);
            $table->timestamps();
        });

        Schema::create('reservations', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->foreignId('vol_id')->constrained('vols')->onDelete('cascade');
            $table->foreignId('hotel_id')->nullable()->constrained('hotels')->onDelete('set null');
            $table->date('date_debut');
            $table->date('date_fin');
            $table->integer('nombre_personnes');
            $table->decimal('prix_total', 10, 2);
            $table->enum('statut', ['en_attente', 'confirmee', 'annulee', 'payee'])->default('en_attente');
            $table->string('reference')->unique();
            $table->timestamps();
            $table->softDeletes();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('reservations');
        Schema::dropIfExists('guides');
        Schema::dropIfExists('hotels');
        Schema::dropIfExists('vols');
        Schema::dropIfExists('destinations');
    }
};
