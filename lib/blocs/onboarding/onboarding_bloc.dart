import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_maimaid_app/blocs/onboarding/onboarding_event.dart';
import 'package:test_maimaid_app/blocs/onboarding/onboarding_state.dart';
import 'package:test_maimaid_app/models/slide_data.dart';

class SlideBloc extends Bloc<SlideEvent, SlideState> {
  SlideBloc() : super(SlideInitial()) {
    on<NextSlide>((event, emit) {
      final newIndex = (state.currentIndex + 1) % slides.length;
      emit(SlideChanged(newIndex));
    });

    on<PrevSlide>((event, emit) {
      final newIndex = (state.currentIndex - 1 + slides.length) % slides.length;
      emit(SlideChanged(newIndex));
    });

    on<AutoPlaySlide>((event, emit) async {
      while (state.currentIndex < slides.length - 1) {
        await Future.delayed(const Duration(seconds: 5));
        final newIndex = (state.currentIndex + 1) % slides.length;
        emit(SlideChanged(newIndex));
      }
    });
  }
}
