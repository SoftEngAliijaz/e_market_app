import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_market_app/constants/constants.dart';
import 'package:e_market_app/models/product_model/categories_model.dart';
import 'package:e_market_app/models/product_model/product_model.dart';
import 'package:e_market_app/widgets/custom_text_field.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  bool isSaving = false;
  bool isUploading = false;

  ///variables
  String? selectedCategory;
  final imagePicker = ImagePicker();
  List<XFile> images = [];
  List<String> imageUrls = [];
  List<CategoriesModel> categoriess = [];
  var uuid = Uuid();

  clearControllers() {
    categoryController.clear();
    idController.clear();
    productNameController.clear();
    productDescriptionController.clear();
    brandController.clear();
    priceController.clear();
    discountPriceController.clear();
    serialCodeController.clear();
  }

  Widget buildLogo() {
    return CircleAvatar(
      radius: 100,
      backgroundImage: AssetImage('assets/images/e_commerce_logo.png'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Add Products'),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      ///logo
                      buildLogo(),

                      ///SizedBox
                      sizedbox(),

                      /// DropdownButtonFormField
                      DropdownButtonFormField(
                        hint: Text('Choose Category'),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.category),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
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

                      ///SizedBox
                      sizedbox(),

                      ///text fields
                      CustomTextField(
                        prefixIcon: FontAwesomeIcons.productHunt,
                        keyboardType: TextInputType.name,
                        textEditingController: productNameController,
                        hintText: "Enter Product Name...",
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "should not be empty";
                          }
                          return null;
                        },
                      ),

                      ///SizedBox
                      sizedbox(),
                      CustomTextField(
                        prefixIcon: Icons.description,
                        keyboardType: TextInputType.name,
                        textEditingController: productDescriptionController,
                        hintText: "Enter Product Description...",
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "should not be empty";
                          }
                          return null;
                        },
                      ),

                      ///SizedBox
                      sizedbox(),
                      CustomTextField(
                        prefixIcon: Icons.price_change,
                        keyboardType: TextInputType.number,
                        textEditingController: priceController,
                        hintText: "Enter Product price...",
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "should not be empty";
                          }
                          return null;
                        },
                      ),

                      ///SizedBox
                      sizedbox(),
                      CustomTextField(
                        prefixIcon: Icons.discount,
                        keyboardType: TextInputType.number,
                        textEditingController: discountPriceController,
                        hintText: "Enter Product Discount Price...",
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "should not be empty";
                          }
                          return null;
                        },
                      ),

                      ///SizedBox
                      sizedbox(),
                      CustomTextField(
                        prefixIcon: FontAwesomeIcons.code,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        textEditingController: serialCodeController,
                        hintText: "Enter Product Serial Code...",
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "should not be empty";
                          }
                          return null;
                        },
                      ),

                      ///SizedBox
                      sizedbox(),
                      CustomTextField(
                        prefixIcon: FontAwesomeIcons.brandsFontAwesome,
                        keyboardType: TextInputType.name,
                        textEditingController: brandController,
                        hintText: "Enter Product brand...",
                        validator: (v) {
                          if (v!.isEmpty) {
                            return "should not be empty";
                          }
                          return null;
                        },
                      ),

                      ///SizedBox
                      sizedbox(),
                      if (images.length < 10)
                        MaterialButton(
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            images.length < 10
                                ? "Pick ${10 - images.length} more image(s) to complete"
                                : "Pick Images",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            pickImage();
                          },
                        ),

                      ///SizedBox
                      sizedbox(),

                      ///container to show picked images
                      if (images.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(),
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
                                      child: Image.file(
                                        File(images[index].path),
                                        height: 200,
                                        width: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        _removeImage(index);
                                        // setState(() {
                                        //   images.removeAt(index);
                                        // });
                                      },
                                      icon: Center(
                                        child: const Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.red,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                      ///SwitchListTile
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

                      ///SwitchListTile
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

                      ///save button
                      MaterialButton(
                        color: Theme.of(context).primaryColor,
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _saveProductsMethod();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )),
    );
  }

  void _removeImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  _saveProductsMethod() async {
    setState(() {
      isSaving = true;
    });

    try {
      if (!validateFields()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill in all required fields")),
        );
        return;
      }

      await uploadImages();

      DateTime createdAt = DateTime.now();

      await FirebaseFirestore.instance.collection('products').add(
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
              createdAt:
                  createdAt, // Ensure that createdAt is assigned a non-null value
            ).toJson(),
          );

      clearControllers();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Added Successfully")),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("An error occurred. ${e.toString()}")),
      );
    }
  }

  bool validateFields() {
    if (selectedCategory == null || selectedCategory!.isEmpty) {
      return false;
    }

    if (productNameController.text.isEmpty ||
        productDescriptionController.text.isEmpty ||
        priceController.text.isEmpty ||
        brandController.text.isEmpty ||
        discountPriceController.text.isEmpty ||
        serialCodeController.text.isEmpty) {
      return false;
    }
    return true;
  }

  pickImage() async {
    final List<XFile>? pickImage =
        await imagePicker.pickMultiImage(imageQuality: 100);

    if (pickImage != null) {
      setState(() {
        images.addAll(pickImage);
      });
    } else {
      Fluttertoast.showToast(msg: 'No Images Selected');
    }
  }

  Future postImages(XFile? imageFile) async {
    setState(() {
      isUploading = true;
    });

    String? urls;
    Reference ref =
        FirebaseStorage.instance.ref().child("images").child(imageFile!.name);

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

  Future<void> uploadImages() async {
    for (var image in images) {
      try {
        String? downLoadUrl = await postImages(image);

        if (downLoadUrl != null) {
          setState(() {
            imageUrls.add(downLoadUrl);
          });
        } else {
          Fluttertoast.showToast(msg: "Error: Image upload failed");
        }
      } catch (e) {
        print("Error uploading image: $e");
        Fluttertoast.showToast(msg: "Error: Image upload failed");
      }
    }
  }
}
