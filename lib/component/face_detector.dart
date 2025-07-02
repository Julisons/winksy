import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

/// A widget that performs face detection with a futuristic scanning animation
class FaceDetectionScanner extends StatefulWidget {
  /// The cropped image file to analyze
  final CroppedFile? croppedFile;

  /// Callback that returns true if a face is detected, false otherwise
  final ValueChanged<bool> onFaceDetected;

  /// Duration of the scanning animation (default: 3 seconds)
  final Duration scanDuration;

  /// Primary color for the scanning beam (default: cyan)
  final Color scanColor;

  /// Whether to show detection details (bounding boxes, landmarks, etc.)
  final bool showDetectionDetails;

  /// Height of the scanning widget
  final double? height;

  /// Width of the scanning widget
  final double? width;

  const FaceDetectionScanner({
    Key? key,
    required this.croppedFile,
    required this.onFaceDetected,
    this.scanDuration = const Duration(seconds: 3),
    this.scanColor = Colors.cyan,
    this.showDetectionDetails = true,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  State<FaceDetectionScanner> createState() => _FaceDetectionScannerState();
}

class _FaceDetectionScannerState extends State<FaceDetectionScanner>
    with TickerProviderStateMixin {
  List<Face> _detectedFaces = [];
  bool _isScanning = false;
  bool _scanComplete = false;
  late AnimationController _scanAnimationController;
  late Animation<double> _scanAnimation;
  ui.Image? _imageForPainting;
  Size _imageSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _startFaceDetection();
  }

  @override
  void didUpdateWidget(FaceDetectionScanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.croppedFile?.path != widget.croppedFile?.path) {
      _resetAndScan();
    }
  }

  void _initializeAnimation() {
    _scanAnimationController = AnimationController(
      duration: widget.scanDuration,
      vsync: this,
    );
    _scanAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scanAnimationController,
      curve: Curves.easeInOut,
    ));
  }

  void _resetAndScan() {
    setState(() {
      _detectedFaces.clear();
      _isScanning = false;
      _scanComplete = false;
      _imageForPainting = null;
      _imageSize = Size.zero;
    });
    _scanAnimationController.reset();
    _startFaceDetection();
  }

  Future<void> _startFaceDetection() async {
    if (widget.croppedFile == null) {
      widget.onFaceDetected(false);
      return;
    }

    setState(() {
      _isScanning = true;
      _scanComplete = false;
    });

    try {
      final File imageFile = File(widget.croppedFile!.path);

      // Load image for painting
      await _loadImageForPainting(imageFile);

      // Start scanning animation
      _scanAnimationController.forward();

      // Detect faces (run concurrently with animation)
      await _detectFaces(imageFile);

      // Wait for animation to complete if it hasn't already
      await _scanAnimationController.forward();

      setState(() {
        _scanComplete = true;
        _isScanning = false;
      });

      // Notify parent widget about detection result
      widget.onFaceDetected(_detectedFaces.isNotEmpty);

    } catch (e) {
      print('Error in face detection: $e');
      setState(() {
        _isScanning = false;
        _scanComplete = true;
      });
      widget.onFaceDetected(false);
    }
  }

  Future<void> _loadImageForPainting(File imageFile) async {
    try {
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final ui.Codec codec = await ui.instantiateImageCodec(imageBytes);
      final ui.FrameInfo frameInfo = await codec.getNextFrame();
      setState(() {
        _imageForPainting = frameInfo.image;
        _imageSize = Size(
          frameInfo.image.width.toDouble(),
          frameInfo.image.height.toDouble(),
        );
      });
    } catch (e) {
      print('Error loading image: $e');
    }
  }

  Future<void> _detectFaces(File imageFile) async {
    final InputImage inputImage = InputImage.fromFile(imageFile);
    final FaceDetector faceDetector = FaceDetector(
      options: FaceDetectorOptions(
        enableContours: true,
        enableLandmarks: true,
        enableClassification: true,
        enableTracking: true,
      ),
    );

    try {
      final List<Face> faces = await faceDetector.processImage(inputImage);
      setState(() {
        _detectedFaces = faces;
      });
    } catch (e) {
      print('Error detecting faces: $e');
    } finally {
      await faceDetector.close();
    }
  }

  @override
  void dispose() {
    _scanAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: widget.scanColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            // Background image
            if (widget.croppedFile != null)
              Positioned.fill(
                child: Image.file(
                  File(widget.croppedFile!.path),
                  fit: BoxFit.cover,
                ),
              ),

            // Scanning overlay
            if (_isScanning || _scanComplete)
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _scanAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: FaceScanPainter(
                        faces: _detectedFaces,
                        imageSize: _imageSize,
                        scanProgress: _scanAnimation.value,
                        showResults: _scanComplete && widget.showDetectionDetails,
                        scanColor: widget.scanColor,
                        isScanning: _isScanning,
                      ),
                    );
                  },
                ),
              ),

            // Status overlay
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: _buildStatusCard(),
            ),

            // No image placeholder
            if (widget.croppedFile == null)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.image_outlined,
                      size: 64,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No image provided',
                      style: TextStyle(
                        color: Colors.grey.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Card(
      color: Colors.black.withOpacity(0.8),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isScanning) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(widget.scanColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Scanning for faces...',
                    style: TextStyle(
                      color: widget.scanColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
            if (_scanComplete) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _detectedFaces.isNotEmpty ? Icons.check_circle : Icons.warning,
                    color: _detectedFaces.isNotEmpty ? Colors.green: Colors.orange,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _detectedFaces.isNotEmpty
                        ? 'Face detected ✓'
                        : 'No face detected',
                    style: TextStyle(
                      color: _detectedFaces.isNotEmpty ? Colors.green : Colors.orange,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (_detectedFaces.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Faces found: ${_detectedFaces.length}',
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class FaceScanPainter extends CustomPainter {
  final List<Face> faces;
  final Size imageSize;
  final double scanProgress;
  final bool showResults;
  final Color scanColor;
  final bool isScanning;

  FaceScanPainter({
    required this.faces,
    required this.imageSize,
    required this.scanProgress,
    required this.showResults,
    required this.scanColor,
    required this.isScanning,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (imageSize == Size.zero) return;

    final double scaleX = size.width / imageSize.width;
    final double scaleY = size.height / imageSize.height;
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    final double scaledWidth = imageSize.width * scale;
    final double scaledHeight = imageSize.height * scale;
    final double offsetX = (size.width - scaledWidth) / 2;
    final double offsetY = (size.height - scaledHeight) / 2;

    // Draw scanning line
    if (isScanning) {
      _drawScanningLine(canvas, size, offsetX, offsetY, scaledWidth, scaledHeight);
    }

    // Draw face detection results
    if (showResults && faces.isNotEmpty) {
      _drawFaceResults(canvas, scale, offsetX, offsetY);
    }
  }

  void _drawScanningLine(Canvas canvas, Size size, double offsetX, double offsetY,
      double scaledWidth, double scaledHeight) {
    final Paint scanPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          scanColor.withOpacity(0.3),
          scanColor.withOpacity(0.8),
          Colors.white.withOpacity(0.9),
          scanColor.withOpacity(0.8),
          scanColor.withOpacity(0.3),
          Colors.transparent,
        ],
        stops: const [0.0, 0.1, 0.3, 0.5, 0.7, 0.9, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, scaledWidth, 30));

    final double scanY = offsetY + (scaledHeight * scanProgress);
    final Rect scanRect = Rect.fromLTWH(offsetX, scanY - 15, scaledWidth, 30);

    canvas.drawRect(scanRect, scanPaint);

    // Add glow effect
    final Paint glowPaint = Paint()
      ..color = scanColor.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);
    canvas.drawRect(scanRect, glowPaint);
  }

  void _drawFaceResults(Canvas canvas, double scale, double offsetX, double offsetY) {
    final Paint facePaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final Paint landmarkPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final Paint contourPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (final Face face in faces) {
      // Draw face bounding box
      final Rect scaledBoundingBox = Rect.fromLTRB(
        face.boundingBox.left * scale + offsetX,
        face.boundingBox.top * scale + offsetY,
        face.boundingBox.right * scale + offsetX,
        face.boundingBox.bottom * scale + offsetY,
      );
      canvas.drawRect(scaledBoundingBox, facePaint);

      // Draw landmarks
      for (final FaceLandmark? landmark in face.landmarks.values) {
        if (landmark != null) {
          final Offset scaledPosition = Offset(
            landmark.position.x * scale + offsetX,
            landmark.position.y * scale + offsetY,
          );
          canvas.drawCircle(scaledPosition, 4, landmarkPaint);
        }
      }

      // Draw contours
      for (final FaceContour? contour in face.contours.values) {
        if (contour != null) {
          final Path path = Path();
          bool isFirst = true;
          for (final Point<int> point in contour.points) {
            final Offset scaledPoint = Offset(
              point.x.toDouble() * scale + offsetX,
              point.y.toDouble() * scale + offsetY,
            );
            if (isFirst) {
              path.moveTo(scaledPoint.dx, scaledPoint.dy);
              isFirst = false;
            } else {
              path.lineTo(scaledPoint.dx, scaledPoint.dy);
            }
          }
          canvas.drawPath(path, contourPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Example usage widget
class FaceDetectionExample extends StatefulWidget {
  const FaceDetectionExample({Key? key}) : super(key: key);

  @override
  State<FaceDetectionExample> createState() => _FaceDetectionExampleState();
}

class _FaceDetectionExampleState extends State<FaceDetectionExample> {
  CroppedFile? _croppedFile;
  bool _hasFace = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Face Detection Widget'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[900],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Face Detection Scanner Widget
            Expanded(
              child: FaceDetectionScanner(
                croppedFile: _croppedFile,
                onFaceDetected: (hasFace) {
                  setState(() {
                    _hasFace = hasFace;
                  });
                  print('Face detected: $hasFace');
                },
                scanColor: Colors.cyan,
                showDetectionDetails: true,
                height: 400,
              ),
            ),

            const SizedBox(height: 20),

            // Result display
            Card(
              color: Colors.black.withOpacity(0.8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _hasFace ? Icons.check_circle : Icons.cancel,
                      color: _hasFace ? Colors.green: Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _hasFace ? 'Face Detected!' : 'No Face Detected',
                      style: TextStyle(
                        color: _hasFace ? Colors.green: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Mock button to simulate adding a cropped file
            ElevatedButton(
              onPressed: () {
                // This would typically be connected to an image picker/cropper
                // For demo purposes, you'd set _croppedFile here
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Connect this to your image picker/cropper'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan,
                foregroundColor: Colors.black,
              ),
              child: const Text('Select Image'),
            ),
          ],
        ),
      ),
    );
  }
}