import 'dart:convert';

import 'package:chat_koddev/models/user.dart';

class Chat {

  final String participants_id;
  final String user_id;
  final String room_id;
  final String name;
  final String type;
  final String r_id;
  final String r_firstname;
  final String r_lastname;
  final String r_username;
  final String r_image;
  final String r_email;
  final bool r_email_verified;
  final String r_birthday;
  final String message_id;
  final String message;
  final message_created;
  final String id;
  final String firstname;
  final String lastname;
  final String username;

  Chat({
    this.participants_id,
    this.user_id,
    this.room_id,
    this.name,
    this.type,
    this.r_id,
    this.r_firstname,
    this.r_lastname,
    this.r_username,
    this.r_image,
    this.r_email,
    this.r_email_verified,
    this.r_birthday,
    this.message_id,
    this.message,
    this.message_created,
    this.id,
    this.firstname,
    this.lastname,
    this.username
  });

  Chat.fromJson(Map<String, dynamic> jsonn)
      : participants_id = jsonn['participants_id'],
        user_id = jsonn['user_id'],
        room_id = jsonn['room']['room_id'],
        name = jsonn['room']['name'],
        type = jsonn['room']['type'],
        r_id = jsonn['receiver']['id'],
        r_firstname = jsonn['receiver']['firstname'],
        r_lastname = jsonn['receiver']['lastname'],
        r_username = jsonn['receiver']['username'],
        r_image = jsonn['receiver']['image'],
        r_email = jsonn['receiver']['email'],
        r_email_verified = jsonn['receiver']['email_verified'] == 0 ? false : true,
        r_birthday = jsonn['receiver']['birthday'],
        message_id = jsonn['message']['message_id'],
        message = jsonn['message']['message'],
        message_created = jsonn['message']['message_created'],
        id = jsonn['message']['user']['id'],
        firstname = jsonn['message']['user']['firstname'],
        lastname = jsonn['message']['user']['lastname'],
        username = jsonn['message']['user']['username'];

  Map<String, dynamic> toJson() =>
      {
        'participants_id': participants_id,
        'user_id': user_id,
        'room': {
          'room_id': room_id,
          'name': name,
          'type': type,
        },
        'receiver': {
          'id': r_id,
          'firstname': r_firstname,
          'lastname': r_lastname,
          'username': r_username,
          'image': r_image,
          'email': r_email,
          'email_verified': r_email_verified ? 1 : 0,
          'birthday': r_birthday,
        },
        'message': {
          'message_id': message_id,
          'message': message,
          'message_created': message_created,
          'user': {
            'id': id,
            'firstname': firstname,
            'lastname': lastname,
            'username': username,
          }
        }
      };

}