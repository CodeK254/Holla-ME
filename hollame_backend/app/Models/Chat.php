<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\User;
use App\Models\Reply;

class Chat extends Model
{
    use HasFactory;

    protected $fillable = [
        "message",
        "user_id",
        "recipient_id",
        "image",
    ];

    public function user(){
        return $this->belongsTo(User::class);
    }

    public function recepient(){
        return $this->belongsTo(User::class);
    }

    public function reply(){
        return $this->hasMany(Reply::class);
    }
}
