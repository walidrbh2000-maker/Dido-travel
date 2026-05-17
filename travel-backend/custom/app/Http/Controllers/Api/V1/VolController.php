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
        // BUG 3 FIX: validate instead of $request->all()
        $vol = Vol::create($request->validate([
            'compagnie'          => 'required|string|max:255',
            'numero_vol'         => 'required|string|max:255',
            'destination_id'     => 'required|exists:destinations,id',
            'date_depart'        => 'required|date',
            'date_arrivee'       => 'required|date',
            'prix'               => 'required|numeric|min:0',
            'places_disponibles' => 'required|integer|min:0',
            'classe'             => 'required|in:economique,affaires,premiere',
            'statut'             => 'sometimes|in:programme,en_vol,atterri,annule',
        ]));

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
        // BUG 3 FIX: validate instead of $request->all()
        $vol->update($request->validate([
            'compagnie'          => 'sometimes|string|max:255',
            'numero_vol'         => 'sometimes|string|max:255',
            'destination_id'     => 'sometimes|exists:destinations,id',
            'date_depart'        => 'sometimes|date',
            'date_arrivee'       => 'sometimes|date',
            'prix'               => 'sometimes|numeric|min:0',
            'places_disponibles' => 'sometimes|integer|min:0',
            'classe'             => 'sometimes|in:economique,affaires,premiere',
            'statut'             => 'sometimes|in:programme,en_vol,atterri,annule',
        ]));

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