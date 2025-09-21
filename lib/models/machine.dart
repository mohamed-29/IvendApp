
class Machine {
  final int id;
  final String name;
  final String machineNumber;
  final bool isOnline;
  final String temperature;
  final String lastUpdate;

  Machine({
    required this.id,
    required this.name,
    required this.machineNumber,
    required this.isOnline,
    required this.temperature,
    required this.lastUpdate,
  });

  factory Machine.fromJson(Map<String, dynamic> json) {
    return Machine(
      id: json['id'],
      name: json['name'],
      machineNumber: json['machine_number'],
      isOnline: json['is_online'],
      temperature: json['temperature'],
      lastUpdate: json['last_update'],
    );
  }
}
