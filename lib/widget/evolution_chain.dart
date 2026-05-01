import 'package:flutter/material.dart';
import '../model/evolutions.dart';

class EvolutionChainWidget extends StatelessWidget {
  final List<Evolutions> steps;

  const EvolutionChainWidget({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    if (steps.length <= 1) {
      return const Padding(
        padding: EdgeInsets.only(top: 8),
        child: Text(
          'Este Pokémon no evoluciona',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            _buildStep(steps[i]),
            if (i < steps.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Icon(Icons.arrow_forward_ios,
                    size: 16, color: Colors.grey),
              ),
          ]
        ],
      ),
    );
  }
  Widget _buildStep(Evolutions evo) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(4),
          child: Image.network(
            evo.imageURL,
            height: 70,
            width: 70,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
            const Icon(Icons.catching_pokemon, size: 40),
          ),
        ),
        const SizedBox(height: 4),
        Text(evo.name,
        style: const TextStyle(fontSize: 11,fontWeight: FontWeight.normal),
        ),
      ],
    );
  }
}
