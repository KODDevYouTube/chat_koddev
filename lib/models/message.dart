class Message {

  final String message_id;
  final String message;
  String status;
  final created;
  final String id;
  final String firstname;
  final String lastname;
  final String username;
  final String image;
  final String email;
  final bool email_verified;
  final String birthday;

  Message({
    this.message_id,
    this.message,
    this.status,
    this.created,
    this.id,
    this.firstname,
    this.lastname,
    this.username,
    this.image,
    this.email,
    this.email_verified,
    this.birthday,
  });

  Message.fromJson(Map<String, dynamic> json)
      : message_id = json['message_id'],
        message = json['message'],
        status = json['status'],
        created = json['message_created'],
        id = json['user']['id'],
        firstname = json['user']['firstname'],
        lastname = json['user']['lastname'],
        username = json['user']['username'],
        image = json['user']['image'],
        email = json['user']['email'],
        email_verified = json['user']['email_verified'] == 0 ? false : true,
        birthday = json['user']['birthday'];

  Map<String, dynamic> toJson() =>
      {
        'message_id': message_id,
        'message': message,
        'status': status,
        'message_created': created,
        'user': {
          'id': id,
          'firstname': firstname,
          'lastname': lastname,
          'username': username,
          'image': image,
          'email': email,
          'email_verified': email_verified ? 1 : 0,
          'birthday': birthday
        },
      };

}