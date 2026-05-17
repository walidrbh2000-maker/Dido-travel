<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Hotel;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class HotelController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Hotel::with('destination');

        if ($request->filled('destination_id')) {
            $query->where('destination_id', $request->destination_id);
        }

        if ($request->filled('etoiles')) {
            $query->where('etoiles', '>=', $request->etoiles);
        }

        if ($request->filled('prix_max')) {
            $query->where('prix_nuit', '<=', $request->prix_max);
        }

        $hotels = $query->where('disponible', true)
            ->orderBy('etoiles', 'desc')
            ->paginate($request->integer('per_page', 15));

        return response()->json($hotels);
    }

    public function store(Request $request): JsonResponse
    {
        // BUG 3 FIX: validate instead of $request->all()
        $hotel = Hotel::create($request->validate([
            'nom'            => 'required|string|max:255',
            'destination_id' => 'required|exists:destinations,id',
            'etoiles'        => 'required|integer|min:1|max:5',
            'prix_nuit'      => 'required|numeric|min:0',
            'adresse'        => 'required|string|max:500',
            'description'    => 'nullable|string',
            'amenities'      => 'nullable|string',
            'disponible'     => 'boolean',
        ]));

        return response()->json([
            'message' => 'Hôtel créé avec succès',
            'hotel'   => $hotel->load('destination'),
        ], 201);
    }

    public function show(Hotel $hotel): JsonResponse
    {
        return response()->json($hotel->load('destination'));
    }

    public function update(Request $request, Hotel $hotel): JsonResponse
    {
        // BUG 3 FIX: validate instead of $request->all()
        $hotel->update($request->validate([
            'nom'            => 'sometimes|string|max:255',
            'destination_id' => 'sometimes|exists:destinations,id',
            'etoiles'        => 'sometimes|integer|min:1|max:5',
            'prix_nuit'      => 'sometimes|numeric|min:0',
            'adresse'        => 'sometimes|string|max:500',
            'description'    => 'nullable|string',
            'amenities'      => 'nullable|string',
            'disponible'     => 'sometimes|boolean',
        ]));

        return response()->json([
            'message' => 'Hôtel mis à jour',
            'hotel'   => $hotel->load('destination'),
        ]);
    }

    public function destroy(Hotel $hotel): JsonResponse
    {
        $hotel->delete();

        return response()->json(['message' => 'Hôtel supprimé']);
    }
}