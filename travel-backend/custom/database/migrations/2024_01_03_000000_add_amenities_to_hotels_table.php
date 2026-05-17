<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('hotels', function (Blueprint $table) {
            $table->string('amenities')->nullable()->after('description');
            $table->decimal('note', 3, 1)->default(0.0)->after('amenities');
            $table->unsignedInteger('nb_avis')->default(0)->after('note');
        });
    }

    public function down(): void
    {
        Schema::table('hotels', function (Blueprint $table) {
            $table->dropColumn(['amenities', 'note', 'nb_avis']);
        });
    }
};