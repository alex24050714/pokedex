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
  bool cargando = false;
  bool cargandoEvo = false;
  String? _errorMessage;
  List<Evolutions> _evo = [];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> busqueda() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    FocusScope.of(context).unfocus();

    setState(() {
      cargando = true;
      _errorMessage = null;
      _pokemon = null;
      _evo = [];
    });

    try {
      final pokemon = await _service.fetchPokemon(query);
      setState(() {
        _pokemon = pokemon;
        cargando = false;
        cargandoEvo = true;
      });

      final steps = await _service.fetchEvolutionChain(pokemon.id);
      setState(() {
        _evo = steps;
        cargandoEvo = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Pokédex',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchBar(),
            const SizedBox(height: 24),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 14),
            child: Icon(Icons.search, color: Colors.grey),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Nombre o número...',
                border: InputBorder.none,
                contentPadding:
                EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              ),
              onSubmitted: (_) => busqueda(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(6),
            child: ElevatedButton(
              onPressed: cargando ? null : busqueda,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 18, vertical: 12),
              ),
              child: const Text(
                'Buscar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (cargando) {
      return const Padding(
        padding: EdgeInsets.only(top: 80),
        child: CircularProgressIndicator(color: Colors.red),
      );
    }

    if (_errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Icon(Icons.sentiment_dissatisfied,
                size: 60, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              _errorMessage!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
      );
    }

    final pokemon = _pokemon;
    if (pokemon != null) {
      return PokemonCard(
        pokemon: pokemon,
        evolutions: _evo,
        loadingEvolution: cargandoEvo,
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Icon(Icons.catching_pokemon,
              size: 90, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Introduce un Pokémon para empezar',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}