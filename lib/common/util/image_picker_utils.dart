import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';

/// 图片选择工具类
class ImagePickerUtils {
  static ImagePicker _imagePicker;

  static ImagePickerUtils _instance;

  static ImagePickerUtils getInstance() {
    if (null == _instance) {
      _instance = ImagePickerUtils();
      _imagePicker = ImagePicker();
    }

    return _instance;
  }

  void showImagePickerDialog(BuildContext context, Function(Image) onSuccess,
          {bool showError = false}) =>
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width - 30 * 2,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      getImageByCamera(0, context, onSuccess,
                          showError: showError);
                    },
                    title: Align(
                      child: Text(
                        "相册",
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                  Divider(
                    height: 1.0,
                    color: Colors.grey,
                  ),
                  ListTile(
                    onTap: () {
                      getImageByCamera(1, context, onSuccess,
                          showError: showError);
                    },
                    title: Align(
                      child: Text(
                        "相机",
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                  Divider(
                    height: 1.0,
                    color: Colors.grey,
                  ),
                  Container(
                    color: Colors.grey[200],
                    height: 5.0,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    title: Align(
                      child: Text(
                        "取消",
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

  /// type :  0 --> camera ; 1 --> gallery
  Future getImageByCamera(
      int type, BuildContext context, Function(Image) onSuccess,
      {bool showError}) async {
    // PickedFile pickedFile = await _imagePicker.getImage(source: type == 0 ? ImageSource.gallery : ImageSource.camera);
    XFile pickedFile = await _imagePicker.pickImage(
        source: type == 0 ? ImageSource.gallery : ImageSource.camera);
    if (pickedFile != null) {
      if (onSuccess != null)
        onSuccess(Image.file(
          File(pickedFile.path),
          fit: BoxFit.fill,
        ));
    } else {
      if (showError) Toast.show("No image selected.", context);
    }

    //关闭弹窗
    Navigator.pop(context);
  }
}
