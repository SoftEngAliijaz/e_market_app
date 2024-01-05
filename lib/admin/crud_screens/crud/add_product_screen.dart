import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/models/product_model/categories_model.dart';
import 'package:e_market_app/models/product_model/product_model.dart';
import 'package:e_market_app/widgets/custom_text_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class AddProductScreen extends StatefulWidget {
  static const String id = "addproduct";

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  ///controllers
  TextEditingController categoryController = TextEditingController();
  TextEditingController idController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController discountPriceController = TextEditingController();
  TextEditingController serialCodeController = TextEditingController();

  ///variables in boolean
  bool isOnSale = false;
  bool isPopular = false;
  bool isFavourite = false;
  bool isSaving = false;
  bool isUploading = false;

  ///variables
  String? selectedCategory;
  final imagePicker = ImagePicker();
  List<XFile> images = [];
  List<String> imageUrls = [];
  var uuid = Uuid();

  @override
  void dispose() {
    /// Clearing
    categoryController.clear();
    idController.clear();
    productNameController.clear();
    productDescriptionController.clear();
    brandController.clear();
    priceController.clear();
    discountPriceController.clear();
    serialCodeController.clear();

    /// Disposing
    categoryController.dispose();
    idController.dispose();
    productNameController.dispose();
    productDescriptionController.dispose();
    brandController.dispose();
    priceController.dispose();
    discountPriceController.dispose();
    serialCodeController.dispose();

    ///Called when this object is removed from the tree permanently.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Container(
          child: Center(
            child: Column(
              children: [
                // DropdownButtonFormField
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 17, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: DropdownButtonFormField(
                    hint: const Text("choose category"),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(10),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return "category must be selected";
                      }
                      return null;
                    },
                    value: selectedCategory,
                    items: categories
                        .map(
                          (e) => DropdownMenuItem<String>(
                            value: e.title,
                            child: Text(e.title!),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value.toString();
                      });
                    },
                  ),
                ),
                CustomTextField(
                  textEditingController: productNameController,
                  hintText: "enter product name...",
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "should not be empty";
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  textEditingController: productDescriptionController,
                  hintText: "enter product detail...",
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "should not be empty";
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  textEditingController: priceController,
                  hintText: "enter product price...",
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "should not be empty";
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  textEditingController: discountPriceController,
                  hintText: "enter product discount Price...",
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "should not be empty";
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  textEditingController: serialCodeController,
                  hintText: "enter product serial code...",
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "should not be empty";
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  textEditingController: brandController,
                  hintText: "enter product brand...",
                  validator: (v) {
                    if (v!.isEmpty) {
                      return "should not be empty";
                    }
                    return null;
                  },
                ),

                ElevatedButton(
                  child: Text("PICK IMAGES"),
                  onPressed: () {
                    pickImage();
                  },
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                    ),
                    itemCount: images.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black),
                              ),
                              child: File(images[index].path).path.isEmpty
                                  ? ElevatedButton(
                                      child: Text("PICK IMAGES"),
                                      onPressed: () {
                                        pickImage();
                                      },
                                    )
                                  : Image.network(
                                      File(images[index].path).path,
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  images.removeAt(index);
                                });
                              },
                              icon: const Icon(Icons.cancel_outlined),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                ),

                SwitchListTile(
                  title: Text(
                    isOnSale == false
                        ? 'Is this Product on Sale?'
                        : 'Is ON SALE',
                  ),
                  value: isOnSale,
                  onChanged: (v) {
                    setState(() {
                      isOnSale = !isOnSale;
                    });
                  },
                ),
                SwitchListTile(
                  title: Text(
                    isPopular == false
                        ? 'Is this Product Popular?'
                        : 'is POPULAR',
                  ),
                  value: isPopular,
                  onChanged: (v) {
                    setState(() {
                      isPopular = !isPopular;
                    });
                  },
                ),
                ElevatedButton(
                  child: Text("SAVE"),
                  onPressed: () {
                    _saveProductsMethod();
                  },
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  _saveProductsMethod() async {
    setState(() {
      isSaving = true;
    });
    await uploadImages();
    await FirebaseFirestore.instance
        .collection('products')
        .add(
          ProductModel(
            category: selectedCategory,
            id: uuid.v4(),
            productName: productNameController.text,
            productDescription: productDescriptionController.text,
            price: int.parse(priceController.text),
            brand: brandController.text,
            discountPrice: int.parse(discountPriceController.text),
            serialCode: serialCodeController.text,
            imageUrls: imageUrls,
            isSale: isOnSale,
            isPopular: isPopular,
          ).toJson(),
        )
        .whenComplete(() {
      setState(() {
        isSaving = false;
        imageUrls.clear();
        images.clear();
        clearFields();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Added Successfully")),
        );
      });
    });
  }

  clearFields() {
    setState(() {
      categoryController.clear();
      idController.clear();
      productNameController.clear();
      productDescriptionController.clear();
      brandController.clear();
      priceController.clear();
      discountPriceController.clear();
      serialCodeController.clear();
    });
  }

  pickImage() async {
    final List<XFile>? pickImage = await imagePicker.pickMultiImage();
    if (pickImage != null) {
      setState(() {
        images.addAll(pickImage);
      });
    } else {
      print("no images selected");
    }
  }

  Future postImages(XFile? imageFile) async {
    setState(() {
      isUploading = true;
    });
    String? urls;
    Reference ref =
        FirebaseStorage.instance.ref().child("images").child(imageFile!.name);
    if (kIsWeb) {
      await ref.putData(
        await imageFile.readAsBytes(),
        SettableMetadata(contentType: "image/jpeg"),
      );
      urls = await ref.getDownloadURL();
      setState(() {
        isUploading = false;
      });
      return urls;
    }
  }

  uploadImages() async {
    for (var image in images) {
      await postImages(image).then(
        (downLoadUrl) => imageUrls.add(downLoadUrl),
      );
    }
  }
}
