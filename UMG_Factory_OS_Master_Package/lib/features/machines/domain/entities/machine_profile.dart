final class MachineProfile {
  final String name;
  final String department;
  final String model;
  final String? manufacturer;
  final String? operationType;
  final String? notes;

  const MachineProfile({
    required this.name,
    required this.department,
    required this.model,
    this.manufacturer,
    this.operationType,
    this.notes,
  });
}
