// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:hollame/Constants/errors.dart';
import 'package:hollame/Constants/urls.dart';
import 'package:hollame/Models/api_model.dart';
import 'package:hollame/Models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<ApiResponse> userRegistration(String? image, String name, String phone, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(registerURL),
      headers: {
        "Accept": "application/json",
      },
      body: {
        "name" : name,
        "image" : image,
        "phone" : phone,
        "password" : password,
      }
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJSON(jsonDecode(response.body));   
        break;

      case 422:
        final errors = jsonDecode(response.body)["errors"];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;

      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

      case 500:
        apiResponse.error = servererror;
        break;

      default:
        apiResponse.error = somethingwentwrong;
        break;
    }
  } catch (e) {
    print("Error is: $e");
    apiResponse.error = somethingwentwrong;
  }

  return apiResponse;
}

Future<ApiResponse> userLogin(String phone, String password) async {
  ApiResponse apiResponse = ApiResponse();

  try {
    var response = await http.post(
      Uri.parse(loginURL),
      headers: {
        "Accept": "application/json",
      },
      body: {
        "phone" : phone,
        "password" : password,
      },
    );

    switch (response.statusCode) {
      case 200:
        apiResponse.data = User.fromJSON(jsonDecode(response.body));   
        break;

      case 401:
        apiResponse.error = unauthorized;
        break;

      case 500:
        apiResponse.error = servererror;
        break;

      default:
        apiResponse.error = somethingwentwrong;
        break;
    }
  } catch (e) {
    apiResponse.error = somethingwentwrong;
  }

  return apiResponse;
}

Future<ApiResponse> userDetails() async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.get(
      Uri.parse(userURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    switch(response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;

      case 401:
        apiResponse.error = unauthorized; 
        break;

      default:
        apiResponse.error = somethingwentwrong;
        break;
    }
  } catch(e){
    apiResponse.error = somethingwentwrong;
  }

  return apiResponse;
}

Future<ApiResponse> getAllUsers() async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.get(
      Uri.parse(usersURL),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    switch(response.statusCode) {
      case 200:
        Map data = jsonDecode(response.body);
        apiResponse.data = data["users"];
        break;

      case 401:
        apiResponse.error = unauthorized; 
        break;

      default:
        apiResponse.error = somethingwentwrong;
        break;
    }
  } catch(e){
    apiResponse.error = somethingwentwrong;
  }

  return apiResponse;
}

Future userUpdate(String? image, String name, String phone, String email, String about, String facebook) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.put(
      Uri.parse("http://192.168.0.200:8000/api/users/user"),
      headers: {
        "Accept": "application/json",
        "Authorization" : "Bearer $token",
      },
      body: image == null ? {
        "image" : image,
        "name" : name,
        "phone" : phone,
        "email" : email,
        "about" : about,
        "facebook" : facebook,
      }:
      {
        "name" : name,
        "phone" : phone,
        "email" : email,
        "about" : about,
        "facebook" : facebook,
      }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;

      case 422:
        final errors = jsonDecode(response.body)["errors"];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;

      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

      case 500:
        apiResponse.error = servererror;
        break;

      default:
        apiResponse.error = somethingwentwrong;
        break;
    }
  } catch(e){
    apiResponse.error = somethingwentwrong;
  }

  return apiResponse;
}

Future<ApiResponse> sendMessage(int uid, String message) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.post(
      Uri.parse("http://192.168.0.200:8000/api/users/$uid"),
      headers: {
        "Accept" : "application/json",
        "Authorization" : "Bearer $token",
      },
      body: {
        "message" : message,
      },
    );

    switch(response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body);
        print("Response body is: ${apiResponse.data}");
        break;

      case 422:
        final errors = jsonDecode(response.body)["errors"];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;

      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

      case 401:
        apiResponse.error = "You cannot send yourself a message";
        break;

      case 500:
        apiResponse.error = servererror;
        break;

      default:
        apiResponse.error = somethingwentwrong;
        break;
    }

  } catch(e){
    apiResponse.error = somethingwentwrong;
  }

  return apiResponse;
}

Future<ApiResponse> getChat(int uid) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final response = await http.get(
      Uri.parse("http://192.168.0.200:8000/api/users/$uid/messages"),
      headers: {
        "Accept" : "application/json",
        "Authorization" : "Bearer $token",
      },
    );

    switch(response.statusCode) {
      case 200:
        apiResponse.data = jsonDecode(response.body)["chats"];
        print("Response body is: ${apiResponse.data}");
        break;

      case 422:
        final errors = jsonDecode(response.body)["errors"];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;

      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;

      case 500:
        apiResponse.error = servererror;
        break;

      default:
        apiResponse.error = somethingwentwrong;
        break;
    }

  } catch(e){
    apiResponse.error = somethingwentwrong;
  }

  return apiResponse;
}

// ----------USER TOKEN---------------------
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// ---------get Image String ---------------
String? getStringImage(File? file){
  if(file == null){
    return null;
  }
  else{
    return base64Encode(file.readAsBytesSync());
  }
}