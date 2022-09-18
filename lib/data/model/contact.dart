// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Contact {
  final String uid;
  Contact(
    this.uid,
  );

  Contact copyWith({
    String? uid,
  }) {
    return Contact(
      uid ?? this.uid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      map['uid'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) => Contact.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Contact(uid: $uid)';

  @override
  bool operator ==(covariant Contact other) {
    if (identical(this, other)) return true;
  
    return 
      other.uid == uid;
  }

  @override
  int get hashCode => uid.hashCode;
}
