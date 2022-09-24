import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:newwfirst/business_logic/cubits/contact/contact_cubit.dart';
import 'package:newwfirst/data/model/contact.dart';
import 'package:provider/provider.dart';

class ContactListTile extends StatelessWidget {
  final Contact _contact;
  VoidCallback _setState;
  ContactListTile(this._contact, this._setState, {super.key});

  @override
  Widget build(BuildContext context) {
    Widget? _leading;
    Color? fillColor = null;
    if (_contact.newMessages == null) _contact.newMessages = 0;

    if (_contact.newMessages == 0) {
      _leading = Icon(Icons.account_circle);
    } else {
      _leading = Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.red),
        child: Center(child: Text(_contact.newMessages.toString())),
      );
      fillColor = Color.fromARGB(10, 10, 10, 255);
    }

    return ListTile(
      tileColor: fillColor,
      leading: _leading,
      title: Text(_contact.uid),
      trailing: GestureDetector(
          onTap: () {
            Provider.of<ContactCubit>(context, listen: false)
                .removeContact(_contact);
          },
          child: Icon(Icons.delete)),
      onTap: () {
        _setState();
        Navigator.of(context).pushNamed("/home/chat", arguments: _contact);
      },
    );
  }
}
