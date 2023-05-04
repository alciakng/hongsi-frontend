import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hongsi_project/widgets/common/custom_flat_button.dart';
import 'package:hongsi_project/helper/utility.dart';

class CustomImagePicker {
  const CustomImagePicker({
    Key? key,
    required this.targetContext,
    required this.onImageSelected,
  });

  final BuildContext targetContext;
  final Function(File) onImageSelected;

  Future<dynamic> openImagePicker() {
    return showModalBottomSheet(
      context: targetContext,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              const Text(
                'Pick an image',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    child: CustomFlatButton(
                      label: "Use Camera",
                      borderRadius: 5,
                      onPressed: () {
                        getImage(context, ImageSource.camera, onImageSelected);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: CustomFlatButton(
                      label: "Use Gallery",
                      borderRadius: 5,
                      onPressed: () {
                        getImage(context, ImageSource.gallery, onImageSelected);
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  getImage(BuildContext context, ImageSource source,
      Function(File) onImageSelected) {
    ImagePicker().pickImage(source: source, imageQuality: 50).then((
      XFile? file,
    ) {
      //FIXME
      onImageSelected(File(file!.path));
      Navigator.pop(context);
    });
  }
}
