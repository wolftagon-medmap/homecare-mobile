class DashboardLayout {
  const DashboardLayout._();

  static const maxContentWidth = 1100.0;
  static const minTapTarget = 48.0;
  static const gridGap = 10.0;
  static const minColumns = 3;
  static const maxColumns = 5;
  static const _minCardWidth = 120.0;

  static double cardWidthFor(double width, int columns) =>
      (width - gridGap * (columns - 1)) / columns;

  static int columnsFor(double width, int itemCount) {
    for (var columns = maxColumns; columns > minColumns; columns--) {
      final roomy = cardWidthFor(width, columns) >= _minCardWidth;
      if (roomy && itemCount % columns != 1) return columns;
    }
    return minColumns;
  }
}
