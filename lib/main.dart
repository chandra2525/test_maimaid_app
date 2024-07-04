import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:test_maimaid_app/blocs/user/user_bloc.dart';
import 'package:test_maimaid_app/blocs/user/user_event.dart';
import 'package:test_maimaid_app/repositories/user_repository.dart';
import 'package:test_maimaid_app/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<UserRepository>(
          create: (context) => UserRepository(),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(
            userRepository: context.read<UserRepository>(),
          )..add(FetchUsers(page: 1)),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
