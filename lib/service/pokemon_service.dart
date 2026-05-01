import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/pokemon.dart';
import '../model/evolutions.dart';

class PokemonService {
  static const String pokeURL = 'https://pokeapi.co/api/v2';

  Future<Pokemon> fetchPokemon(String query) async {
    final String endpoint = '$pokeURL/pokemon/${query.trim().toLowerCase()}';
    
    try{
      final response = await http.get(Uri.parse(endpoint));

      if(response.statusCode == 200){
        final Map<String, dynamic> json = jsonDecode(response.body);
        return Pokemon.fromJson(json);
      }else if(response.statusCode == 404){
        throw Exception('Pokemon no encontrado!');
      }else{
        throw Exception('Error del servidor (${response.statusCode}');
      }
    }on http.ClientException {
      throw Exception('Error de red, comprueba tu connexion.');
    }catch (e){
      if(e is Exception) rethrow;
      throw Exception('Error inesperado: $e');
    }
  }

  Future<String> EvolutionChainUrl(int pokemonId) async {
    final response = await http.get(Uri.parse('$pokeURL/pokemon-species/$pokemonId'),
    );
    if(response.statusCode != 200) return '';
    final json = jsonDecode(response.body);
    return json['evolution_chain']['url'] as String;
  }

  Future<List<Evolutions>> fetchEvolutionChain (int pokemonId) async {
    try{
      final chainUrl = await EvolutionChainUrl(pokemonId);
      if(chainUrl.isEmpty) return [];

      final chainResponse = await http.get(Uri.parse(chainUrl));
      if(chainResponse.statusCode != 200) return [];

      final chainJson = jsonDecode(chainResponse.body);

      final List<String> names = [];
      var current = chainJson['chain'];
      while (current != null){
        names.add(current['species']['name'] as String);
        final evolves = current['evolves_to'] as List;
        current = evolves.isNotEmpty ? evolves[0] : null;
      }
      final List<Evolutions> steps = [];
      for(final name in names){
        final p = await fetchPokemon(name);
        steps.add(Evolutions(name: p.formatName, imageURL: p.imageURL));
      }
      return steps;
    }catch(_){
      return [];
    }
  }
}