class Friend {
  String name;
  String email;
  

  @override
  String toString() {
    return 'User{name: $name, email: $email}';
  }

  Friend({
    required this.name,
    required this.email,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;

    return data;
  }
}
