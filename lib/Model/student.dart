class Student {
  final String name, location;
  final int roll_no;

  Student({
    required this.name,
    required this.roll_no,
    required this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'roll_no': roll_no,
      'location': location,
    };
  }
}
