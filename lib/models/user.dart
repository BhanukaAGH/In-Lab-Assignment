class User {
  final String uid;
  final String email;

  User({
    required this.uid,
    required this.email,
  });

  static User fromSnap(Map<String, dynamic> data) {
    return User(
      uid: data['uid'],
      email: data['email'],
    );
  }
}
