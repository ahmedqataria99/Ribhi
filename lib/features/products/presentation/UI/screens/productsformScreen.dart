import 'package:flutter/material.dart';
import 'package:ribhi/features/products/domain/entities/products.dart';

class Productsformscreen extends StatelessWidget{
  final Product? product;

  const Productsformscreen({super.key, this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Form"),
      ),
      body: Center(
        child: Text("Product Form Screen"),
      ),
    );
  }
}