<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\HotelResource;
use App\Models\Hotel;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class HotelController extends Controller
{
    /**
     * FIX: HotelResource::collection() → prix_nuit retourné comme float.
     */
    public function index(Request $request)
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

        return HotelResource::collection($hotels);
    }

    public function store(Request $request): JsonResponse
    {
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
            'hotel'   => new HotelResource($hotel->load('destination')),
        ], 201);
    }

    public function show(Hotel $hotel): JsonResponse
    {
        return response()->json(
            new HotelResource($hotel->load('destination'))
        );
    }

    public function update(Request $request, Hotel $hotel): JsonResponse
    {
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
            'hotel'   => new HotelResource($hotel->load('destination')),
        ]);
    }

    public function destroy(Hotel $hotel): JsonResponse
    {
        $hotel->delete();

        return response()->json(['message' => 'Hôtel supprimé']);
    }
}