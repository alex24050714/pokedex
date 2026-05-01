import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/pokemon.dart';

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
}