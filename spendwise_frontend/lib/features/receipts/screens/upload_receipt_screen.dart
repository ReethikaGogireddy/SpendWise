import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'receipt_preview_screen.dart';

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
  await _pickImage(ImageSource.camera);
}

// Opens the user's photo gallery.
Future<void> _chooseFromGallery() async {
  await _pickImage(ImageSource.gallery);
}

  // Opens either the camera or gallery based on the source.
Future<void> _pickImage(ImageSource source) async {
  setState(() {
    _isPicking = true;
  });

  try {
    final XFile? photo = await _picker.pickImage(
      source: source,
      imageQuality: 85,
    );

    if (!mounted) return;

    Navigator.pop(context);

    if (photo != null) {
      debugPrint("Selected receipt: ${photo.path}");

      // Navigate to the preview screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReceiptPreviewScreen(
            imagePath: photo.path,
          ),
        ),
      );
      // TODO: 
      // upload to the backend after this from the preview screen
    }
  } catch (e) {
    debugPrint("Image Picker Error: $e");
  } finally {
    if (mounted) {
      setState(() {
        _isPicking = false;
      });
    }
  }
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