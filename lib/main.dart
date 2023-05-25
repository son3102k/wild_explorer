import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wild_explorer/extensions/buildcontext/loc.dart';
import 'package:wild_explorer/navigation_home_screen.dart';
import 'package:wild_explorer/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wild_explorer/services/auth/bloc/auth_event.dart';
import 'package:wild_explorer/services/auth/bloc/auth_state.dart';
import 'package:wild_explorer/services/auth/firebase_auth_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wild_explorer/services/openai/openai_model_provider.dart';
import 'package:wild_explorer/view/auth/forgot_password_view.dart';
import 'package:wild_explorer/view/auth/login_view.dart';
import 'package:wild_explorer/view/auth/register_view.dart';
import 'package:wild_explorer/view/auth/verify_email_view.dart';
import 'helpers/loading/loading_screen.dart';
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold();
//   }
// }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => OpenAIModelProvider(),
        ),
      ],
      child: MaterialApp(
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        title: 'Wild Explorer',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(FirebaseAuthProvider()),
          child: const HomePage(),
        ),
        routes: {},
      ),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventIntialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LoadingScreen().show(
            context: context,
            text: state.loadingText ?? context.loc.wait_a_moment,
          );
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return NavigationHomeScreen();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateForgotPassword) {
          return const ForgotPasswordView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
