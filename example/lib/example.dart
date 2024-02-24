import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:watermark_unique/image_format.dart';
import 'package:watermark_unique/watermark_unique.dart';

class ExampleWidget extends StatefulWidget {
  const ExampleWidget({
    super.key,
  });

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  final _watermarkPlugin = WatermarkUnique();
  File? photo;
  File? watermark;
  File? finalFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          top: 24,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _takeImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 4,
                  ),
                  child: const Text(
                    'Take image',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Text(
                    'Image path: ${photo?.path}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _takeWatermarkImage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 4,
                  ),
                  child: const Text(
                    'Take watermark image',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
                  child: Text(
                    'Watermark image path: ${watermark?.path}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _addImageTextWatermark,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 4,
                  ),
                  child: const Text(
                    'Add text watermark to photo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ElevatedButton(
                    onPressed: _addWatermarkImageToPhoto,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      elevation: 4,
                    ),
                    child: const Text(
                      'Add watermark image to photo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if(finalFile != null)
                Image.file(
                  finalFile!,
                  width: 400,
                  height: 400,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _takeImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageBytes = await image.readAsBytes();
      final savedFile = await _saveImage(image: imageBytes);
      setState(() {
        photo = savedFile;
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image from gallery: $e');
    }
    return;
  }

  Future<void> _takeWatermarkImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageBytes = await image.readAsBytes();
      final savedFile = await _saveImage(image: imageBytes);
      setState(() {
        watermark = savedFile;
      });
    } on PlatformException catch (e) {
      debugPrint('Failed to pick image from gallery: $e');
    }
    return;
  }

  Future<File?> _saveImage({
    required Uint8List image,
  }) async {
    try {
      debugPrint('${image.length} SIZE OF BYTES');

      final directory = (Platform.isIOS
          ? await getApplicationDocumentsDirectory()
          : await getExternalStorageDirectory()) as Directory;

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      String name = '${DateTime.now().millisecondsSinceEpoch}.jpeg';

      String filePath = '${directory.path}/$name';

      final savedFile = await File(filePath).writeAsBytes(image);

      if (await savedFile.exists()) {
        debugPrint('Image saved successfully: ${savedFile.path}');
        return savedFile;
      } else {
        debugPrint('Error saving image. File does not exist.');
        return null;
      }
    } catch (e) {
      debugPrint('Error saving image: $e');
      return null;
    }
  }

  Future<String?> _addImageTextWatermark() async {
    final image = await _watermarkPlugin.addTextWatermark(
      filePath: photo!.path,
      text: 'Test watermark text',
      x: 500,
      y: 400,
      textSize: 250,
      color: Colors.purpleAccent.value,
      backgroundTextColor: Colors.black.value,
      quality: 100,
      imageFormat: ImageFormat.jpeg,
    );
    debugPrint('add image watermark: $image');
    if (image != null) {
      final result  = await saveEditedImage(image);
      setState(() {
        finalFile = result;
      });
    }
    return image;
  }

  Future<String?> _addWatermarkImageToPhoto() async {
    final image = await _watermarkPlugin.addImageWatermark(
      filePath: photo!.path,
      watermarkImagePath: watermark!.path,
      x: 500,
      y: 400,
      quality: 100,
      imageFormat: ImageFormat.jpeg,
      watermarkWidth: 300,
      watermarkHeight: 300,
    );
    debugPrint('add image watermark: $image');
    if (image != null) {
      final result  = await saveEditedImage(image);
      setState(() {
        finalFile = result;
      });
    }
    return image;
  }

  Future<File?> saveEditedImage(String imagePath) async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      String savePath = '${directory.path}/watermarked_image.jpeg';

      final result = File(imagePath).copy(savePath);
      debugPrint('Saved file: $savePath');
       return result;
    } catch (e) {
      debugPrint('Error saving file: $e');
      return null;
    }
  }
}