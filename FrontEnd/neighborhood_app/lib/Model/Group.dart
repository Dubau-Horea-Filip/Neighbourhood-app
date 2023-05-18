class Group {
  String name;
  String location;
  int numberOfCommonFriends;
  
  Group({
    required this.name,
    required this.location,
    required this.numberOfCommonFriends,
  });
  
  @override
  String toString() {
    return 'Group{name: $name, location: $location, numberOfCommonFriends: $numberOfCommonFriends}';
  }
  
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      name: json['name'],
      location: json['location'],
      numberOfCommonFriends: json['numberOfCommonFriends'],
    );
  }
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['location'] = location;
    data['numberOfCommonFriends'] = numberOfCommonFriends;
    return data;
  }
}
