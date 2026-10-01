/// Maps a measured extent onto a size that grows between two anchors and
/// holds steady outside them, so one layout reads the same from a small
/// phone to a tablet.
class FluidRange {
  final double from;
  final double to;

  const FluidRange(this.from, this.to) : assert(from < to);

  double progress(double extent) =>
      ((extent - from) / (to - from)).clamp(0.0, 1.0);

  double lerp(double extent, double min, double max) =>
      min + (max - min) * progress(extent);
}
