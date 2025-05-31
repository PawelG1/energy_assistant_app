import 'package:flutter/material.dart';

enum ProductType { panel, inverter, battery, monitoring }

class HitachiProduct {
  final ProductType type;
  final String name;
  final double? power;
  final double price;
  final double? efficiency;
  final double? capacity;
  final int? cycles;
  final List<String> features;
  final String imageUrl;
  final String category;
  final Color color;

  const HitachiProduct({
    required this.type,
    required this.name,
    this.power,
    required this.price,
    this.efficiency,
    this.capacity,
    this.cycles,
    required this.features,
    required this.imageUrl,
    required this.category,
    required this.color,
  });

  HitachiProduct copyWith({
    ProductType? type,
    String? name,
    double? power,
    double? price,
    double? efficiency,
    double? capacity,
    int? cycles,
    List<String>? features,
    String? imageUrl,
    String? category,
    Color? color,
  }) {
    return HitachiProduct(
      type: type ?? this.type,
      name: name ?? this.name,
      power: power ?? this.power,
      price: price ?? this.price,
      efficiency: efficiency ?? this.efficiency,
      capacity: capacity ?? this.capacity,
      cycles: cycles ?? this.cycles,
      features: features ?? this.features,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      color: color ?? this.color,
    );
  }
}