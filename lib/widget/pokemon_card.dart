import 'package:flutter/material.dart';
import '../model/evolutions.dart';
import '../model/pokemon.dart';
import '../widget/evolution_chain.dart';
import 'pokemon_type.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  final List<Evolutions> evolutions;
  final bool cargandoEvo;
  final bool esFavorito;
  final VoidCallback onFavoritoPressed;

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.evolutions,
    required this.cargandoEvo,
    required this.esFavorito,
    required this.onFavoritoPressed,
  });

  @override
  Widget build(BuildContext context) {
    final color = typeColors[pokemon.types.first] ?? Colors.red;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.7), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${pokemon.id}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: onFavoritoPressed,
                    icon: Icon(
                      esFavorito ? Icons.favorite : Icons.favorite_border,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  Wrap(spacing: 5, children: pokemon.types.map((t) => TypeCard(type: t)).toList()),
                ],
              ),
              Text(pokemon.formatName,
                  style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Image.network(pokemon.imageURL, height: 140, fit: BoxFit.contain),
                      const Text("Normal",
                          style: TextStyle(color: Colors.white, fontSize: 10)),
                    ],
                  ),
                  if (pokemon.imageURL_Shiny.isNotEmpty) ...[
                    const SizedBox(width: 20),
                    Column(
                      children: [
                        Image.network(pokemon.imageURL_Shiny, height: 140, fit: BoxFit.contain),
                        const Text("Shiny", style: TextStyle(color: Colors.white, fontSize: 10)),
                      ],
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), borderRadius: BorderRadius.circular(15)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _stat(Icons.height, '${pokemon.height} m'),
                    _stat(Icons.scale, '${pokemon.weight} kg'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Movimientos",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: pokemon.moves.map((nombreMovimiento){
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      nombreMovimiento.replaceAll('-', ' ').toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Text('Evoluciones', style: TextStyle(fontWeight: FontWeight.bold)),
                const Divider(),
                cargandoEvo
                    ? const CircularProgressIndicator()
                    : EvolutionChainWidget(steps: evolutions),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _stat(IconData icon, String label) => Row(
    children: [Icon(
      icon, size: 18, color: Colors.grey),
      const SizedBox(width: 4),
      Text(label)],
  );
}