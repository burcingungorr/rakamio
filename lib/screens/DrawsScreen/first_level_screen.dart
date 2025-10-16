import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:signature/signature.dart';
import '../../services/audio_service.dart';
import '../../services/ml_service.dart';
import '../../widgets/signature_canvas.dart';
import '../../utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FirstLevelScreen extends StatefulWidget {
  final String correctNumber;
  final int level;
  final VoidCallback onCorrect;

  const FirstLevelScreen({
    super.key,
    required this.correctNumber,
    required this.level,
    required this.onCorrect,
  });

  @override
  _FirstLevelScreenState createState() => _FirstLevelScreenState();
}

class _FirstLevelScreenState extends State<FirstLevelScreen> {
  late SignatureController _controller;
  final MLService _mlService = MLService();
  final AudioService _audioService = AudioService();
  final GlobalKey _signatureKey = GlobalKey();
  String _prediction = '';
  Uint8List? _selectedImage;
  Widget _feedbackAnimation = const SizedBox.shrink();
  bool _isProcessing = false;

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
      setState(() {
        _feedbackAnimation = _buildFullScreenAnimation('assets/animations/Confetti.json');
      });
      
      await _audioService.playAudio(AudioFiles.congratulations);
      await Future.delayed(const Duration(seconds: 2));
      
      widget.onCorrect();
      
      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } else {
      setState(() {
        _feedbackAnimation = _buildFullScreenAnimation('assets/animations/SadFace.json');
      });
      
      await _audioService.playAudio(AudioFiles.tryAgain);
      await Future.delayed(const Duration(seconds: 3));
      
      _controller.clear();
      _selectedImage = null;
      _prediction = '';
      
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

  void _clearCanvas() {
    if (_isProcessing) return;
    
    setState(() {
      _controller.clear();
      _selectedImage = null;
      _prediction = '';
      _feedbackAnimation = const SizedBox.shrink();
    });
  }

  Widget _buildHint() {
    return Text(
      widget.correctNumber,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 75,
        fontWeight: FontWeight.bold,
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
                    _buildIconButton(icon: FontAwesomeIcons.eraser, onPressed: _clearCanvas),
                    _buildHint(),
                    _buildIconButton(icon: FontAwesomeIcons.check, onPressed: _predictDigit),
                  ],
                ),
              ),
              const SizedBox(height: 14),
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
                        ? SignatureCanvas(
                            controller: _controller,
                            signatureKey: _signatureKey,
                          )
                        : Image.memory(_selectedImage!),
                    const SizedBox(height: 20),
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
