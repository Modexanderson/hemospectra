class Patient {
  final int id;
  final String fullName;
  final DateTime dateOfBirth;
  final String gender;
  final String country;
  final String state;
  final String role;

  Patient({
    required this.id,
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.country,
    required this.state,
    required this.role,
  });
}
