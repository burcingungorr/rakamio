class MediaModel {
  final String image; 
  final String objectImage; 
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
      image: 'assets/images/sifir.jpg',
      objectImage: 'assets/images/0elma.jpg',
      audio: 'audios/sifir.mp3',
      number: '0',
    ),
    MediaModel(
      image: 'assets/images/bir.jpg',
      objectImage: 'assets/images/1elma.jpg',
      audio: 'audios/bir.mp3',
      number: '1',
    ),
    MediaModel(
      image: 'assets/images/iki.jpg',
      objectImage: 'assets/images/2elma.jpg',
      audio: 'audios/iki.mp3',
      number: '2',
    ),
    MediaModel(
      image: 'assets/images/uc.jpg',
      objectImage: 'assets/images/3elma.jpg',
      audio: 'audios/uc.mp3',
      number: '3',
    ),
    MediaModel(
      image: 'assets/images/dort.jpg',
      objectImage: 'assets/images/4elma.jpg',
      audio: 'audios/dort.mp3',
      number: '4',
    ),
    MediaModel(
      image: 'assets/images/bes.jpg',
      objectImage: 'assets/images/5elma.jpg',
      audio: 'audios/bes.mp3',
      number: '5',
    ),
    MediaModel(
      image: 'assets/images/alti.jpg',
      objectImage: 'assets/images/6elma.jpg',
      audio: 'audios/alti.mp3',
      number: '6',
    ),
    MediaModel(
      image: 'assets/images/yedi.jpg',
      objectImage: 'assets/images/7elma.jpg',
      audio: 'audios/yedi.mp3',
      number: '7',
    ),
    MediaModel(
      image: 'assets/images/sekiz.jpg',
      objectImage: 'assets/images/8elma.jpg',
      audio: 'audios/sekiz.mp3',
      number: '8',
    ),
    MediaModel(
      image: 'assets/images/dokuz.jpg',
      objectImage: 'assets/images/9elma.jpg',
      audio: 'audios/dokuz.mp3',
      number: '9',
    ),
  ];

  static final List<MediaModel> mediaListWithoutAudio = [
    MediaModel(
      image: 'assets/images/sifir.jpg',
      objectImage: 'assets/images/0elma.jpg',
      number: '0',
    ),
    MediaModel(
      image: 'assets/images/bir.jpg',
      objectImage: 'assets/images/1elma.jpg',
      number: '1',
    ),
    MediaModel(
      image: 'assets/images/iki.jpg',
      objectImage: 'assets/images/2elma.jpg',
      number: '2',
    ),
    MediaModel(
      image: 'assets/images/uc.jpg',
      objectImage: 'assets/images/3elma.jpg',
      number: '3',
    ),
    MediaModel(
      image: 'assets/images/dort.jpg',
      objectImage: 'assets/images/4elma.jpg',
      number: '4',
    ),
    MediaModel(
      image: 'assets/images/bes.jpg',
      objectImage: 'assets/images/5elma.jpg',
      number: '5',
    ),
    MediaModel(
      image: 'assets/images/alti.jpg',
      objectImage: 'assets/images/6elma.jpg',
      number: '6',
    ),
    MediaModel(
      image: 'assets/images/yedi.jpg',
      objectImage: 'assets/images/7elma.jpg',
      number: '7',
    ),
    MediaModel(
      image: 'assets/images/sekiz.jpg',
      objectImage: 'assets/images/8elma.jpg',
      number: '8',
    ),
    MediaModel(
      image: 'assets/images/dokuz.jpg',
      objectImage: 'assets/images/9elma.jpg',
      number: '9',
    ),
  ];
}
