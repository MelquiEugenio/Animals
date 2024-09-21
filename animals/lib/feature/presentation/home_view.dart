import 'package:animals/feature/presentation/animal_card.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final List<String> animalsNames = [
    'african-grey-parrot',
    'alligator',
    'alpaca',
    'anteater',
    'antelope',
    'ape',
    'bat',
    'bee',
    'bowhead-whale',
    'butterfly',
    'cat',
    'chicken',
    'cow',
    'dinosaur',
    'dog',
    'dove',
    'elephant',
    'falcon',
    'ferret',
    'frog',
    'giraffe',
    'guinea-pig',
    'hedgehog',
    'hippopotamus',
    'horse',
    'humpback-whale',
    'hyena',
    'komodo-dragon',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animals'),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
        itemCount: animalsNames.length,
        itemBuilder: (context, index) {
          return AnimalCard(
            imageAsset: 'assets/images/${animalsNames[index]}.png',
            soundAsset: 'sounds/${animalsNames[index]}.mp3',
          );
        },
      ),
    );
  }
}
