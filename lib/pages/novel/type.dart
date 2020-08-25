enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

enum TransitionGoal {
  open,
  close,
}

enum UpdateType {
  dragging,
  doneDragging,
  animating,
  doneAnimating,
}

class SlideUpdate {
  final updateType;
  final direction;
  final slidePercent;

  SlideUpdate(
      this.updateType,
      this.direction,
      this.slidePercent,
      );
}