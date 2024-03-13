import 'dart:io';
import 'dart:typed_data';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:watermark_unique/watermark_manager.dart';
import 'image_format.dart';

/// Interface for adding watermarks to images.
///
/// This interface defines methods for adding both text and image watermarks to images.
abstract class WatermarkBridge extends PlatformInterface {
  WatermarkBridge() : super(token: _token);

  static final Object _token = Object();

  static WatermarkBridge _instance = WatermarkManager();

  static WatermarkBridge get instance => _instance;

  static set instance(WatermarkBridge instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Adds a text watermark to the image at the specified location with the given parameters.
  ///
  /// Returns a [String] representing the path to the watermarked image.
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
  );

  /// Adds an image watermark to the image at the specified location with the given parameters.
  ///
  /// Returns a [String] representing the path to the watermarked image.
  Future<String?> addImageWatermark(
    String filePath,
    String watermarkImagePath,
    int x,
    int y,
    int watermarkWidth,
    int watermarkHeight,
    int quality,
    ImageFormat imageFormat,
  );

  /// Adds a text watermark to the image at the specified location with the given parameters.
  ///
  /// Returns a [Uint8List] representing the watermarked image.
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
  );

  /// Adds an image watermark to the image at the specified location with the given parameters.
  ///
  /// Returns a [Uint8List] representing the watermarked image.
  Future<Uint8List?> addImageWatermarkUint8List(
    File filePath,
    File watermarkImagePath,
    int x,
    int y,
    int watermarkWidth,
    int watermarkHeight,
  );
}
