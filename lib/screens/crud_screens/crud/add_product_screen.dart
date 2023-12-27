import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shopbiz_app/screens/home/home_screen.dart';
import 'package:shopbiz_app/widgets/custom_button.dart';
import 'package:shopbiz_app/widgets/custom_text_field.dart';
import 'package:shopbiz_app/models/product_model/product_model.dart';

class AddProductScreen extends StatefulWidget {
  final String? getId;
  final String? getName;
  final String? getDescription;
  final String? getPrice;

  const AddProductScreen({
    Key? key,
    this.getId,
    this.getName,
    this.getDescription,
    this.getPrice,
  }) : super(key: key);

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  var globalkey = GlobalKey<FormState>();
  File? _pickedImage;

  Future<void> addProducts() async {
    try {
      if (globalkey.currentState!.validate()) {
        await _uploadImage();
        Fluttertoast.showToast(msg: 'Product Added Successfully');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const HomeScreen(),
          ),
        );
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Center(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Form(
              key: globalkey,
              child: Container(
                height: size.height * 0.90,
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          child: const CircleAvatar(
                            radius: 100,
                            backgroundImage:
                                AssetImage('assets/images/e_commerce_logo.png'),
                          ),
                        ),
                        sizedbox(),
                        CustomTextField(
                          textEditingController: _idController,
                          prefixIcon: Icons.numbers_outlined,
                          hintText: 'Enter Product ID',
                          validator: (v) {
                            if (v!.isEmpty) {
                              return 'Field Should not be Empty';
                            } else {
                              return null;
                            }
                          },
                        ),
                        sizedbox(),
                        CustomTextField(
                          textEditingController: _nameController,
                          prefixIcon: Icons.production_quantity_limits_outlined,
                          hintText: 'Enter Product Name',
                          validator: (v) {
                            if (v!.isEmpty) {
                              return 'Field Should not be Empty';
                            } else {
                              return null;
                            }
                          },
                        ),
                        sizedbox(),
                        CustomTextField(
                          textEditingController: _descriptionController,
                          prefixIcon: Icons.production_quantity_limits_outlined,
                          hintText: 'Enter Product Description',
                          validator: (v) {
                            if (v!.isEmpty) {
                              return 'Field Should not be Empty';
                            } else {
                              return null;
                            }
                          },
                        ),
                        sizedbox(),
                        CustomTextField(
                          textEditingController: _priceController,
                          prefixIcon: Icons.production_quantity_limits_outlined,
                          hintText: 'Enter Product Price',
                          validator: (v) {
                            if (v!.isEmpty) {
                              return 'Field Should not be Empty';
                            } else {
                              return null;
                            }
                          },
                        ),
                        sizedbox(),
                        Container(
                          height: 200,
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _pickedImage != null
                              ? Image.file(
                                  _pickedImage!,
                                  height: 100,
                                  width: 100,
                                )
                              : IconButton(
                                  onPressed: () {
                                    _showModalBottomSheetSuggestions();
                                  },
                                  icon: Icon(Icons.image_outlined),
                                ),
                        ),
                        sizedbox(),
                        CustomButton(
                          title: 'Add Product',
                          onPressed: () async {
                            await addProducts();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showModalBottomSheetSuggestions() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('Pick From Camera'),
                  onTap: () => {_pickFromCamera()},
                ),
                ListTile(
                  leading: const Icon(Icons.image_search_outlined),
                  title: const Text('Pick From Gallery'),
                  onTap: () => {_pickFromGallery()},
                ),
              ],
            ),
          );
        });
  }

  Future<void> _pickFromCamera() async {
    Navigator.pop(context);
    try {
      final XFile? pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 100);
      if (pickedImage != null) {
        setState(() {
          _pickedImage = File(pickedImage.path);
        });
        Fluttertoast.showToast(msg: 'Image Picked From Camera');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> _pickFromGallery() async {
    Navigator.pop(context);
    try {
      final XFile? pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 100);
      if (pickedImage != null) {
        setState(() {
          _pickedImage = File(pickedImage.path);
        });
        Fluttertoast.showToast(msg: 'Image Picked From Gallery');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> _uploadImage() async {
    try {
      if (_pickedImage == null) {
        Fluttertoast.showToast(msg: 'No image selected');
        return;
      }

      String imageName = DateTime.now().millisecondsSinceEpoch.toString();

      Reference ref =
          FirebaseStorage.instance.ref().child('images/$imageName.jpg');

      await ref.putFile(_pickedImage!).then((taskSnapshot) async {
        String imageUrl = await taskSnapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance.collection('products').add(
              ProductModel(
                id: _idController.text,
                name: _nameController.text,
                description: _descriptionController.text,
                price: double.parse(_priceController.text),
                imageUrl: imageUrl,
              ).toJson(),
            );

        Fluttertoast.showToast(msg: 'Image uploaded successfully');
      });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error uploading image: $e');
    }
  }

  Widget sizedbox() {
    return SizedBox(
      height: 20,
    );
  }
}


// import 'dart:io';
// import 'dart:ui';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shopbiz_app/constants/constants.dart';
// import 'package:shopbiz_app/screens/home/home_screen.dart';
// import 'package:shopbiz_app/widgets/custom_button.dart';
// import 'package:shopbiz_app/widgets/custom_text_field.dart';

// class AddProductScreen extends StatefulWidget {
//   final String? getId;
//   final String? getName;
//   final String? getDescription;
//   final String? getPrice;

//   const AddProductScreen({
//     Key? key,
//     this.getId,
//     this.getName,
//     this.getDescription,
//     this.getPrice,
//   }) : super(
//           key: key,
//         );

//   @override
//   State<AddProductScreen> createState() => _AddProductScreenState();
// }

// class _AddProductScreenState extends State<AddProductScreen> {
//   ///controllers
//   final TextEditingController _idController = TextEditingController();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _priceController = TextEditingController();

//   ///globaly key
//   var globalkey = GlobalKey<FormState>();

//   ///global for picked image
//   File? _pickedImage;

//   ///add Products Function
//   Future<void> addProducts() async {
//     try {
//       if (globalkey.currentState!.validate()) {
//         await _uploadImage();
//         Fluttertoast.showToast(msg: 'Product Added Successfully');
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => const HomeScreen(),
//           ),
//         );
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }

//   @override
//   void dispose() {
//     _idController.dispose();
//     _nameController.dispose();
//     _descriptionController.dispose();
//     _priceController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Add Product'),
//       ),
//       body: SizedBox(
//         height: size.height,
//         width: size.width,
//         child: Center(
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//             child: Form(
//               key: globalkey,
//               child: Container(
//                 height: size.height * 0.90,
//                 width: size.width,
//                 child: Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ///logo
//                         Container(
//                           child: const CircleAvatar(
//                             radius: 100,
//                             backgroundImage:
//                                 AssetImage('assets/images/e_commerce_logo.png'),
//                           ),
//                         ),
//                         sizedbox(),

//                         ///
//                         CustomTextField(
//                           textEditingController: _idController,
//                           prefixIcon: Icons.numbers_outlined,
//                           hintText: 'Enter Product ID',
//                           validator: (v) {
//                             if (v!.isEmpty) {
//                               return 'Field Should not be Empty';
//                             } else {
//                               return null;
//                             }
//                           },
//                         ),
//                         sizedbox(),
//                         CustomTextField(
//                           textEditingController: _nameController,
//                           prefixIcon: Icons.production_quantity_limits_outlined,
//                           hintText: 'Enter Product Name',
//                           validator: (v) {
//                             if (v!.isEmpty) {
//                               return 'Field Should not be Empty';
//                             } else {
//                               return null;
//                             }
//                           },
//                         ),
//                         sizedbox(),

//                         CustomTextField(
//                           textEditingController: _descriptionController,
//                           prefixIcon: Icons.production_quantity_limits_outlined,
//                           hintText: 'Enter Product Description',
//                           validator: (v) {
//                             if (v!.isEmpty) {
//                               return 'Field Should not be Empty';
//                             } else {
//                               return null;
//                             }
//                           },
//                         ),
//                         sizedbox(),

//                         CustomTextField(
//                           textEditingController: _priceController,
//                           prefixIcon: Icons.production_quantity_limits_outlined,
//                           hintText: 'Enter Product Price',
//                           validator: (v) {
//                             if (v!.isEmpty) {
//                               return 'Field Should not be Empty';
//                             } else {
//                               return null;
//                             }
//                           },
//                         ),
//                         sizedbox(),

//                         ///Add Section to pick and upload images.
//                         Container(
//                           height: 200,
//                           width: size.width,
//                           decoration: BoxDecoration(
//                             color: Colors.grey.withOpacity(0.2),
//                             border: Border.all(),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           child: _pickedImage != null
//                               ? Image.file(
//                                   _pickedImage!,
//                                   height: 100,
//                                   width: 100,
//                                 )
//                               : IconButton(
//                                   onPressed: () {
//                                     _showModalBottomSheetSuggestions();
//                                   },
//                                   icon: Icon(Icons.image_outlined),
//                                 ),
//                         ),

//                         sizedbox(),

//                         CustomButton(
//                           title: 'Add Product',
//                           onPressed: () async {
//                             await addProducts();
//                           },
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showModalBottomSheetSuggestions() {
//     showModalBottomSheet(
//         shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//         context: context,
//         builder: (BuildContext context) {
//           return Container(
//             child: Wrap(
//               children: [
//                 ListTile(
//                   leading: const Icon(Icons.camera_alt_outlined),
//                   title: const Text('Pick From Camera'),
//                   onTap: () => {_pickFromCamera()},
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.image_search_outlined),
//                   title: const Text('Pick From Gallery'),
//                   onTap: () => {_pickFromGallery()},
//                 ),
//               ],
//             ),
//           );
//         });
//   }

//   Future<void> _pickFromCamera() async {
//     Navigator.pop(context);
//     try {
//       final XFile? pickedImage = await ImagePicker()
//           .pickImage(source: ImageSource.camera, imageQuality: 100);
//       if (pickedImage != null) {
//         setState(() {
//           _pickedImage = File(pickedImage.path);
//         });
//         Fluttertoast.showToast(msg: 'Image Picked From Camera');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }

//   Future<void> _pickFromGallery() async {
//     Navigator.pop(context);
//     try {
//       final XFile? pickedImage = await ImagePicker()
//           .pickImage(source: ImageSource.gallery, imageQuality: 100);
//       if (pickedImage != null) {
//         setState(() {
//           _pickedImage = File(pickedImage.path);
//         });
//         Fluttertoast.showToast(msg: 'Image Picked From Gellery');
//       }
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }

//   Future<void> _uploadImage() async {
//     try {
//       if (_pickedImage == null) {
//         Fluttertoast.showToast(msg: 'No image selected');
//         return;
//       }

//       String imageName = DateTime.now().millisecondsSinceEpoch.toString();

//       Reference ref =
//           FirebaseStorage.instance.ref().child('images/$imageName.jpg');

//       await ref.putFile(_pickedImage!).then((taskSnapshot) async {
//         String imageUrl = await taskSnapshot.ref.getDownloadURL();

//         // Add other product fields along with the imageUrl to the Firestore document
//         await FirebaseFirestore.instance.collection('products').add({
//           'id': _idController.text,
//           'name': _nameController.text,
//           'description': _descriptionController.text,
//           'price': _priceController.text,
//           'imageUrl': imageUrl,
//         });

//         // Now you can save the imageUrl to Firestore or use it as needed
//         Fluttertoast.showToast(msg: 'Image uploaded successfully');
//       });
//     } catch (e) {
//       Fluttertoast.showToast(msg: 'Error uploading image: $e');
//     }
//   }
// }
