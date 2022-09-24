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
    Color? boxColor = null;
    if (_listTileType == MessageListTileType.contact) {
      textAlign = TextAlign.start;
      boxColor = Color.fromARGB(255, 255, 0, 0);
    } else {
      textAlign = TextAlign.end;
            boxColor = Color.fromARGB(110, 182, 182, 182);

    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), color: boxColor),
        child: ListTile(
          dense: true,
          title: Text(
            _message.content,
            textAlign: textAlign,
            maxLines: 50,
          ),
          subtitle: Text(
            _message.timestamp,
            textAlign: textAlign,
            style: TextStyle(fontSize: 10),
          ),
        ),
      ),
    );
  }
}
