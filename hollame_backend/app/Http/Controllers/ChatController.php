<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Chat;

class ChatController extends Controller
{
    public function send(Request $request, $id){
        $recepient = User::find($id);
        if(!$recepient){
            return response()->json([
                "message" => "User doesnt exist",
            ], 404);
        }

        if($recepient->id == auth()->user()->id){
            return response()->json([
                "message" => "You cannot send a message to yourself",
            ], 401);
        }

        $attrs = request()->validate([
            "message" => "required|string|max:255|min:1",
        ]);

        $image = $this->saveImage($request->image, "posts");

        $chat = Chat::create([
            "message" => $attrs["message"],
            "user_id" => (string)auth()->user()->id,
            "recipient_id" => $id,
            $image = $image,
        ]);

        return response()->json([
            "chat" => $chat,
            "text" => "Message sent successfully",
        ]);
    }

    public function messages($id){
        $chats = Chat::where("recipient_id", $id)->where("user_id", auth()->user()->id)
        ->orWhere("recipient_id", auth()->user()->id)->where("user_id", $id)
        ->with('user:id,name,image')
        ->get();

        return response()->json([
            "chats" => $chats,
        ], 200);
    }
}
