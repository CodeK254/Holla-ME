<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::post("/signup", [App\Http\Controllers\AuthsController::class, "register"]);

Route::post("/signin", [App\Http\Controllers\AuthsController::class, "login"]);

Route::group(["middleware" => ["auth:sanctum"]], function () {
    //------------------------------------U S E R S--------------------------------------
    Route::get("/users", [App\Http\Controllers\AuthsController::class, "index"]);
    Route::get("/users/user", [App\Http\Controllers\AuthsController::class, "user"]);
    Route::put("/users/user", [App\Http\Controllers\AuthsController::class, "update"]);
    Route::get("/users/{id}", [App\Http\Controllers\AuthsController::class, "show"]);
    Route::put("/users/{id}", [App\Http\Controllers\AuthsController::class, "update"]);
    Route::delete("/users/{id}", [App\Http\Controllers\AuthsController::class, "logout"]);

    //------------------------------------C H A T S---------------------------------------
    Route::post("/users/{id}", [App\Http\Controllers\ChatController::class, "send"]);
    Route::get("/users/{id}/messages", [App\Http\Controllers\ChatController::class, "messages"]);
});
