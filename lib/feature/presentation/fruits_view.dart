import 'package:animals/feature/presentation/fruit_card.dart';
import 'package:flutter/material.dart';

class FruitView extends StatefulWidget {
  const FruitView({super.key});

  @override
  _FruitViewState createState() => _FruitViewState();
}

class _FruitViewState extends State<FruitView> {

  List<String> fruitsNames = [
    'apple',
    'avocado',
    'banana',
    'cherry',
    'dragonfruit',
    'grape',
    'kiwi',
    'lemon',
    'mango',
    'mangosteen',
    'orange',
    'papaya',
    'pineapple',
    'pomegranate',
    'strawberry',
    'watermelon',
  ];

  Widget _body() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF282b30),
        title: const Text(
          'Frutas em Inglês',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: const Color(0xFF282b30),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: fruitsNames.length,
              itemBuilder: (context, index) {
                return FruitCard(
                  fruitName: fruitsNames[index],
                  imageAsset: 'assets/images/fruits/${fruitsNames[index]}.png',
                  fruitNameSoundAsset: 'sounds/fruits/${fruitsNames[index]}.wav',
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }
}
