// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Contact {
  final String uid;
  int newMessages;

  Contact(
    this.uid,
    this.newMessages,
  );

  Contact copyWith({
    String? uid,
    int? newMessages,
  }) {
    return Contact(
      uid ?? this.uid,
      newMessages ?? this.newMessages,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'newMessages': newMessages,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      map['uid'] as String,
      map['newMessages'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) =>
      Contact.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Contact(uid: $uid, newMessages: $newMessages)';

  @override
  bool operator ==(covariant Contact other) {
    if (identical(this, other)) return true;

    return other.uid == uid && other.newMessages == newMessages;
  }

  @override
  int get hashCode => uid.hashCode ^ newMessages.hashCode;
}
