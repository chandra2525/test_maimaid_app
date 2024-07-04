import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_maimaid_app/blocs/onboarding/onboarding_bloc.dart';
import 'package:test_maimaid_app/blocs/onboarding/onboarding_event.dart';
import 'package:test_maimaid_app/constants/color.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
            builder: (context) => BlocProvider(
                create: (context) => SlideBloc()..add(AutoPlaySlide()),
                child: OnboardingScreen())),
      );
    });

    return Scaffold(
      backgroundColor: white,
      body: Center(
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}
