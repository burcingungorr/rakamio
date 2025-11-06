import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import '../../services/audio_service.dart';
import '../../services/ml_service.dart';
import '../../widgets/signature_canvas.dart';
import '../../utils/constants.dart';
import '../../widgets/prediction_helper.dart';
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
    await PredictionHelper.predictAndHandleResult(
      context: context,
      mlService: _mlService,
      audioService: _audioService,
      signatureKey: _signatureKey,
      correctAnswer: widget.correctNumber,
      mounted: mounted,
      selectedImage: _selectedImage,
      navigationType: NavigationType.popUntilFirst,
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
      onCorrect: widget.onCorrect,
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