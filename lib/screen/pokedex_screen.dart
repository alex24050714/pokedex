import 'package:flutter/material.dart';
import '../model/pokemon.dart';
import '../service/pokemon_service.dart';
import '../widget/pokemon_card.dart';

class PokedexScreen extends StatefulWidget{
  const PokedexScreen({super.key});

  @override
  State<PokedexScreen> createState() => _PokedexScreen();
  }

  class _PokedexScreen extends State<PokedexScreen> {
    final TextEditingController _control = TextEditingController();
    final PokemonService _service = PokemonService();

    Pokemon? _pokemon;
    bool cargando = false;
    String? _errorMessage;

    @override
    void dispose() {
      _control.dispose();
      super.dispose();
    }

    Future<void> busqueda() async {
      final query = _control.text.trim();
      if (query.isEmpty) return;

      FocusScope.of(context).unfocus();

      setState(() {
        cargando = true;
        _errorMessage = null;
        _pokemon = null;
      });

      try {
        final pokemon = await _service.fetchPokemon(query);
        setState(() => _pokemon = pokemon);
      } catch (e) {
        setState(() =>
        _errorMessage = e.toString().replaceFirst('Exception: ', ''));
      } finally {
        setState(() => cargando = false);
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          title: const Text('Pokedex', style: TextStyle(fontWeight: FontWeight.bold)),
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
    Widget _buildSearchBar(){
      return Row(
        children: [
          Expanded(
            child: TextField(
              controller: _control,
              decoration: InputDecoration(
                hintText: 'Nombre o numero del pokemon',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: (_) => busqueda(),
            ),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: cargando ? null: busqueda,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            ),
            child: const Text('Buscar'),
          ),
        ],
      );
    }

    Widget _buildBody(){
      if(cargando){
        return const CircularProgressIndicator(color: Colors.red);
      }
      if(_errorMessage != null){
        return Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 60),
            const SizedBox(height: 12),
            Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
          ],
        );
      }
      if(_pokemon != null){
        return PokemonCard(pokemon: _pokemon!);
      }
      return Column(
        children: [
          const SizedBox(height: 60),
          Icon(Icons.catching_pokemon, size: 80, color: Colors.grey),
          const SizedBox(height: 12),
          Text('Busca un Pokemon para comenzar!', style: TextStyle(color: Colors.grey)),
        ],
      );
    }
  }