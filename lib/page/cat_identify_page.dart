import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';

/// 拍照页面
class CatIdentifyPage extends StatefulWidget {
  const CatIdentifyPage({Key? key}) : super(key: key);

  @override
  _CatIdentifyPageState createState() => _CatIdentifyPageState();
}

class _CatIdentifyPageState extends State<CatIdentifyPage>
    with WidgetsBindingObserver {
  late List<CameraDescription> cameras;

  /// 相机控制器
  CameraController? controller;

  /// 拍摄完的整个屏幕相机图
  ui.Image? image;

  /// 用于截图的key
  GlobalKey _globalKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initCameras();
    WidgetsBinding.instance?.addObserver(this);
  }

  /// 初始化相机
  _initCameras() async {
    cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      controller = CameraController(cameras[0], ResolutionPreset.max,
          enableAudio: false);
      controller?.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});
      });
    } else {
      // 相机不可用
    }
  }

  @override
  Widget build(BuildContext context) {
    return (controller?.value.isInitialized ?? false)
        ? Container(
            width: ScreenUtil().screenWidth,
            height: ScreenUtil().screenHeight,
            child: Stack(
              children: [
                image == null
                    ? Container()
                    : RepaintBoundary(
                  key: _globalKey,
                  // 用于截取方框位置图片的Widget，对用户来说不可见
                  child: Container(
                    width: 200,
                    height: 200,
                    child: CustomPaint(
                      painter: ImageClipper(image!),
                    ),
                  ),
                ),
                CameraPreview(
                  controller!,
                ),
                Container(
                  padding: EdgeInsets.only(top: 150.w),
                  child: Align(
                    alignment: Alignment.topCenter,
                      child: Image.asset(
                    "assets/images/cat.png",
                    width: 280.w,
                    height: 280.w,
                  )),
                ),
                Positioned(
                  bottom: 0,
                    child: Container(
                  height: 200.w,
                  color: Colors.white,
                  width: ScreenUtil().screenWidth,
                  child: GestureDetector(
                    onTap: (){
                      _takePhoto();
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Image.asset(
                      "assets/images/photo.png",
                      width: 60.w,
                      height: 60.w,
                    ),
                  ),
                ))
              ],
            ),
          )
        : Container();
  }

  /// 点击拍照 首先获取拍摄的完整照片 其次截取头像框部分图像
  void _takePhoto() async{
    if (!(controller?.value.isInitialized ?? false)) {
      return;
    }
    if (controller!.value.isTakingPicture) {
      return;
    }
    XFile xFile = await controller!.takePicture();
    Uint8List uint8list = await xFile.readAsBytes();
    ui.Codec codec = await ui.instantiateImageCodec(uint8list);
    ui.FrameInfo fi = await codec.getNextFrame();
    setState(() {
      image = fi.image;
    });
    /// 延时截取方框中的图片 防止截取不到
    Future.delayed(Duration(milliseconds: 100), () async {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
      await image.toByteData(format: ImageByteFormat.png);
      Uint8List? _photoBytes = byteData?.buffer.asUint8List();
      if(_photoBytes == null){
        return;
      }
      Directory directory = await getTemporaryDirectory();
      Directory tempDirectory = Directory(directory.path + "/catIdentifyTemp");
      bool hasCreateDirectory = tempDirectory.existsSync();
      // 创建文件夹
      if (!hasCreateDirectory) {
        tempDirectory.createSync();
      }
      String targetPath = directory.path + "/${DateTime.now().millisecondsSinceEpoch}.png";
      File tempFile = File(targetPath);
      bool hasFile = tempFile.existsSync();
      // 创建临时文件
      if (!hasFile) {
        tempFile.createSync();
      }
      // 将截图存到本地缓存文件夹
      File newFile = await tempFile.writeAsBytes(_photoBytes);
      String bs64 = base64Encode(await newFile.readAsBytes());
      Navigator.of(context).pop(bs64);
    });
    // var result = await FlutterImageCompress.compressWithList(
    //   uint8list,
    //   quality: 60,
    // );
  }

  @override
  void didChangeAppLifecycleState(ui.AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    // 设置生命周期监听的目的是 切换到后台释放相机，切回前台后重新初始化相机，否则会出现无法拍照问题
    if (controller == null || !controller!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller!.description);
      }
    }
    super.didChangeAppLifecycleState(state);
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller?.dispose();
    }
    controller = CameraController(cameraDescription, ResolutionPreset.high,
        enableAudio: false);
    // If the controller is updated then update the UI.
    controller!.addListener(() {
      if (mounted) setState(() {});
    });
    try {
      await controller!.initialize();
    } on CameraException catch (e) {}
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }
}

/// 自定义图片裁剪区域
class ImageClipper extends CustomPainter {

  final ui.Image image;

  ImageClipper(
      this.image,
      );

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    canvas.drawImageRect(
        image,
        Rect.fromLTRB(image.width * 0.12, image.height * 0.25,
            image.width * 0.88, image.height * 0.25 + (image.width * 0.76)),
        Rect.fromLTWH(0, 0, size.width, size.height),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
