import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newwfirst/business_logic/blocs/authentication/authentication_bloc.dart';
import 'package:newwfirst/business_logic/cubits/contact/contact_cubit.dart';
import 'package:newwfirst/data/model/contact.dart';
import 'package:newwfirst/presentation/widgets/app_bar.dart';
import 'package:newwfirst/presentation/widgets/contact_add_bottom_sheet.dart';
import 'package:newwfirst/presentation/widgets/contact_list_tile.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  ContactCubit? _cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContactCubit(),
      child: Scaffold(
        body: Column(
          children: [
            BlocBuilder<ContactCubit, ContactState>(
              builder: (context, state) {
                _cubit = BlocProvider.of<ContactCubit>(context);
                List<Contact> contacts = _cubit!.contacts;
                // return Text("fd");
                return BlocProvider.value(
                  value: _cubit!,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      return ContactListTile(contacts[index]);
                    },
                  ),
                );
              },
            )
          ],
        ),
        appBar: HomeAppBar("hello", false),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.message),
          onPressed: (() {
            showModalBottomSheet(
              useRootNavigator: false,
              isScrollControlled: true,
              context: context,
              builder: (context) {
                return BlocProvider.value(
                  value: _cubit!,
                  child: ContactAddBottomSheet(),
                );
              },
            );
          }),
          label: Text("start chat"),
        ),
      ),
    );
  }
}
