import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadReceiptSheet extends StatefulWidget {
  const UploadReceiptSheet({super.key});

  @override
  State<UploadReceiptSheet> createState() => _UploadReceiptSheetState();
}

class _UploadReceiptSheetState extends State<UploadReceiptSheet> {

  // Image picker instance used to access the camera/gallery.
  final ImagePicker _picker = ImagePicker();

  // Tracks whether the camera is currently opening.
  bool _isPicking = false;

  // Opens the camera and captures a receipt image.
  Future<void> _takePhoto() async {
    setState(() {
      _isPicking = true;
    });

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (!mounted) return;

      Navigator.pop(context);

      if (photo != null) {
        debugPrint("Captured receipt: ${photo.path}");

        // TODO:
        // Navigate to the preview screen
        // or upload the image to the backend.
      }
    } catch (e) {
      debugPrint("Camera Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isPicking = false;
        });
      }
    }
  }

  // Opens the gallery (implemented in the next step).
  void _chooseFromGallery() {
    Navigator.pop(context);

    // TODO: Implement gallery picker.
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [

            // Bottom sheet title.
            const Center(
              child: Text(
                "Scan Receipt",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Opens the device camera.
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Take Photo"),
              trailing: _isPicking
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : null,
              onTap: _isPicking ? null : _takePhoto,
            ),

            // Opens the user's photo gallery.
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Choose from Gallery"),
              onTap: _chooseFromGallery,
            ),

            // Closes the bottom sheet.
            ListTile(
              leading: const Icon(Icons.close),
              title: const Text("Cancel"),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}