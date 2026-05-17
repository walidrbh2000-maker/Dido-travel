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
        $hotel = Hotel::create($request->all());

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
        $hotel->update($request->all());

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
