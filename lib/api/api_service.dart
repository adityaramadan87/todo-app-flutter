import 'package:http/http.dart';
import 'package:learnflutter/model/post_model.dart';
import 'package:http/http.dart' show Client;

class ApiService {
  final String baseUrl = "http://api.bengkelrobot.net:8001";
  Client client = Client();

  Future<List<Post>> getProfiles() async {
    final response = await client.get("$baseUrl/profile");
    if (response.statusCode == 200) {
      return postFromJson(response.body);
    }else {
      return null;
    }
  }
  Future<bool> createPost(Post data) async {
    final response = await client.post(
      "$baseUrl/profile",
      headers : {"content-type" : "application/json"},
      body: postToJson(data),
    );
    if (response.statusCode == 201){
      return true;
    }else{
      return false;
    }
  }
  Future<bool> updatePost(Post data) async {
    final response = await client.put(
      "$baseUrl/profile/${data.id}",
      headers: {"content-type": "application/json"},
      body: postToJson(data),
    );
    if (response.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }
  Future<bool> deletePost(int id) async {
    final response = await client.delete("$baseUrl/profile/$id", 
    headers: {"content-type": "application/json"},
    );
    if (response.statusCode == 200){
      return true;
    }else{
      return false;
    }
  }
}