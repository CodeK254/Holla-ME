<?php

namespace App\Http\Controllers;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use App\Models\User;
class AuthsController extends Controller
{
    public function register(Request $request){
        $check = $request->validate([
            "name" => "required|string|max:255",
            "phone" => "required|unique:users|integer|min:9",
            "password" => "required|string|max:255|min:6",
        ]);

        $image = $this->saveImage($request->image, "profiles");

        $user = User::create([
            "name" => $check["name"],
            "phone" => $check["phone"],
            "image" => $image,
            "password" => bcrypt($check["password"]),
        ]);

        return response()->json([
            "message" => "User successfully registered",
            "user" => $user,
            "token" => $user->createToken("secret")->plainTextToken,
        ], 200);
    }

    public function login(Request $request){
        $check = $request->validate([
            "phone" => "required|string|min:9",
            "password" => "required|min:6",
        ]);

        if(!Auth::attempt($check)){
            return response()->json([
                'message' => 'Invalid Credentials',
            ], 401);
        }

        $user = Auth::user();

        return response()->json([
            "message" => "User logged in successfully",
            "user" => $user,
            "token" => $user->createToken("secret")->plainTextToken,
        ], 200);
    }

    public function index() {
        $users = User::all();
        return response()->json([
            'users' => $users,
        ], 200);
    }

    public function show($id){
        $user = User::find($id);

        if(!$user){
            return response()->json([
                "message" => "User doesn`t exist",
            ], 404);
        }

        return response()->json([
            "user" => $user,
        ], 200);
    }

    // Get User.
    public function user() {
        return response([
            'user' => auth()->user(),
        ], 200);
    }

    public function update(Request $request){
        if(!Auth::user()){
            return response()->json([
                'message' => 'You are not authorized to update this user',
            ], 401);
        }

        $attrs = request()->validate([
            "name" => "required|string|max:255",
            "about" => "required|string|max:255",
            "email" => "required|string|max:255|unique:users",
            "facebook" => "required|string|max:255",
        ]);

        auth()->user()->update([
            "name" => $attrs['name'],
            "email" => $attrs['email'],
            "facebook" => $attrs['facebook'],
            "about" => $attrs['about'],
        ]);

        return response()->json([
            "user" => auth()->user(),
            "message" => "User updated successfully.",
        ], 200);
    }

    public function logout($id) {
        $user = User::find($id);

        if(!$user){
            return response()->json([
                "message" => "User doesn`t exist",
            ], 404);
        }

        $check = $user->id;

        if(auth()->user()->id == $check){
            auth()->user()->tokens()->delete();

            return response()->json([
                "message" => "User does not exist anymore.",
            ], 201);
        }
    }
}
