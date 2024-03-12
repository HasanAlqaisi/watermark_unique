import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'image_format.dart';
import 'watermark_platform_interface.dart';

class MethodChannelWatermark extends WatermarkPlatform {
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
        'x': x.toString(),
        'y': y.toString(),
        'watermarkWidth': watermarkWidth,
        'watermarkHeight': watermarkHeight,
        'quality': quality,
        'imageFormat': imageFormat.name,
      },
    );
    return result;
  }
}
