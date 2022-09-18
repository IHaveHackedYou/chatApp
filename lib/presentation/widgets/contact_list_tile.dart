import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:newwfirst/business_logic/cubits/contact/contact_cubit.dart';
import 'package:newwfirst/data/model/contact.dart';
import 'package:provider/provider.dart';

class ContactListTile extends StatelessWidget {
  final Contact _contact;
  const ContactListTile(this._contact, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.account_circle),
      title: Text(_contact.uid),
      trailing: GestureDetector(
        onTap:() {
          Provider.of<ContactCubit>(context, listen: false).removeContact(_contact);
        },
        child: Icon(Icons.delete)
        ),
      onTap: () {
        Navigator.of(context).pushNamed("/home/chat", arguments: _contact);
      },
    );
  }
}