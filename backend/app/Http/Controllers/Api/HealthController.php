<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;

class HealthController extends Controller
{
    /**
     * Проверка работоспособности API
     */
    public function index(): JsonResponse
    {
        return response()->json([
            'status' => 'ok',
            'message' => 'HomeFlow API is running',
            'timestamp' => now()->toIso8601String(),
        ]);
    }
}
