import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:watermark_unique/watermark_bridge.dart';
import 'image_format.dart';
import 'dart:ui' as ui;

/// Class responsible for managing watermarks.
///
/// This class implements the [WatermarkBridge] interface and provides methods
/// for adding watermarks to images.
class WatermarkManager extends WatermarkBridge {
  @visibleForTesting
  final watermarkImageChannel = const MethodChannel('WatermarkImage');

  @override
  Future<String?> addTextWatermark(
    String filePath,
    String text,
    int x,
    int y,
    int textSize,
    int color,
    int? backgroundTextColor,
    int quality,
    int? backgroundTextPaddingTop,
    int? backgroundTextPaddingBottom,
    int? backgroundTextPaddingLeft,
    int? backgroundTextPaddingRight,
    ImageFormat imageFormat,
  ) async {
    final result = await watermarkImageChannel.invokeMethod<String?>(
      'addTextWatermark',
      {
        'text': text,
        'filePath': filePath,
        'x': x,
        'y': y,
        'textSize': textSize,
        'color': color,
        'backgroundTextColor': backgroundTextColor,
        'quality': quality,
        'backgroundTextPaddingTop': backgroundTextPaddingTop,
        'backgroundTextPaddingBottom': backgroundTextPaddingBottom,
        'backgroundTextPaddingLeft': backgroundTextPaddingLeft,
        'backgroundTextPaddingRight': backgroundTextPaddingRight,
        'imageFormat': imageFormat.name,
      },
    );
    return result;
  }

  @override
  Future<String?> addImageWatermark(
    String filePath,
    String watermarkImagePath,
    int x,
    int y,
    int watermarkWidth,
    int watermarkHeight,
    int quality,
    ImageFormat imageFormat,
  ) async {
    final result = await watermarkImageChannel.invokeMethod<String?>(
      'addImageWatermark',
      {
        'filePath': filePath,
        'watermarkImagePath': watermarkImagePath,
        'x': x,
        'y': y,
        'watermarkWidth': watermarkWidth,
        'watermarkHeight': watermarkHeight,
        'quality': quality,
        'imageFormat': imageFormat.name,
      },
    );
    return result;
  }

  @override
  Future<Uint8List?> addTextWatermarkUint8List(
    File filePath,
    String text,
    int x,
    int y,
    int textSize,
    int color,
    int? backgroundTextColor,
    int? backgroundTextPaddingTop,
    int? backgroundTextPaddingBottom,
    int? backgroundTextPaddingLeft,
    int? backgroundTextPaddingRight,
  ) async {
    final originalImage = await filePath.readAsBytes();

    final ui.Image image = await decodeImageFromList(originalImage);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Create a transparent background
    final bgPaint = Paint()..color = Colors.transparent;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      bgPaint,
    );

    canvas.drawImage(image, Offset.zero, Paint());

    final textStyle = ui.TextStyle(
      color: Color(color),
      fontSize: textSize.toDouble(),
    );

    final paragraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.start,
      fontSize: textSize.toDouble(),
    ))
      ..pushStyle(textStyle)
      ..addText(
        text,
      );

    final paragraph = paragraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: image.width.toDouble()));

    if (backgroundTextColor != null) {
      final bgPaintText = Paint()..color = Color(backgroundTextColor);
      final backgroundRect = Rect.fromLTRB(
        x.toDouble() - (backgroundTextPaddingLeft ?? 0),
        y.toDouble() - (backgroundTextPaddingTop ?? 0),
        x + paragraph.width + (backgroundTextPaddingRight ?? 0),
        y + paragraph.height + (backgroundTextPaddingBottom ?? 0),
      );
      canvas.drawRect(backgroundRect, bgPaintText);
    }

    canvas.drawParagraph(
      paragraph,
      Offset(x.toDouble(), y.toDouble()),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(image.width, image.height);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }

  @override
  Future<Uint8List?> addImageWatermarkUint8List(
    File filePath,
    File watermarkImagePath,
    int x,
    int y,
    int watermarkWidth,
    int watermarkHeight,
  ) async {
    // Read bytes of the original image
    final originalImageBytes = await filePath.readAsBytes();

    // Read bytes of the watermark image
    final watermarkImageBytes = await watermarkImagePath.readAsBytes();

    // Decode the original image
    final originalImage = await ui
        .instantiateImageCodec(originalImageBytes)
        .then((codec) => codec.getNextFrame())
        .then((frame) => frame.image);

    // Decode the watermark image
    final watermarkImage = await ui
        .instantiateImageCodec(watermarkImageBytes)
        .then((codec) => codec.getNextFrame())
        .then((frame) => frame.image);

    // Create a recorder
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw the original image
    canvas.drawImage(originalImage, Offset.zero, Paint());

    // Draw the watermark image
    canvas.drawImageRect(
      watermarkImage,
      Rect.fromLTRB(0, 0, watermarkImage.width.toDouble(),
          watermarkImage.height.toDouble()),
      Rect.fromLTRB(x.toDouble(), y.toDouble(), (x + watermarkWidth).toDouble(),
          (y + watermarkHeight).toDouble()),
      Paint(),
    );

    // Convert the canvas to image
    final picture = recorder.endRecording();
    final img =
        await picture.toImage(originalImage.width, originalImage.height);
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData?.buffer.asUint8List();
  }
}
