class DashboardLayout {
  const DashboardLayout._();

  static const maxContentWidth = 1100.0;
  static const minTapTarget = 48.0;
  static const _minColumns = 3;

  static int columnsFor(double width, int itemCount) {
    final widest = width >= 900 ? 5 : (width >= 600 ? 4 : _minColumns);
    for (var columns = widest; columns > _minColumns; columns--) {
      if (itemCount % columns != 1) return columns;
    }
    return _minColumns;
  }
}
