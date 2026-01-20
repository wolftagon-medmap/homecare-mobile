enum ButtonSize {
  small,
  medium,
  large;

  double get fontSize {
    switch (this) {
      case ButtonSize.small:
        return 14.0;
      case ButtonSize.medium:
        return 16.0;
      case ButtonSize.large:
        return 18.0;
    }
  }

  double get height {
    switch (this) {
      case ButtonSize.small:
        return 40.0;
      case ButtonSize.medium:
        return 50.0;
      case ButtonSize.large:
        return 60.0;
    }
  }

  double get iconSize {
    switch (this) {
      case ButtonSize.small:
        return 16.0;
      case ButtonSize.medium:
        return 20.0;
      case ButtonSize.large:
        return 24.0;
    }
  }
}
