abstract class SlideState {
  final int currentIndex;
  SlideState(this.currentIndex);
}

class SlideInitial extends SlideState {
  SlideInitial() : super(0);
}

class SlideChanged extends SlideState {
  SlideChanged(int index) : super(index);
}
