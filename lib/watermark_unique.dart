import 'image_format.dart';
import 'watermark_platform_interface.dart';

class WatermarkUnique {
  Future<String?> addTextWatermark({
    required String filePath,
    required String text,
    required int x,
    required int y,
    required int textSize,
    required int color,
    int? backgroundTextColor,
    required int quality,
    int? backgroundTextPaddingTop,
    int? backgroundTextPaddingBottom,
    int? backgroundTextPaddingLeft,
    int? backgroundTextPaddingRight,
    required ImageFormat imageFormat,
  }) {
    return WatermarkPlatform.instance.addTextWatermark(
      filePath,
      text,
      x,
      y,
      textSize,
      color,
      backgroundTextColor,
      quality,
      backgroundTextPaddingTop,
      backgroundTextPaddingBottom,
      backgroundTextPaddingLeft,
      backgroundTextPaddingRight,
      imageFormat,
    );
  }

  Future<String?> addImageWatermark({
    required String filePath,
    required String watermarkImagePath,
    required int x,
    required int y,
    required int watermarkWidth,
    required int watermarkHeight,
    required int quality,
    required ImageFormat imageFormat,
  }) {
    return WatermarkPlatform.instance.addImageWatermark(
      filePath,
      watermarkImagePath,
      x,
      y,
      watermarkWidth,
      watermarkHeight,
      quality,
      imageFormat,
    );
  }
}
