import 'package:flutter/material.dart';
import '../model/pokemon.dart';
import 'pokemon_type.dart';

class PokemonCard extends StatelessWidget{
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          _buildHeader(),
          _buildStats(),
        ],
      ),
    );
  }

  Widget _buildHeader(){
    return Container(
      color: Colors.red,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(pokemon.id.toString(), style: const TextStyle(fontSize: 16, color: Colors.grey)),
          Image.network(pokemon.imageURL, height: 200, width: 200),
          Text(pokemon.name, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(spacing: 8,
          children: pokemon.types.map((t) => TypeCard(type: t)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(){
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _statItem('Altura', '${pokemon.height.toStringAsFixed(1)} m'),
          Container(width: 1, height: 40, color: Colors.grey),
          _statItem('Peso', '${pokemon.weight.toStringAsFixed(1)} kg'),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}