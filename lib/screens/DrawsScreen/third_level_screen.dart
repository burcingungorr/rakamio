import 'dart:typed_data';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:signature/signature.dart';
import '../../services/audio_service.dart';
import '../../services/ml_service.dart';
import '../../widgets/signature_canvas.dart';
import '../../utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ThirdLevelScreen extends StatefulWidget {
  final String correctNumber;
  final int level;
  final VoidCallback onCorrect;

  const ThirdLevelScreen({
    super.key,
    required this.correctNumber,
    required this.level,
    required this.onCorrect,
  });

  @override
  _ThirdLevelScreenState createState() => _ThirdLevelScreenState();
}

class _ThirdLevelScreenState extends State<ThirdLevelScreen> {
  late SignatureController _controller;
  final MLService _mlService = MLService();
  final AudioService _audioService = AudioService();
  final GlobalKey _signatureKey = GlobalKey();
  String _prediction = '';
  Uint8List? _selectedImage;
  Widget _icon = const SizedBox.shrink();
  Widget _feedbackAnimation = const SizedBox.shrink();
  bool _isProcessing = false;
  String? _selectedGif;

  final List<String> _gifPaths = [
    'assets/gif/dogru1.gif',
    'assets/gif/dogru2.gif',
    'assets/gif/dogru3.gif',
    'assets/gif/dogru4.gif',
    'assets/gif/dogru5.gif',
    'assets/gif/dogru6.gif',
  ];

  final List<String> _wrongGifPaths = [
    'assets/gif/yanlis.gif',
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
  }

  Future<void> _predictDigit() async {
    if (!_mlService.isModelLoaded || _isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    String prediction = await _mlService.predictDigit(
      _signatureKey,
      selectedImage: _selectedImage,
    );

    setState(() {
      _prediction = prediction;
    });

    if (_prediction == widget.correctNumber) {
      final random = Random();
      _selectedGif = _gifPaths[random.nextInt(_gifPaths.length)];

      setState(() {
        _feedbackAnimation = Stack(
          children: [
            _buildFullScreenAnimation('assets/animations/Confetti.json'),
            _buildBottomGif(_selectedGif!),
          ],
        );
      });

      await _audioService.playAudio(AudioFiles.congratulations);
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        widget.onCorrect();
        Navigator.pop(context, true);
      }
    } else {
      _selectedGif = _wrongGifPaths.first;

      setState(() {
        _feedbackAnimation = Stack(
          children: [
            _buildFullScreenAnimation('assets/animations/SadFace.json'),
            _buildBottomGif(_selectedGif!),
          ],
        );
      });

      await _audioService.playAudio(AudioFiles.tryAgain);
      await Future.delayed(const Duration(seconds: 3));

      _controller.clear();
      _selectedImage = null;
      _prediction = '';
      _icon = const SizedBox.shrink();

      if (mounted) {
        setState(() {
          _feedbackAnimation = const SizedBox.shrink();
        });
      }
    }

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _clearCanvas() {
    if (_isProcessing) return;

    setState(() {
      _controller.clear();
      _selectedImage = null;
      _prediction = '';
      _icon = const SizedBox.shrink();
      _feedbackAnimation = const SizedBox.shrink();
    });
  }

  Widget _buildFullScreenAnimation(String assetPath) {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: Lottie.asset(
            assetPath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomGif(String gifPath) {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Center(
        child: Image.asset(
          gifPath,
             width: 250,
          height: 250,
        ),
      ),
    );
  }

  Widget _buildIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    double size = 55,
    double iconSize = 28,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppConstants.primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: iconSize),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _selectedImage == null
                        ? SignatureCanvas(controller: _controller, signatureKey: _signatureKey)
                        : Image.memory(_selectedImage!),
                    const SizedBox(height: 20),
                    _icon,
                  ],
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
