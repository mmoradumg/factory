enum EmployeeStatus { active, inactive, suspended }

final class Employee {
  final String employeeId;
  final String fullName;
  final EmployeeStatus status;

  const Employee({
    required this.employeeId,
    required this.fullName,
    this.status = EmployeeStatus.active,
  });
}
