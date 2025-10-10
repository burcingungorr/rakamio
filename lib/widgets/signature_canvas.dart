import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import '../utils/constants.dart';

class SignatureCanvas extends StatelessWidget {
  final SignatureController controller;
  final GlobalKey signatureKey;

  const SignatureCanvas({
    super.key,
    required this.controller,
    required this.signatureKey,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: RepaintBoundary(
          key: signatureKey,
          child: Signature(
            controller: controller,
            height: MediaQuery.of(context).size.height,
            backgroundColor: AppConstants.backgroundColor,
          ),
        ),
      ),
    );
  }
}
