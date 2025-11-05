class MediaModel {
  final String image;
  final String? audio;
  final String number;
  final String gif;

  MediaModel({
    required this.image,
    required this.gif,
    this.audio,
    required this.number,
  });
}

class MediaData {
  static final List<MediaModel> mediaList = [
    MediaModel(
      image: 'assets/gif/sifir.gif',
      gif: 'assets/gif/1.gif',
      audio: 'audios/sifir.mp3',
      number: '0',
    ),
    MediaModel(
      image: 'assets/gif/bir.gif',
      gif: 'assets/gif/2.gif',
      audio: 'audios/bir.mp3',
      number: '1',
    ),
    MediaModel(
      image: 'assets/gif/iki.gif',
      gif: 'assets/gif/3.gif',
      audio: 'audios/iki.mp3',
      number: '2',
    ),
    MediaModel(
      image: 'assets/gif/uc.gif',
      gif: 'assets/gif/4.gif',
      audio: 'audios/uc.mp3',
      number: '3',
    ),
    MediaModel(
      image: 'assets/gif/dort.gif',
      gif: 'assets/gif/5.gif',
      audio: 'audios/dort.mp3',
      number: '4',
    ),
    MediaModel(
      image: 'assets/gif/bes.gif',
      gif: 'assets/gif/6.gif',
      audio: 'audios/bes.mp3',
      number: '5',
    ),
    MediaModel(
      image: 'assets/gif/alti.gif',
      gif: 'assets/gif/7.gif',
      audio: 'audios/alti.mp3',
      number: '6',
    ),
    MediaModel(
      image: 'assets/gif/yedi.gif',
      gif: 'assets/gif/8.gif',
      audio: 'audios/yedi.mp3',
      number: '7',
    ),
    MediaModel(
      image: 'assets/gif/sekiz.gif',
      gif: 'assets/gif/9.gif',
      audio: 'audios/sekiz.mp3',
      number: '8',
    ),
    MediaModel(
      image: 'assets/gif/dokuz.gif',
      gif: 'assets/gif/10.gif',
      audio: 'audios/dokuz.mp3',
      number: '9',
    ),
  ];

  static final List<MediaModel> mediaListWithoutAudio = [
    MediaModel(
      image: 'assets/gif/sifir.gif',
      gif: 'assets/gif/1.gif',
      number: '0',
    ),
    MediaModel(
      image: 'assets/gif/bir.gif',
      gif: 'assets/gif/2.gif',
      number: '1',
    ),
    MediaModel(
      image: 'assets/gif/iki.gif',
      gif: 'assets/gif/3.gif',
      number: '2',
    ),
    MediaModel(
      image: 'assets/gif/uc.gif',
      gif: 'assets/gif/4.gif',
      number: '3',
    ),
    MediaModel(
      image: 'assets/gif/dort.gif',
      gif: 'assets/gif/5.gif',
      number: '4',
    ),
    MediaModel(
      image: 'assets/gif/bes.gif',
      gif: 'assets/gif/6.gif',
      number: '5',
    ),
    MediaModel(
      image: 'assets/gif/alti.gif',
      gif: 'assets/gif/7.gif',
      number: '6',
    ),
    MediaModel(
      image: 'assets/gif/yedi.gif',
      gif: 'assets/gif/8.gif',
      number: '7',
    ),
    MediaModel(
      image: 'assets/gif/sekiz.gif',
      gif: 'assets/gif/9.gif',
      number: '8',
    ),
    MediaModel(
      image: 'assets/gif/dokuz.gif',
      gif: 'assets/gif/10.gif',
      number: '9',
    ),
  ];
}

class SimpleMediaModel {
  final String gif;
  final String number;

  SimpleMediaModel({
    required this.gif,
    required this.number,
  });
}

class SimpleMediaData {
  static final List<SimpleMediaModel> simpleMediaList = [
    SimpleMediaModel(
      gif: 'assets/gif/t1.gif',
      number: '2',
    ),
    SimpleMediaModel(
      gif: 'assets/gif/t2.gif',
      number: '6',
    ),
    SimpleMediaModel(
      gif: 'assets/gif/t3.gif',
      number: '7',
    ),
    SimpleMediaModel(
      gif: 'assets/gif/t4.gif',
      number: '4',
    ),
    SimpleMediaModel(
      gif: 'assets/gif/t5.gif',
      number: '5',
    ),
    SimpleMediaModel(
      gif: 'assets/gif/t6.gif',
      number: '6',
    ),
    SimpleMediaModel(
      gif: 'assets/gif/t7.gif',
      number: '8',
    ),
    SimpleMediaModel(
      gif: 'assets/gif/t8.gif',
      number: '3',
    ),
    SimpleMediaModel(
      gif: 'assets/gif/t9.gif',
      number: '9',
    ),
    SimpleMediaModel(
      gif: 'assets/gif/t10.gif',
      number: '7',
    ),
  ];
}
