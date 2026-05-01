import 'package:flutter/material.dart';
import '../model/evolutions.dart';
import '../model/pokemon.dart';
import '../widget/evolution_chain.dart';
import 'pokemon_type.dart';

class PokemonCard extends StatelessWidget{
  final Pokemon pokemon;
  final List<Evolutions> evolutions;
  final bool loadingEvolution;

  const PokemonCard({
    super.key,
    required this.pokemon,
    required this.evolutions,
    required this.loadingEvolution,
  });

  Color get _typeColor => typeColors[pokemon.types.first] ?? Colors.red;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMainCard(),
        const SizedBox(height: 16),
        _buildEvolutionCard(),
      ],
    );
  }

  Widget _buildMainCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _typeColor.withOpacity(0.85),
            _typeColor.withOpacity(0.5),
            Colors.white,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: _typeColor.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      pokemon.id.toString(),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.8),
                        letterSpacing: 1.5,
                      ),
                    ),
                    Wrap(
                      spacing: 6,
                      children: pokemon.types
                          .map((t) => TypeCard(type: t))
                          .toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  pokemon.formatName,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Image.network(
                    pokemon.imageURL,
                    height: 190,
                    width: 190,
                    fit: BoxFit.contain,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const SizedBox(
                        height: 190,
                        child: Center(
                          child: CircularProgressIndicator(
                              color: Colors.white),
                        ),
                      );
                    },
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.catching_pokemon,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _statItem(Icons.height, 'Altura',
                          '${pokemon.height.toStringAsFixed(1)} m'),
                      Container(
                          width: 1, height: 36, color: Colors.grey),
                      _statItem(Icons.monitor_weight_outlined, 'Peso',
                          '${pokemon.weight.toStringAsFixed(1)} kg'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvolutionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cadena evolutiva',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 16),
          if (loadingEvolution)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: CircularProgressIndicator(),
              ),
            )
          else
            Center(child: EvolutionChainWidget(steps: evolutions)),
        ],
      ),
    );
  }

  Widget _statItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 15)),
            Text(label,
                style: TextStyle(
                    color: Colors.grey, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}