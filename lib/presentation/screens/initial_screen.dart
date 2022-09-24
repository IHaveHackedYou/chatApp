import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newwfirst/business_logic/blocs/authentication/authentication_bloc.dart';
import 'package:provider/provider.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
            Provider.of<AuthenticationBloc>(context, listen: false).add(TryAutoSignIn());

    return Scaffold(
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationInitial) {
          Navigator.of(context).pushNamed("/");
        } else if (state is AuthenticationSignedIn) {
          Navigator.of(context).pushNamed("/home");
        } 
      },
      child: Scaffold(
        body: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: (() {
                    Navigator.of(context).pushNamed("/signIn");
                  }),
                  child: Text("Sign in")),
              ElevatedButton(
                  onPressed: (() {
                    Navigator.of(context).pushNamed("/signUp");
                  }),
                  child: Text("Sign up")),
            ],
          ),
        ),
      ),
    ));
  }
}
