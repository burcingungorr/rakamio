class MediaModel {
  final String image; // normal image
  final String objectImage; // elma görseli
  final String? audio;
  final String number;

  MediaModel({
    required this.image,
    required this.objectImage,
    this.audio,
    required this.number,
  });
}

class MediaData {
  static final List<MediaModel> mediaList = [
    MediaModel(
      image: 'assets/sifir.jpg',
      objectImage: 'assets/0elma.jpg',
      audio: 'sifir.mp3',
      number: '0',
    ),
    MediaModel(
      image: 'assets/bir.jpg',
      objectImage: 'assets/1elma.jpg',
      audio: 'bir.mp3',
      number: '1',
    ),
    MediaModel(
      image: 'assets/iki.jpg',
      objectImage: 'assets/2elma.jpg',
      audio: 'iki.mp3',
      number: '2',
    ),
    MediaModel(
      image: 'assets/uc.jpg',
      objectImage: 'assets/3elma.jpg',
      audio: 'uc.mp3',
      number: '3',
    ),
    MediaModel(
      image: 'assets/dort.jpg',
      objectImage: 'assets/4elma.jpg',
      audio: 'dort.mp3',
      number: '4',
    ),
    MediaModel(
      image: 'assets/bes.jpg',
      objectImage: 'assets/5elma.jpg',
      audio: 'bes.mp3',
      number: '5',
    ),
    MediaModel(
      image: 'assets/alti.jpg',
      objectImage: 'assets/6elma.jpg',
      audio: 'alti.mp3',
      number: '6',
    ),
    MediaModel(
      image: 'assets/yedi.jpg',
      objectImage: 'assets/7elma.jpg',
      audio: 'yedi.mp3',
      number: '7',
    ),
    MediaModel(
      image: 'assets/sekiz.jpg',
      objectImage: 'assets/8elma.jpg',
      audio: 'sekiz.mp3',
      number: '8',
    ),
    MediaModel(
      image: 'assets/dokuz.jpg',
      objectImage: 'assets/9elma.jpg',
      audio: 'dokuz.mp3',
      number: '9',
    ),
  ];

  static final List<MediaModel> mediaListWithoutAudio = [
    MediaModel(
      image: 'assets/sifir.jpg',
      objectImage: 'assets/0elma.jpg',
      number: '0',
    ),
    MediaModel(
      image: 'assets/bir.jpg',
      objectImage: 'assets/1elma.jpg',
      number: '1',
    ),
    MediaModel(
      image: 'assets/iki.jpg',
      objectImage: 'assets/2elma.jpg',
      number: '2',
    ),
    MediaModel(
      image: 'assets/uc.jpg',
      objectImage: 'assets/3elma.jpg',
      number: '3',
    ),
    MediaModel(
      image: 'assets/dort.jpg',
      objectImage: 'assets/4elma.jpg',
      number: '4',
    ),
    MediaModel(
      image: 'assets/bes.jpg',
      objectImage: 'assets/5elma.jpg',
      number: '5',
    ),
    MediaModel(
      image: 'assets/alti.jpg',
      objectImage: 'assets/6elma.jpg',
      number: '6',
    ),
    MediaModel(
      image: 'assets/yedi.jpg',
      objectImage: 'assets/7elma.jpg',
      number: '7',
    ),
    MediaModel(
      image: 'assets/sekiz.jpg',
      objectImage: 'assets/8elma.jpg',
      number: '8',
    ),
    MediaModel(
      image: 'assets/dokuz.jpg',
      objectImage: 'assets/9elma.jpg',
      number: '9',
    ),
  ];
}
