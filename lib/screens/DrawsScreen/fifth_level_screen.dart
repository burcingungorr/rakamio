import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../services/audio_service.dart';
import '../../services/ml_service.dart';
import '../../utils/constants.dart';
import '../../widgets/signature_canvas.dart';
import '../../widgets/prediction_helper.dart';

class FifthLevelScreen extends StatefulWidget {
  final int level;
  final int initialNum1;
  final int initialNum2;
  final VoidCallback onLevelComplete;

  const FifthLevelScreen({
    super.key,
    required this.level,
    required this.initialNum1,
    required this.initialNum2,
    required this.onLevelComplete,
  });

  @override
  _FifthLevelScreenState createState() => _FifthLevelScreenState();
}

class _FifthLevelScreenState extends State<FifthLevelScreen> {
  late SignatureController _controller;
  final MLService _mlService = MLService();
  final AudioService _audioService = AudioService();
  final GlobalKey _signatureKey = GlobalKey();
  Uint8List? _selectedImage;
  Widget _feedbackAnimation = const SizedBox.shrink();
  bool _isProcessing = false;

  late int _num1;
  late int _num2;
  late int _correctResult;
  late String _currentNumber;

  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: AppConstants.penStrokeWidth,
      penColor: AppConstants.textColor,
      exportBackgroundColor: AppConstants.backgroundColor,
    );
    _mlService.loadModel();

    _num1 = widget.initialNum1;
    _num2 = widget.initialNum2;
    _correctResult = _num1 + _num2;
    _currentNumber = _correctResult.toString();
  }

  Future<void> _handlePrediction() async {
    await PredictionHelper.predictAndHandleResult(
      context: context,
      mlService: _mlService,
      audioService: _audioService,
      signatureKey: _signatureKey,
      correctAnswer: _currentNumber,
      mounted: mounted,
      selectedImage: _selectedImage,
      setProcessing: (isProcessing) {
        setState(() {
          _isProcessing = isProcessing;
        });
      },
      setFeedbackAnimation: (animation) {
        setState(() {
          _feedbackAnimation = animation;
        });
      },
      clearCanvas: _clearCanvas,
      onCorrect: widget.onLevelComplete,
      navigationType: NavigationType.LevelSelectionScreen5,
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
            children: [
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
                    Center(
                      child: Text(
                        '$_num1 + $_num2',
                        style: const TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    _buildIconButton(
                      icon: FontAwesomeIcons.check,
                      onPressed: _handlePrediction,
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
                  child: SignatureCanvas(
                    controller: _controller,
                    signatureKey: _signatureKey,
                  ),
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
