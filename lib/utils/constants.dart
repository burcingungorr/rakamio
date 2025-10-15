import 'package:flutter/material.dart';

class AppConstants {
  static const Color primaryColor = Colors.orange;
  static const Color backgroundColor = Colors.black;
  static const Color textColor = Colors.white;

  static const double penStrokeWidth = 30.0;
  static const double buttonSize = 120.0;
  static const double titleFontSize = 70.0;
  static const double levelButtonFontSize = 40.0;

  static const Duration splashDuration = Duration(seconds: 3);
  static const Duration audioDelay = Duration(seconds: 2);

  static const String modelAssetPath = 'assets/mnist.tflite';
}

class AudioFiles {
  static const String levelSelection = 'audios/seviyenisec.mp3';
  static const String timeUp = 'audios/surebitmeden.mp3';
  static const String congratulations = 'audios/tebrikler.mp3';
  static const String tryAgain = 'audios/tekrar.mp3';
  static const String writeWhatYouKnow = 'audios/bildikleriniyaz.mp3';
  static const String write = 'audios/duydugun.mp3';
  static const String lets = 'audios/haydibutonabas.mp3';
  static const String how = 'audios/sencekactane.mp3';

  static const String zero = 'audios/sifir.mp3';
  static const String one = 'audios/bir.mp3';
  static const String two = 'audios/iki.mp3';
  static const String three = 'audios/uc.mp3';
  static const String four = 'audios/dort.mp3';
  static const String five = 'audios/bes.mp3';
  static const String six = 'audios/alti.mp3';
  static const String seven = 'audios/yedi.mp3';
  static const String eight = 'audios/sekiz.mp3';
  static const String nine = 'audios/dokuz.mp3';
}
