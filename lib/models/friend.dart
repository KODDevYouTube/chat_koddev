class Friend {

  final String friend_id;
  final String user_id;
  final String sender_id;
  final String receiver_id;
  final String status;
  final sended_at;
  final accepted_at;
  final String other;
  final String u_id;
  final String u_firstname;
  final String u_lastname;
  final String u_username;
  final String u_image;
  final String u_email;
  final bool u_email_verified;
  final String u_birthday;

  Friend({
    this.friend_id,
    this.user_id,
    this.sender_id,
    this.receiver_id,
    this.status,
    this.sended_at,
    this.accepted_at,
    this.other,
    this.u_id,
    this.u_firstname,
    this.u_lastname,
    this.u_username,
    this.u_image,
    this.u_email,
    this.u_email_verified,
    this.u_birthday
  });

  Friend.fromJson(Map<String, dynamic> json)
      : friend_id = json['friend_id'],
        user_id = json['user_id'],
        sender_id = json['sender_id'],
        receiver_id = json['receiver_id'],
        status = json['status'],
        sended_at = json['sended_at'],
        accepted_at = json['accepted_at'],
        other = json['other'],
        u_id = json['user']['id'],
        u_firstname = json['user']['firstname'],
        u_lastname = json['user']['lastname'],
        u_username = json['user']['username'],
        u_image = json['user']['image'],
        u_email = json['user']['email'],
        u_email_verified = json['user']['email_verified'] == 0 ? false : true,
        u_birthday = json['user']['birthday'];

  Map<String, dynamic> toJson() =>
      {
        'friend_id': friend_id,
        'user_id': user_id,
        'sender_id': sender_id,
        'receiver_id': receiver_id,
        'status': status,
        'sended_at': sended_at,
        'accepted_at': accepted_at,
        'other': other,
        'user': {
          'id': u_id,
          'firstname': u_firstname,
          'lastname': u_lastname,
          'username': u_username,
          'image': u_image,
          'email': u_email,
          'email_verified': u_email_verified ? 1 : 0,
          'birthday': u_birthday,
        }
      };
}