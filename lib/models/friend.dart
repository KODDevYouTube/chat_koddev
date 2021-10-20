class Friend {

  final String id;
  final String firstname;
  final String lastname;
  final String username;
  final String image;
  final String email;
  final bool email_verified;
  final String birthday;
  final String room;

  Friend({
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.image,
    this.email,
    this.email_verified,
    this.birthday,
    this.room
  });

  Friend.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstname = json['firstname'],
        lastname = json['lastname'],
        username = json['username'],
        image = json['image'],
        email = json['email'],
        email_verified = json['email_verified'] == 0 ? false : true,
        birthday = json['birthday'],
        room = json['room'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'username': username,
        'image': image,
        'email': email,
        'email_verified': email_verified ? 1 : 0,
        'birthday': birthday,
        'room': room
      };
}