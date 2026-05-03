import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

/// Reusable camera + gallery picker
/// Call: `final file = await showPhotoPicker(context);`
Future<File?> showPhotoPicker(BuildContext context) async {
  return await Navigator.push(
    context,
    MaterialPageRoute(builder: (_) => const _PhotoPickerScreen()),
  );
}

class _PhotoPickerScreen extends StatefulWidget {
  const _PhotoPickerScreen({Key? key}) : super(key: key);

  @override
  State<_PhotoPickerScreen> createState() => _PhotoPickerScreenState();
}

class _PhotoPickerScreenState extends State<_PhotoPickerScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras != null && _cameras!.isNotEmpty) {
      _controller = CameraController(
        _cameras!.first,
        ResolutionPreset.medium,
      );
      await _controller!.initialize();
      if (mounted) {
        setState(() => _isCameraInitialized = true);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (!_controller!.value.isInitialized) return;
    final image = await _controller!.takePicture();
    Navigator.pop(context, File(image.path));
  }

  Future<void> _openGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      Navigator.pop(context, File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          if (_isCameraInitialized)
            CameraPreview(_controller!)
          else
            const Center(child: CircularProgressIndicator(color: Colors.white)),

          // Bottom controls
          Padding(
            padding: const EdgeInsets.only(bottom: 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.photo_library,
                      color: Colors.white, size: 36),
                  onPressed: _openGallery,
                ),
                const SizedBox(width: 60),
                GestureDetector(
                  onTap: _takePicture,
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
