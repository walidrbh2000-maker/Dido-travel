<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\VolResource;
use App\Models\Vol;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class VolController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Vol::with('destination');

        if ($request->filled('destination_id')) {
            $query->where('destination_id', $request->destination_id);
        }

        if ($request->filled('date_depart')) {
            $query->whereDate('date_depart', '>=', $request->date_depart);
        }

        if ($request->filled('prix_max')) {
            $query->where('prix', '<=', $request->prix_max);
        }

        if ($request->filled('classe')) {
            $query->where('classe', $request->classe);
        }

        $vols = $query->where('places_disponibles', '>', 0)
            ->orderBy('date_depart')
            ->paginate($request->integer('per_page', 15));

        return response()->json($vols);
    }

    public function store(Request $request): JsonResponse
    {
        $vol = Vol::create($request->all());

        return response()->json([
            'message' => 'Vol créé avec succès',
            'vol'     => new VolResource($vol->load('destination')),
        ], 201);
    }

    public function show(Vol $vol): JsonResponse
    {
        return response()->json(new VolResource($vol->load('destination')));
    }

    public function update(Request $request, Vol $vol): JsonResponse
    {
        $vol->update($request->all());

        return response()->json([
            'message' => 'Vol mis à jour',
            'vol'     => new VolResource($vol->load('destination')),
        ]);
    }

    public function destroy(Vol $vol): JsonResponse
    {
        $vol->delete();

        return response()->json(['message' => 'Vol supprimé']);
    }
}
