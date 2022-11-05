class User {
  User(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.userName,
      required this.password});

  User.fromJson(Map<String, Object?> json)
      : this(
            firstName: json['firstName']! as String,
            lastName: json['lastName']! as String,
            email: json['email']! as String,
            userName: json['userName']! as String,
            password: json['password']! as String);

  final String firstName;
  final String lastName;
  final String email;
  final String userName;
  final String password;

  Map<String, Object?> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'userName': userName,
      'password': password
    };
  }
}
