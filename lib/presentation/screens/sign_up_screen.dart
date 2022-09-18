import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newwfirst/business_logic/blocs/authentication/authentication_bloc.dart';
import 'package:newwfirst/presentation/widgets/dialogs/error_dialog.dart';
import 'package:newwfirst/presentation/widgets/dialogs/loading_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthenticationSigningUp) {
          showDialog(
              // The user CANNOT close this dialog  by pressing outsite it
              barrierDismissible: false,
              context: context,
              builder: (_) {
                return LoadingDialog();
              });
        } else if (state is AuthenticationSignUpFailed) {
          final signUpFailedEvent = state as AuthenticationSignUpFailed;
          Navigator.of(context, rootNavigator: true).pop();
          showDialog(
            context: context,
            builder: (context) {
              return ErrorDialog(
                  "Sign up Error", signUpFailedEvent.errorMessage, () {
                Navigator.of(context).pushNamed("/signUp");
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
              Text("Sign up"),
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
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed("/signIn");
                    },
                    child: Text("Already have an account?"),
                  ),
                  ElevatedButton(
                    child: const Text("Sign up"),
                    onPressed: (() {
                      if (formKey.currentState!.validate()) {
                        context.read<AuthenticationBloc>().add(SignUp(
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
