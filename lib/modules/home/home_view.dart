import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_rc/modules/home/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Recorder App'),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Container(
                    color: Colors.white,
                    child: Obx(
                      () => controller.cameraValue.value.isInitialized
                          ? CameraPreview(controller.cameraController)
                          : const SizedBox(),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Container(
                        height: 64,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.transparent.withOpacity(.2),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Obx(
                              () => Text(
                                formatDuration(
                                  DateTime.now()
                                      .difference(controller.startTime.value),
                                ),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                            InkWell(
                              onTap: () => controller.isRecording.value
                                  ? controller.stopRecording()
                                  : controller.startRecording(),
                              child: Obx(
                                () => controller.isRecording.value
                                    ? const Icon(
                                        Icons.pause_circle,
                                        size: 48,
                                        color: Colors.redAccent,
                                      )
                                    : const Icon(
                                        Icons.play_circle,
                                        size: 48,
                                        color: Colors.redAccent,
                                      ),
                              ),
                            ),
                            InkWell(
                              onTap: () => controller.switchCamera(),
                              child: controller.isRecording.value
                                  ? const Icon(
                                      Icons.sync_disabled,
                                      size: 30,
                                      color: Colors.grey,
                                    )
                                  : const Icon(
                                      Icons.autorenew,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    if (!controller.isRecording.value) {
      return '00:00';
    }
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
