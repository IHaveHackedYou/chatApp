// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uuid/uuid.dart';

class Message {
  late String messageId;
  String uidSender;
  String uidReceiver;
  String timestamp;
  String content;
  Message({
    required this.messageId,
    required this.uidSender,
    required this.uidReceiver,
    required this.timestamp,
    required this.content,
  }) {
    var uuid = Uuid();
    messageId = uuid.v1();
  }

  Message copyWith({
    String? messageId,
    String? uidSender,
    String? uidReceiver,
    String? timestamp,
    String? content,
  }) {
    return Message(
      messageId: messageId ?? this.messageId,
      uidSender: uidSender ?? this.uidSender,
      uidReceiver: uidReceiver ?? this.uidReceiver,
      timestamp: timestamp ?? this.timestamp,
      content: content ?? this.content,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'messageId': messageId,
      'uidSender': uidSender,
      'uidReceiver': uidReceiver,
      'timestamp': timestamp,
      'content': content,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      messageId: map['messageId'] as String,
      uidSender: map['uidSender'] as String,
      uidReceiver: map['uidReceiver'] as String,
      timestamp: map['timestamp'] as String,
      content: map['content'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Message(messageId: $messageId, uidSender: $uidSender, uidReceiver: $uidReceiver, timestamp: $timestamp, content: $content)';
  }

  @override
  bool operator ==(covariant Message other) {
    if (identical(this, other)) return true;
  
    return 
      other.messageId == messageId &&
      other.uidSender == uidSender &&
      other.uidReceiver == uidReceiver &&
      other.timestamp == timestamp &&
      other.content == content;
  }

  @override
  int get hashCode {
    return messageId.hashCode ^
      uidSender.hashCode ^
      uidReceiver.hashCode ^
      timestamp.hashCode ^
      content.hashCode;
  }
}
