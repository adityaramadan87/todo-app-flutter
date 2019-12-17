import 'dart:convert';

class Post {
  int id;
  String name;
  String email;
  int age;

  Post({this.id = 0, this.name, this.email, this.age});

  factory Post.fromJson(Map<String, dynamic> map) {
    return Post(
        id: map["id"], name: map["name"], email: map["email"], age: map["age"]);
  }

  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "email": email, "age": age};
  }

  @override
  String toString() {
    return 'Profile{id: $id, name: $name, email: $email, age: $age}';
  }

}

List<Post> postFromJson(String jsonData) {
  final data = json.decode(jsonData);
  return List<Post>.from(data.map((item) => Post.fromJson(item)));
}

String postToJson(Post data) {
  final jsonData = data.toJson();
  return json.encode(jsonData);
}
