import 'package:camera/camera.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'package:eightx3/resource/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'main_controller.dart';

class MainPage extends GetView<MainController> {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Obx(() =>
          controller.isInitialized.value && controller.cameraController != null
              ? CameraPreview(controller.cameraController!,
                  child: LayoutBuilder(builder: (context, constraint) {
                  controller.previewConstraint = constraint;
                  return Obx(() => Stack(
                        children: [
                          GestureDetector(onVerticalDragEnd: (d) {
                            if (d.velocity.pixelsPerSecond.dy > 300 ||
                                d.velocity.pixelsPerSecond.dy < -300) {
                              controller.initializeNewCamera(
                                  controller.getCameraDescription());
                            }
                          }),
                          if (controller.isRecording.value)
                            Obx(() => Container(
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).padding.top),
                                  width: (MediaQuery.of(context).size.width /
                                          controller.maxTime) *
                                      controller.runningTime.value,
                                  height: 8,
                                  color: Colors.red,
                                ))
                          else
                            Positioned(
                                right: 0,
                                top: MediaQuery.of(context).padding.top,
                                child: InkWell(
                                    onTap: () {
                                      HapticFeedback.vibrate();
                                      controller.goFolder();
                                    },
                                    child: const Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 20, horizontal: 24),
                                        child: DecoratedIcon(
                                          Icons.folder,
                                          color: Colors.white,
                                          shadows: [
                                            BoxShadow(
                                                offset: Offset(0, 0),
                                                blurRadius: 6,
                                                color: Color(0x52000000))
                                          ],
                                        )))),
                        ],
                      ));
                }))
              : Container(
                  constraints: controller.previewConstraint,
                  color: Colors.black)),
      Expanded(
          child: InkWell(
              onTap: () {
                HapticFeedback.vibrate();
                controller.isRecording.value
                    ? controller.stopRecord()
                    : controller.startRecord();
              },
              child: Center(
                  child: Obx(() => Icon(
                        controller.isRecording.value
                            ? Icons.stop
                            : Icons.videocam,
                        size: 28,
                        color: controller.isRecording.value
                            ? Colors.redAccent
                            : ColorPallets.gray600,
                      )))))
    ]));
  }
}
