<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Http\Resources\GuideResource;
use App\Models\Guide;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class GuideController extends Controller
{
    /**
     * FIX: GuideResource::collection() → tarif_jour retourné comme float.
     */
    public function index(Request $request)
    {
        $query = Guide::with('destination');

        if ($request->filled('destination_id')) {
            $query->where('destination_id', $request->destination_id);
        }

        if ($request->filled('langue')) {
            $query->whereJsonContains('langues', $request->langue);
        }

        $guides = $query->where('disponible', true)
            ->orderBy('experience_annees', 'desc')
            ->paginate($request->integer('per_page', 15));

        return GuideResource::collection($guides);
    }

    public function indexAdmin(Request $request)
    {
        $query = Guide::with('destination');

        if ($request->filled('destination_id')) {
            $query->where('destination_id', $request->destination_id);
        }

        if ($request->filled('langue')) {
            $query->whereJsonContains('langues', $request->langue);
        }

        if ($request->filled('disponible')) {
            $query->where('disponible', $request->boolean('disponible'));
        }

        $guides = $query->orderBy('experience_annees', 'desc')
            ->paginate($request->integer('per_page', 15));

        return GuideResource::collection($guides);
    }

    public function store(Request $request): JsonResponse
    {
        $guide = Guide::create($request->validate([
            'nom'               => 'required|string|max:255',
            'destination_id'    => 'required|exists:destinations,id',
            'langues'           => 'required|array',
            'experience_annees' => 'integer|min:0',
            'tarif_jour'        => 'required|numeric|min:0',
            'description'       => 'nullable|string',
            'image'             => 'nullable|string',
            'disponible'        => 'boolean',
        ]));

        return response()->json([
            'message' => 'Guide créé avec succès',
            'guide'   => new GuideResource($guide->load('destination')),
        ], 201);
    }

    public function show(Guide $guide): JsonResponse
    {
        return response()->json(
            new GuideResource($guide->load('destination'))
        );
    }

    public function update(Request $request, Guide $guide): JsonResponse
    {
        $guide->update($request->all());

        return response()->json([
            'message' => 'Guide mis à jour',
            'guide'   => new GuideResource($guide->load('destination')),
        ]);
    }

    public function destroy(Guide $guide): JsonResponse
    {
        $guide->delete();

        return response()->json(['message' => 'Guide supprimé']);
    }
}