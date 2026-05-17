<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Destination;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DestinationController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $query = Destination::query();

        if ($request->boolean('popular')) {
            $query->where('is_popular', true);
        }

        if ($request->filled('country')) {
            $query->where('country', $request->country);
        }

        $destinations = $query->orderBy('name')
            ->paginate($request->integer('per_page', 15));

        return response()->json($destinations);
    }

    public function store(Request $request): JsonResponse
    {
        $destination = Destination::create($request->validate([
            'name'        => 'required|string|max:255',
            'country'     => 'required|string|max:255',
            'description' => 'nullable|string',
            'image'       => 'nullable|string',
            'is_popular'  => 'boolean',
        ]));

        return response()->json([
            'message'     => 'Destination créée avec succès',
            'destination' => $destination,
        ], 201);
    }

    public function show(Destination $destination): JsonResponse
    {
        return response()->json(
            $destination->load(['vols', 'hotels', 'guides'])
        );
    }

    public function update(Request $request, Destination $destination): JsonResponse
    {
        $destination->update($request->all());

        return response()->json([
            'message'     => 'Destination mise à jour',
            'destination' => $destination,
        ]);
    }

    public function destroy(Destination $destination): JsonResponse
    {
        $destination->delete();

        return response()->json(['message' => 'Destination supprimée']);
    }
}
