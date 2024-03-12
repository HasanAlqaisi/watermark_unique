# watermark_unique

watermark_unique is a flutter package to add text and image watermarks on an image or video. You can customize the watermark's position, color, background color, and padding.
Check on pub.dev: https://pub.dev/packages/watermark_unique

## Documentation
### Features

- Add text to image
- Add watermark to image
- Add text to video
- Add watermark to video

**Parameters for image that you can change**

- Text
- Position by X
- Position by Y
- Text size
- Text color
- Background text color (optional)
- Padding for text if background exist (optional)
- Quality of image with watermark
- Image format that you will use to compress

## Usage
An example of how you can add text to an image:
```dart
final image = await _watermarkPlugin.addTextWatermark(
  filePath: photo!.path, // image file path
  text: 'Test watermark text', // watermark text
  x: 500, // position by x
  y: 400, // position by y
  textSize: 250, // text size
  color: Colors.purpleAccent.value, // color of text
  backgroundTextColor: Colors.black.value, // color of background text (optional)
  quality: 100, // quality of image with watermark
  backgroundTextPaddingLeft: 12, // padding of background text (optional)
  backgroundTextPaddingTop: 12, // padding of background text (optional)
  backgroundTextPaddingRight: 12, // padding of background text (optional)
  backgroundTextPaddingBottom: 12, // padding of background text (optional)
  imageFormat: ImageFormat.jpeg, // image format that you will use to compress
);
```

An example of how you can add a watermark to an image:
```dart
final image = await _watermarkPlugin.addImageWatermark(
  filePath: photo!.path, // image file path
  watermarkImagePath: watermark!.path, // watermark image file path
  x: 500, // position by x
  y: 400, // position by x
  quality: 100, // quality of image with watermark
  imageFormat: ImageFormat.jpeg, // image format that you will use to compress
  watermarkWidth: 300, // watermark image width
  watermarkHeight: 300,  // watermark image height
);
```


## Example Android screenshots
<img src="https://github.com/engineer-unknown/watermark_unique/blob/main/android_example.png" height="400">
<img src="https://github.com/engineer-unknown/watermark_unique/blob/main/android_example_image_watermark.png" height="400">
<img src="https://github.com/engineer-unknown/watermark_unique/blob/main/android_example_text.png" height="400">