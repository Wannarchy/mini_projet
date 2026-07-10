import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../api_config.dart';
import 'login_screen.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<dynamic> _produits = [];
  String _prenom = '';
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _chargerDonnees();
  }

  Future<void> _chargerDonnees() async {
    final prefs = await SharedPreferences.getInstance();
    final prenom = prefs.getString('user_prenom') ?? '';

    setState(() {
      _prenom = prenom;
    });

    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/api/produits'));

      if (response.statusCode == 200) {
        final List<dynamic> produits = jsonDecode(response.body);
        setState(() {
          _produits = produits;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Erreur lors du chargement des produits';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Impossible de contacter le serveur';
        _isLoading = false;
      });
    }
  }

  Future<void> _seDeconnecter() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('user_nom');
    await prefs.remove('user_prenom');

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bonjour $_prenom'),
        actions: [
          IconButton(
            onPressed: _seDeconnecter,
            icon: const Icon(Icons.logout),
            tooltip: 'Se déconnecter',
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!));
    }

    if (_produits.isEmpty) {
      return const Center(child: Text('Aucun produit disponible'));
    }

    return ListView.builder(
      itemCount: _produits.length,
      itemBuilder: (context, index) {
        final produit = _produits[index];

        return ListTile(
          leading: Image.network(
            produit['image'],
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(produit['titre']),
          subtitle: Text('${produit['prix']} €'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(produit: produit),
              ),
            );
          },
        );
      },
    );
  }
}
