<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Destination extends Model
{
    use HasFactory;

    protected $fillable = ['name', 'country', 'description', 'image', 'is_popular'];

    protected function casts(): array
    {
        return ['is_popular' => 'boolean'];
    }

    public function vols()   { return $this->hasMany(Vol::class); }
    public function hotels() { return $this->hasMany(Hotel::class); }
    public function guides() { return $this->hasMany(Guide::class); }
}
