class Character {
  final String name;
  final String status;
  final String species;
  final String gender;
  final String origin;
  final String image;
  final String created;

  const Character({
    required this.name,
    required this.status,
    required this.species,
    required this.gender,
    required this.origin,
    required this.image,
    required this.created,
  });

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      name: json['name'] as String,
      status: json['status'] as String,
      species: json['species'] as String,
      gender: json['gender'] as String,
      origin: json['origin'] as String,
      image: json['image'] as String,
      created: json['created'] as String,
    );
  }
}
