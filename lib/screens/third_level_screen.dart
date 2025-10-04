import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/level_selection_screen3.dart';
import 'package:signature/signature.dart';
import 'package:image_picker/image_picker.dart';
import '../services/audio_service.dart';
import '../services/ml_service.dart';
import '../widgets/signature_canvas.dart';
import '../utils/constants.dart';

class ThirdLevelScreen extends StatefulWidget {
  final String correctNumber;
  final int level;
  final VoidCallback onCorrect; 

  const ThirdLevelScreen({
    Key? key,
    required this.correctNumber,
    required this.level,
    required this.onCorrect,
  }) : super(key: key);

  @override
  _ThirdLevelScreenState createState() => _ThirdLevelScreenState();
}

class _ThirdLevelScreenState extends State<ThirdLevelScreen> {
  late SignatureController _controller;
  final MLService _mlService = MLService();
  final AudioService _audioService = AudioService();
  final GlobalKey _signatureKey = GlobalKey();
  final ImagePicker _picker = ImagePicker();

  String _prediction = '';
  Uint8List? _selectedImage;
  Widget _icon = const SizedBox.shrink();

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
    if (!_mlService.isModelLoaded) return;

    String prediction = await _mlService.predictDigit(
      _signatureKey,
      selectedImage: _selectedImage,
    );

    setState(() {
      _prediction = prediction;
    });

    if (_prediction == widget.correctNumber) {
      setState(() {
        _icon = const Icon(Icons.check_circle, color: Colors.green, size: 50);
      });
      await _audioService.playAudio(AudioFiles.congratulations);

      widget.onCorrect();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => LevelSelectionScreen3()),
        (route) => false, 
      );
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
      _prediction = '';
      _icon = const SizedBox.shrink();
    });
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _selectedImage == null
                    ? SignatureCanvas(
                        controller: _controller, signatureKey: _signatureKey)
                    : Image.memory(_selectedImage!),
                const SizedBox(height: 20),
                _icon,
              ],
            ),
          ),
          const SizedBox(height: 20),
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
