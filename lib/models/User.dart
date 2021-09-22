class User {

  final String id;
  final String firstName;
  final String lastName;
  final String username;
  final String image;
  final String email;
  final bool email_verified;
  final String birthday;

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.username,
    this.image,
    this.email,
    this.email_verified,
    this.birthday
  });

  String get fullName {
    return '$firstName '
            '${lastName != null
              ? lastName
              : ''}';
  }

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['firstname'],
        lastName = json['lastname'],
        username = json['username'],
        image = json['image'],
        email = json['email'],
        email_verified = json['email_verified'] == 0 ? false : true,
        birthday = json['birthday'];

}