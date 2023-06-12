class User {
  String name;
  String email;
  String password;
  String pictureurl = "";
  String about;
  List<String> friends;
  List<String> groups;
  @override
  String toString() {
    return 'User{name: $name, email: $email, friends: $friends, groups: $groups}';
  }

  User(
      {required this.name,
      required this.email,
      required this.password,
      required this.about,
      required this.friends,
      required this.groups});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      password: json['password'],
      email: json['email'],
      about: json['about'] ?? '',
      friends: List<String>.from(json['frinds_emails'] ?? []),
      groups: List<String>.from(json['groupsName'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['password'] = this.password;
    data['email'] = this.email;
    data['friends'] = this.friends;
    data['groups'] = this.groups;
    data['about'] = this.about;
    return data;
  }
}
