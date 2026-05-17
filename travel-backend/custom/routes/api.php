<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\V1\{
    AuthController,
    VolController,
    HotelController,
    ReservationController,
    PaymentController,
    DestinationController,
    GuideController,
    SeatController,
};

Route::prefix('v1')->group(function () {

    // ── Auth public ───────────────────────────────────────────────────────────
    Route::post('register', [AuthController::class, 'register']);
    Route::post('login',    [AuthController::class, 'login']);

    // ── Navigation publique ───────────────────────────────────────────────────
    Route::apiResource('destinations', DestinationController::class)->only(['index', 'show']);
    Route::apiResource('guides',       GuideController::class)->only(['index', 'show']);
    Route::apiResource('vols',         VolController::class)->only(['index', 'show']);
    Route::apiResource('hotels',       HotelController::class)->only(['index', 'show']);

    // Carte des sièges (publique — lecture seule)
    Route::get('vols/{vol}/seats', [SeatController::class, 'index']);

    // ── Authentifié ───────────────────────────────────────────────────────────
    Route::middleware('auth:api')->group(function () {

        Route::post('logout', [AuthController::class, 'logout']);
        Route::get('me',      [AuthController::class, 'me']);

        // Blocage/libération de sièges
        Route::post('vols/{vol}/seats/{seat}/lock',   [SeatController::class, 'lock']);
        Route::delete('vols/{vol}/seats/{seat}/lock', [SeatController::class, 'unlock']);

        Route::apiResource('reservations', ReservationController::class);
        Route::get('reservations/{reservation}/ticket',
            [ReservationController::class, 'ticket']);

        Route::post('payments/process',  [PaymentController::class, 'process']);
        Route::get('payments/{payment}', [PaymentController::class, 'show']);

        // ── Admin ─────────────────────────────────────────────────────────────
        Route::middleware('admin')->prefix('admin')->group(function () {
            Route::apiResource('destinations', DestinationController::class)
                ->only(['store', 'update', 'destroy']);
            Route::apiResource('guides', GuideController::class)
                ->only(['store', 'update', 'destroy']);
            Route::apiResource('vols', VolController::class)
                ->only(['store', 'update', 'destroy']);
            Route::apiResource('hotels', HotelController::class)
                ->only(['store', 'update', 'destroy']);
        });
    });
});