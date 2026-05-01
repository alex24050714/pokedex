class Pokemon {
  final int id;
  final String name;
  final List<String> types;
  final double height;
  final double weight;
  final String imageURL;
  final String imageURL_Shiny;
  final List<String> moves;

  Pokemon({
    required this.id,
    required this.name,
    required this.types,
    required this.height,
    required this.weight,
    required this.imageURL,
    required this.imageURL_Shiny,
    required this.moves,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json){
    final List<String> types = (json['types'] as List).map((t) => t['type']['name'] as String).toList();

    final sprites = json['sprites'];
    final officialArtwork = sprites['other']['official-artwork'];
    final String imageURL = officialArtwork['front_default'] ?? '';
    final String imageURLShiny = officialArtwork['front_shiny'] ?? '';

    final List<String> moves = (json['moves'] as List).take(4).map((m) => m['move']['name'] as String).toList();
    return Pokemon(
        id: json['id'] as int,
        name: json['name'] as String,
        types: types,
        height: (json['height'] as int) / 10,
        weight: (json['weight'] as int) / 10,
        imageURL: imageURL,
        imageURL_Shiny: imageURLShiny,
      moves: moves,
    );
  }
  String get formatName => name[0].toUpperCase() + name.substring(1);
}