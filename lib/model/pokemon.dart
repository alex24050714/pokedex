class Pokemon {
  final int id;
  final String name;
  final List<String> types;
  final double height;
  final double weight;
  final String imageURL;
  //final String imageURL_Mega
  //final String imageURL_Shiny

  Pokemon({
    required this.id,
    required this.name,
    required this.types,
    required this.height,
    required this.weight,
    required this.imageURL,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json){
    final List<String> types = (json['types'] as List).map((t) => t['type']['name'] as String).toList();

    final sprites = json['sprites'];
    final String imageURL = sprites['other']['official-artwork']['front_default'] ?? sprites['front_default'] ?? '';

    return Pokemon(
        id: json['id'] as int,
        name: json['name'] as String,
        types: types,
        height: (json['height'] as int) / 10,
        weight: (json['weight'] as int) / 10,
        imageURL:imageURL
    );
  }

}