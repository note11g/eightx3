import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class MainController extends FullLifeCycleController
    with FullLifeCycleMixin, GetTickerProviderStateMixin {
  final maxTime = 24;
  final List<CameraDescription> _cameras = [];

  CameraController? cameraController;
  final isInitialized = false.obs;
  Completer<void> initCompleter = Completer();

  BoxConstraints previewConstraint = const BoxConstraints();

  final isRecording = false.obs;

  Animation<double>? animation;
  final runningTime = 0.0.obs;
  late AnimationController animationController;

  // test
  final RxList<String> testPaths = RxList();

  @override
  void onInit() async {
    ever(isInitialized, (bool b) {
      if (b) {
        initCompleter.complete();
      } else if (initCompleter.isCompleted) {
        initCompleter = Completer();
      }
    });

    _cameras.assignAll(await availableCameras());
    print(_cameras);

    await initializeNewCamera(_cameras[0]).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });

    super.onInit();
  }

  @override
  void onClose() {
    _disposeCamera();
    super.onClose();
  }

  void onCameraSettingChanged() {
    if (cameraController!.value.isInitialized) {
      print("ready! : addListener");
    }
  }

  Future<void> initializeNewCamera(CameraDescription cameraDescription) async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      await _disposeCamera();
    }
    cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: true,
    )..addListener(onCameraSettingChanged);

    try {
      await cameraController!.initialize();
      await cameraController!.prepareForVideoRecording();
      isInitialized(true);
    } on CameraException catch (e) {
      print(e);
    }
  }

  Future<void> _disposeCamera() async {
    await cameraController?.dispose();
    animationController.dispose();
    isInitialized(false);
  }

  CameraDescription getCameraDescription(
      {bool autoChange = true,
      CameraLensDirection? direction = CameraLensDirection.front}) {
    if (autoChange) {
      direction = cameraController!.description.lensDirection ==
              CameraLensDirection.back
          ? CameraLensDirection.front
          : CameraLensDirection.back;
    }

    for (final camera in _cameras) {
      if (camera.lensDirection == direction) return camera;
    }
    return _cameras[0];
  }

  void startRecord() async {
    isRecording(true);
    await cameraController!.startVideoRecording();

    animationController =
        AnimationController(duration: const Duration(seconds: 24), vsync: this);
    animation = Tween<double>(begin: 0, end: 24).animate(animationController)
      ..addListener(() {
        runningTime(animation!.value);
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) stopRecord(autoComplete: true);
      });
    animationController.forward();
  }

  void stopRecord({bool autoComplete = false}) async {
    late final double elapsedTime;
    if (autoComplete) {
      elapsedTime = 24;
    } else {
      elapsedTime = animation!.value;
      animationController.stop();
    }
    animationController.dispose();

    print("elapsedTime : ${elapsedTime}s");

    isRecording(false);

    final xFile = await cameraController!.stopVideoRecording();
    final file = File(xFile.path);

    print(file);

    // todo : test code
    testPaths.add(xFile.path);

    final vc = VideoPlayerController.file(file);
    await vc.initialize();

    showDialog(
        context: Get.context!,
        builder: (context) {
          vc.play();
          return Center(
              child: vc.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: vc.value.aspectRatio,
                      child: VideoPlayer(vc),
                    )
                  : Container());
        }).whenComplete(() => vc.dispose());

    // test code end
  }

  void goFolder() async {
    // todo : implementation this method.


  }

  @override
  void onDetached() {
    _disposeCamera();
  }

  @override
  void onInactive() {
    _disposeCamera();
  }

  @override
  void onPaused() {
    _disposeCamera();
  }

  @override
  void onResumed() {
    initializeNewCamera(cameraController!.description);
  }
}
