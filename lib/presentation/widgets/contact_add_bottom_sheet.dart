import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newwfirst/business_logic/blocs/authentication/authentication_bloc.dart';
import 'package:newwfirst/business_logic/cubits/contact/contact_cubit.dart';
import 'package:newwfirst/data/model/contact.dart';
import 'package:newwfirst/presentation/widgets/dialogs/error_dialog.dart';
import 'package:newwfirst/presentation/widgets/dialogs/loading_dialog.dart';
import 'package:provider/provider.dart';

class ContactAddBottomSheet extends StatelessWidget {
  const ContactAddBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: BlocListener<ContactCubit, ContactState>(
          listener: (context, state) {
            if(state is ContactsAdding){
              showDialog(
              // The user CANNOT close this dialog  by pressing outsite it
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return LoadingDialog();
              });
            }
            else if(state is ContactsAddingFailed){
              final event = state as ContactsAddingFailed;
              Navigator.pop(context);
              showDialog(
            context: context,
            builder: (context) {
              return ErrorDialog(
                  "Add Contact error", event.errorMessage, () {
                Navigator.pop(context);
              });
            },
          );
            }else if(state is ContactsAdded){
              Navigator.pop(context);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text("To: "),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(child: TextField(
                    onSubmitted: (value) {
                      Provider.of<ContactCubit>(context, listen: false)
                          .addContact(Contact(value, 0));
                      Navigator.pop(context);
                    },
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
