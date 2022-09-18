import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newwfirst/business_logic/blocs/authentication/authentication_bloc.dart';
import 'package:newwfirst/presentation/widgets/dialogs/error_dialog.dart';
import 'package:newwfirst/presentation/widgets/dialogs/loading_dialog.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationSigningIn) {
          showDialog(
              // The user CANNOT close this dialog  by pressing outsite it
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return LoadingDialog();
              });
        } else if (state is AuthenticationSignInFailed) {
          final signInFailedEvent = state as AuthenticationSignInFailed;
          Navigator.of(context, rootNavigator: true).pop();
          showDialog(
            context: context,
            builder: (context) {
              return ErrorDialog(
                  "Sign in Error", signInFailedEvent.errorMessage, () {
                Navigator.of(context).pushNamed("/signIn");
              });
            },
          );
        }
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(50),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Sign in"),
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Enter email";
                  } else if (!value.contains("@") || !value.contains(".")) {
                    return "Enter valid email";
                  } else {
                    return null;
                  }
                }),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
                obscureText: true,
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Enter password";
                  } else if (value.length < 8) {
                    return "Password must be longer than 8 characters";
                  } else {
                    return null;
                  }
                }),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: (() {
                      Navigator.of(context).pushNamed("/signIn/forgotPassword");
                    }),
                    child: Text("forgot password?"),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/signUp");
                    },
                    child: Text("Create account"),
                  ),
                  ElevatedButton(
                    child: const Text("Sign in"),
                    onPressed: (() {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthenticationBloc>().add(SignIn(
                            emailController.text, passwordController.text));
                      }
                    }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
