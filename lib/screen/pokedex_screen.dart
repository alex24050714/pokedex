import 'package:flutter/material.dart';
import '../model/pokemon.dart';
import '../model/evolutions.dart';
import '../service/pokemon_service.dart';
import '../widget/pokemon_card.dart';

class PokedexScreen extends StatefulWidget {
  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreen();
}

class _PokedexScreen extends State<PokedexScreen> {
  final TextEditingController _controller = TextEditingController();
  final PokemonService _service = PokemonService();

  Pokemon? _pokemon;
  List<Evolutions> _evo = [];
  bool cargando = false;
  String? _error;

  List<String> historial = [];
  List<String> favoritos = [];

  void _buscar() async {
    if (_controller.text.isEmpty) return;
    setState(() {
      cargando = true;
      _error = null;
    });

    try {
      final p = await _service.fetchPokemon(_controller.text.trim());
      if(!historial.contains(p.formatName)){
        setState(() {
          historial.insert(0, p.formatName);
        });
      }
      setState(() {
        _pokemon = p;
      });
      final e = await _service.fetchEvolutionChain(p.id);
      setState(() {
        _evo = e;
        cargando = false;
      });
    } catch (e) {
      setState(() {
        _error = "No encontrado";
        cargando = false;
        _pokemon = null;
      });
    }
  }

  void _favoritos(String nombre) {
    setState(() {
      if(favoritos.contains(nombre)){
        favoritos.remove(nombre);
      }
      else{
        favoritos.add(nombre);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        actions: [
          Padding(padding: const EdgeInsets.only(right: 15),
          child: Row(
            children: [
              const Icon(Icons.favorite, size: 20),
              const SizedBox(width: 5),
              Text('${favoritos.length}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )
            ],
          )
          )
        ]),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Nombre o ID...',
                suffixIcon: IconButton(
                    onPressed: _buscar, icon: const Icon(Icons.search)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15)),
              ),
              onSubmitted: (_) => _buscar(),
            ),

            _buildHistorial(),
            const SizedBox(height: 20),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  Widget _buildHistorial() {
    if (historial.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15, left: 5, bottom: 5),
          child: Text("Recientes:", style: TextStyle(fontSize: 12, color: Colors.grey)),
        ),
        SizedBox(
          height: 35,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: historial.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ActionChip(
                  backgroundColor: Colors.white,
                  label: Text(historial[index], style: const TextStyle(fontSize: 12)),
                  onPressed: () {
                    _controller.text = historial[index];
                    _buscar();
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    if (cargando && _pokemon == null)
      return const Center(child: CircularProgressIndicator());
    if (_error != null)
      return Text(_error!,
          style: const TextStyle(color: Colors.red));
    if (_pokemon == null)
      return const Opacity(
          opacity: 0.5,
          child: Icon(Icons.catching_pokemon, size: 100));

    return PokemonCard(
      pokemon: _pokemon!,
      evolutions: _evo,
      cargandoEvo: cargando,
      esFavorito: favoritos.contains(_pokemon!.formatName),
      onFavoritoPressed: () {
        _favoritos(_pokemon!.formatName);
      },
    );
  }
}