import 'package:animals/feature/presentation/animal_card.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isMicPermited = false;
  bool isRequestingPermission = true;

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission();
  }

  Future<void> _requestMicrophonePermission() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      isMicPermited = true;
    } else {
      isMicPermited = false;
    }

    setState(() {
      isRequestingPermission = false;
    });
  }

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

  Widget _bodyLoading() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Animals For Kids',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _body() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Animals For Kids',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: Colors.white,
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
                  microphonePermission: isMicPermited,
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
    if (isRequestingPermission) {
      return _bodyLoading();
    }
    return _body();
  }
}
