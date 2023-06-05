import 'dart:async';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:video_rc/modules/home/video_preview.dart';

class HomeController extends GetxController {
  RxBool isLoading = RxBool(true);
  RxBool isRecording = RxBool(false);
  late CameraController cameraController;
  late Rx<CameraValue> cameraValue;
  Rx<DateTime> startTime = DateTime.now().obs;
  Timer? timer;

  @override
  void onInit() {
    _initCamera();
    super.onInit();
  }

  @override
  void onClose() {
    cameraController.dispose();
    super.onClose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final selectedCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    cameraController = CameraController(
      selectedCamera,
      ResolutionPreset.max,
    );
    await cameraController.initialize();
    cameraValue = Rx<CameraValue>(cameraController.value);
    isLoading.value = false;
  }

  startRecording() async {
    if (!isRecording.value) {
      await cameraController.prepareForVideoRecording();
      await cameraController.startVideoRecording();
      isRecording.value = true;
      startTime.value = DateTime.now(); // Start the timer
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        startTime.refresh(); // Refresh the startTime value to trigger UI update
      });
    }
  }

  stopRecording() async {
    if (isRecording.value) {
      isRecording.value = false;
      timer?.cancel();
      startTime.value = DateTime.now();
      playVideo();
    }
  }

  playVideo() async {
    final file = await cameraController.stopVideoRecording();
    Get.to(() => VideoPreviewPage(videoPath: file.path)); // navigating to preview page whit video path
  }

  
  switchCamera() async {
    if (!isRecording.value) {
      final cameras = await availableCameras();
      final currentLensDirection = cameraController.description.lensDirection;
      final selectedCamera = cameras.firstWhere(
        (camera) => camera.lensDirection != currentLensDirection,
        orElse: () => cameraController.description,
      );

      await cameraController.dispose();
      cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.max,
      );
      await cameraController.initialize();

      if (isRecording.value) {
        await cameraController.prepareForVideoRecording();
        await cameraController.startVideoRecording();
      }

      cameraValue.value = cameraController.value;
      update();
    }
  }
}
