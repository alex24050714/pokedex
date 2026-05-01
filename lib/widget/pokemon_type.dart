import 'package:flutter/material.dart';

const Map<String, Color> typeColors = {
  'normal': Color(0xFF999999),
  'fire': Color(0xFFC30000),
  'water': Color(0xFF3C40DB),
  'grass': Color(0xFF005D03),
  'electric': Color(0xFFF8D030),
  'ice': Color(0xFF98D8D8),
  'fighting': Color(0xFFB13C29),
  'poison': Color(0xFF8A1CFD),
  'ground': Color(0xFFDB9A5A),
  'flying': Color(0xFF5E87B4),
  'psychic': Color(0xFFF85888),
  'bug': Color(0xFFA8B820),
  'rock': Color(0xFF837641),
  'ghost': Color(0xFF705898),
  'dragon': Color(0xFF503CFF),
  'steel': Color(0xFFB8B8D0),
  'fairy': Color(0xFFEE99AC),
};

class TypeCard extends StatelessWidget{
  final String type;

  const TypeCard({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final color = typeColors[type] ?? Colors.grey;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(type[0].toUpperCase() + type.substring(1),
      style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}