import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import '../../services/audio_service.dart';
import '../../services/ml_service.dart';
import '../../widgets/signature_canvas.dart';
import '../../utils/constants.dart';
  
class SecondLevelScreen extends StatefulWidget {
  final int level;
  final VoidCallback onLevelComplete;

  const SecondLevelScreen({
    super.key,
    required this.level,
    required this.onLevelComplete,
  });

  @override
  _SecondLevelScreenState createState() => _SecondLevelScreenState();
}

class _SecondLevelScreenState extends State<SecondLevelScreen> {
  late SignatureController _controller;
  final MLService _mlService = MLService();
  final AudioService _audioService = AudioService();
  final GlobalKey _signatureKey = GlobalKey();
  Uint8List? _selectedImage;
  Widget _icon = const SizedBox.shrink();

  late String _currentNumber;

  final List<String> _levelNumbers = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9'
  ];

  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: AppConstants.penStrokeWidth,
      penColor: AppConstants.textColor,
      exportBackgroundColor: AppConstants.backgroundColor,
    );

    _mlService.loadModel();
    _currentNumber = _levelNumbers[widget.level - 11];
    _playAudioForCurrentNumber();
  }

  void _playAudioForCurrentNumber() {
    String audioFile;
    switch (_currentNumber) {
      case '0':
        audioFile = AudioFiles.zero;
        break;
      case '1':
        audioFile = AudioFiles.one;
        break;
      case '2':
        audioFile = AudioFiles.two;
        break;
      case '3':
        audioFile = AudioFiles.three;
        break;
      case '4':
        audioFile = AudioFiles.four;
        break;
      case '5':
        audioFile = AudioFiles.five;
        break;
      case '6':
        audioFile = AudioFiles.six;
        break;
      case '7':
        audioFile = AudioFiles.seven;
        break;
      case '8':
        audioFile = AudioFiles.eight;
        break;
      case '9':
        audioFile = AudioFiles.nine;
        break;
      default:
        audioFile = AudioFiles.one;
    }
    _audioService.playAudio(audioFile);
  }

  Future<void> _predictDigit() async {
    if (!_mlService.isModelLoaded) return;

    String prediction = await _mlService.predictDigit(
      _signatureKey,
      selectedImage: _selectedImage,
    );

    if (prediction == _currentNumber) {
      setState(() {
        _icon = const Icon(Icons.check_circle, color: Colors.green, size: 50);
      });
      await _audioService.playAudio(AudioFiles.congratulations);

      widget.onLevelComplete();

      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          Navigator.pop(context);
        }
      });
    } else {
      setState(() {
        _icon = const Icon(Icons.close, color: Colors.red, size: 50);
      });
      await _audioService.playAudio(AudioFiles.tryAgain);
      Future.delayed(const Duration(seconds: 1), _clearCanvas);
    }
  }

  void _clearCanvas() {
    setState(() {
      _controller.clear();
      _selectedImage = null;
      _icon = const SizedBox.shrink();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: Column(
        children: <Widget>[
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconButton(icon: Icons.clear, onPressed: _clearCanvas),
                _buildIconButton(icon: Icons.check, onPressed: _predictDigit),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: SignatureCanvas(
                  controller: _controller, signatureKey: _signatureKey),
            ),
          ),
          const SizedBox(height: 20),
          _icon,
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildIconButton(
      {required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: AppConstants.primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 40),
        onPressed: onPressed,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}