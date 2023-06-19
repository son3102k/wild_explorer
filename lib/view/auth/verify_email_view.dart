import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wild_explorer/extensions/buildcontext/loc.dart';

import '../../services/auth/bloc/auth_bloc.dart';
import '../../services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            top: 50,
            left: 30,
            right: 30,
          ),
          child: Column(
            children: [
              Text(
                context.loc.verify_email,
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                context.loc.verify_email_view_prompt,
                style: TextStyle(
                  fontFamily: 'Rubik',
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  fixedSize: const Size(double.maxFinite, 50),
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  textStyle: const TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  context.read<AuthBloc>().add(
                        const AuthEventSendEmailVerification(),
                      );
                },
                child: Text(context.loc.verify_email_send_email_verification),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: const Color.fromRGBO(199, 57, 249, 1),
                  ),
                  child: TextButton.icon(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30,
                    ),
                    label: const Text(''),
                    onPressed: () async {
                      context.read<AuthBloc>().add(
                            const AuthEventLogOut(),
                          );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
