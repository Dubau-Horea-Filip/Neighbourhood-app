class User {
  String name;
  String email;
  List<String> friends;
  List<String> groups;
    @override
  String toString() {
    return 'User{name: $name, email: $email, friends: $friends, groups: $groups}';
  }

  User({required this.name, required this.email, required this.friends, required this.groups});

  factory User.fromJson(Map<String, dynamic> json) {
  return User(
    name: json['name'],
    email: json['email'],
    friends: List<String>.from(json['frinds_emails'] ?? []),
    groups: List<String>.from(json['groupsName'] ?? []),
  );
}


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['friends'] = this.friends;
    data['groups'] = this.groups;
    return data;
  }
}
