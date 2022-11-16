import 'dart:ffi';

class User {
  String id;
  final String firstName;
  final String lastName;
  final String email;
  final String userName;
  final String password;
  final Array favorites;

  User(
      {this.id = "",
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.userName,
      required this.password,
      required this.favorites});

  User.fromJson(Map<String, Object?> json)
      : this(
            id: json['id']! as String,
            firstName: json['firstName']! as String,
            lastName: json['lastName']! as String,
            email: json['email']! as String,
            userName: json['userName']! as String,
            password: json['password']! as String,
            favorites: json['favorites']! as Array);

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'userName': userName,
      'password': password,
      'favorites': favorites,
    };
  }
}
