import 'package:flutter/material.dart';
import 'package:newwfirst/data/model/message.dart';

enum MessageListTileType { user, contact }

class MessageListTile extends StatelessWidget {
  final Message _message;
  final MessageListTileType _listTileType;
  const MessageListTile(this._message, this._listTileType, {super.key});

  @override
  Widget build(BuildContext context) {
    TextAlign? textAlign = null;
    if (_listTileType == MessageListTileType.contact) {
      textAlign = TextAlign.end;
    }else{
      textAlign = TextAlign.start;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        dense: true,
        title: Text(
          _message.content,
          textAlign: textAlign,
        ),
        subtitle: Text(
          _message.timestamp,
          textAlign: textAlign,
          style: TextStyle(fontSize: 10),
        ),
      ),
    );
  }
}
