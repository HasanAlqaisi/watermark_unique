import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'image_format.dart';
import 'watermark_method_channel.dart';

abstract class WatermarkPlatform extends PlatformInterface {
  WatermarkPlatform() : super(token: _token);

  static final Object _token = Object();

  static WatermarkPlatform _instance = MethodChannelWatermark();

  static WatermarkPlatform get instance => _instance;

  static set instance(WatermarkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

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
}
