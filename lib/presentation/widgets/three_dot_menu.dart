import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newwfirst/business_logic/blocs/authentication/authentication_bloc.dart';

enum Menu { settings, logOut }

class ThreeDotMenu extends StatelessWidget {
  const ThreeDotMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (Menu item) {
        if(item.name == "settings"){
          Navigator.of(context).pushNamed("/home/settings");
        }else if(item.name == "logOut"){
          context.read<AuthenticationBloc>().add(SignOut());
        }
      },
        itemBuilder: ((context) => <PopupMenuEntry<Menu>>[
              PopupMenuItem<Menu>(value: Menu.settings, child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Settings"),
                  Icon(Icons.settings),
                ],
              )),
              PopupMenuItem<Menu>(value: Menu.logOut, child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Log out"),
                  Icon(Icons.logout),
                ],
              )),
            ]));
  }
}
