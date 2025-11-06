import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import '../../services/audio_service.dart';
import '../../services/ml_service.dart';
import '../../widgets/signature_canvas.dart';
import '../../utils/constants.dart';
import '../../widgets/prediction_helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  Widget _feedbackAnimation = const SizedBox.shrink();
  bool _isProcessing = false;
  late String _currentNumber;

  final List<String> _levelNumbers = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

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
    await PredictionHelper.predictAndHandleResult(
      context: context,
      mlService: _mlService,
      audioService: _audioService,
      signatureKey: _signatureKey,
      correctAnswer: _currentNumber,
      mounted: mounted,
      selectedImage: _selectedImage,
      navigationType: NavigationType.pop,
      setProcessing: (isProcessing) {
        if (mounted) {
          setState(() {
            _isProcessing = isProcessing;
          });
        }
      },
      setFeedbackAnimation: (animation) {
        if (mounted) {
          setState(() {
            _feedbackAnimation = animation;
          });
        }
      },
      clearCanvas: () {
        _controller.clear();
        _selectedImage = null;
      },
      onCorrect: widget.onLevelComplete,
    );
  }

  void _clearCanvas() {
    if (_isProcessing) return;

    setState(() {
      _controller.clear();
      _selectedImage = null;
      _feedbackAnimation = const SizedBox.shrink();
    });
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    double size = 55,
    double iconSize = 28,
    bool hasBackground = true,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: hasBackground
          ? BoxDecoration(
              color: AppConstants.primaryColor,
              borderRadius: BorderRadius.circular(15),
            )
          : null,
      child: IconButton(
        icon: Icon(
          icon,
          color: Colors.white,
          size: iconSize,
        ),
        onPressed: _isProcessing ? null : onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildIconButton(
                      icon: FontAwesomeIcons.eraser,
                      onPressed: _clearCanvas,
                    ),
                    _buildIconButton(
                      icon: FontAwesomeIcons.volumeHigh,
                      onPressed: _playAudioForCurrentNumber,
                      hasBackground: false,
                    ),
                    _buildIconButton(
                      icon: FontAwesomeIcons.check,
                      onPressed: _predictDigit,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 2,
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Center(
                  child: SignatureCanvas(controller: _controller, signatureKey: _signatureKey),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
          _feedbackAnimation,
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}