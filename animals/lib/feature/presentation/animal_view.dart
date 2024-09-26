import 'package:animals/feature/presentation/animal_card.dart';
import 'package:flutter/material.dart';

class AnimalView extends StatefulWidget {

  const AnimalView({super.key});

  @override
  _AnimalViewState createState() => _AnimalViewState();
}

class _AnimalViewState extends State<AnimalView> {

  final List<String> animalsNames = [
    'african gray parrot',
    'alligator',
    'alpaca',
    'anteater',
    'antelope',
    'ape',
    'bat',
    'bee',
    'bowhead whale',
    'butterfly',
    'cat',
    'chicken',
    'cow',
    'dinosaur',
    'dog',
    'dove',
    'duck',
    'elephant',
    'falcon',
    'ferret',
    'frog',
    'giraffe',
    'guinea pig',
    'hedgehog',
    'hippopotamus',
    'horse',
    'humpback whale',
    'hyena',
    'komodo dragon',
    'leopard',
    'lion',
    'lizard',
    'moose',
    'otter',
    'owl',
    'panda',
    'penguin',
    'pig',
    'rabbit',
    'raccoon',
    'rat',
    'rattlesnake',
    'rhinoceros',
    'robin',
    'rooster',
    'scorpion',
    'shark',
    'sheep',
    'swan',
    'tiger',
    'turkey',
    'wolf',
    'yak',
    'zebra',
  ];

  Widget _body() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF282b30),
        title: const Text(
          'Animais em Inglês',
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
              itemCount: animalsNames.length,
              itemBuilder: (context, index) {
                return AnimalCard(
                  animalName: animalsNames[index],
                  imageAsset: 'assets/images/${animalsNames[index]}.png',
                  soundAsset: 'sounds/${animalsNames[index]}.mp3',
                  animalNameSoundAsset: 'sounds/${animalsNames[index]}.wav',
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
