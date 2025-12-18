enum PhysiotherapyType {
  musculoskeletal,
  neurological;

  String get label {
    switch (this) {
      case PhysiotherapyType.musculoskeletal:
        return 'Musculoskeletal Physiotherapy';
      case PhysiotherapyType.neurological:
        return 'Neurological Physiotherapy';
    }
  }
}
