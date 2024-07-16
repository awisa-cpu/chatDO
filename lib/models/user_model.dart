class UserModel {
  final String uid;
  final String name;
  final String pfp;
  final String email;

  UserModel({
    required this.uid,
    required this.name,
    required this.pfp,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['uid'] = uid;
    data['name'] = name;
    data['pfp'] = pfp;
    data['email'] = email;

    return data;
  }

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] as String,
      name: data['name'] as String,
      pfp: data['pfp'] as String,
      email: data['email'] as String,
    );
  }

}
