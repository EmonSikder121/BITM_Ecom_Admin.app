import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecom_pb_bitm/models/date_model.dart';
import 'package:ecom_pb_bitm/models/purchase_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../models/product_model.dart';
import '../providers/product_provider.dart';
import '../utils/helper_functions.dart';

class AddProductPage extends StatefulWidget {
  static const String routeName = '/addproduct';

  const AddProductPage({Key? key}) : super(key: key);

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  late ProductProvider _productProvider;
  final _nameController = TextEditingController();
  final _shortDescriptionController = TextEditingController();
  final _longDescriptionController = TextEditingController();
  final _purchasePriceController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _discountController = TextEditingController();
  final _quantityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? thumbnailImageLocalPath;
  CategoryModel? categoryModel;
  DateTime? purchaseDate;
  late StreamSubscription<ConnectivityResult> subscription;
  bool _isConnected = true;

  @override
  void initState() {
    isConnectedToInternet().then((value) {
      setState(() {
        _isConnected = value;
      });
    });
    subscription = Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result == ConnectivityResult.wifi ||
            result == ConnectivityResult.mobile;
      });
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _productProvider = Provider.of<ProductProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: _buildForm(),
    );
  }

  Form _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!_isConnected)
            const ListTile(
              tileColor: Colors.red,
              title: Text(
                'No internet connectivity',
                style: TextStyle(color: Colors.white),
              ),
            ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Card(
                    child: thumbnailImageLocalPath == null
                        ? const Icon(
                            Icons.photo,
                            size: 100,
                          )
                        : Image.file(
                            File(thumbnailImageLocalPath!),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                  ),


                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          _getImage(ImageSource.camera);
                        },
                        icon: const Icon(Icons.camera),
                        label: const Text('Open Camera'),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          _getImage(ImageSource.gallery);
                        },
                        icon: const Icon(Icons.photo_album),
                        label: const Text('Open Gallery'),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Consumer<ProductProvider>(
            builder: (context, provider, child) =>
                DropdownButtonFormField<CategoryModel>(
              hint: const Text('Select Category'),
              value: categoryModel,
              isExpanded: false,
              validator: (value) {
                if (value == null) {
                  return 'Please select a category';
                }
                return null;
              },
              items: provider.categoryList
                  .map((catModel) => DropdownMenuItem<CategoryModel>(
                        value: catModel,
                        child: Text(catModel.categoryName),
                        // child: ElevatedButton(onPressed: () {}, child: Text(catModel.categoryName)),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  categoryModel = value;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Enter Product Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              maxLines: 2,
              controller: _shortDescriptionController,
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Enter Short Description(optional)',
              ),
              validator: (value) {
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              maxLines: 3,
              controller: _longDescriptionController,
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Enter Long Description(optional)',
              ),
              validator: (value) {
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _purchasePriceController,
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Enter Purchase Price',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                if (num.parse(value) <= 0) {
                  return 'Price should be greater than 0';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _salePriceController,
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Enter Sale Price',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                if (num.parse(value) <= 0) {
                  return 'Price should be greater than 0';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _quantityController,
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Enter Quantity',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                if (num.parse(value) <= 0) {
                  return 'Quantity should be greater than 0';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: _discountController,
              decoration: const InputDecoration(
                filled: true,
                labelText: 'Enter Discount',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field must not be empty';
                }
                if (num.parse(value) < 0) {
                  return 'Discount should not be a negative value';
                }
                return null;
              },
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: _selectDate,
                    icon: const Icon(Icons.calendar_month),
                    label: const Text('Select Purchase Date'),
                  ),
                  Text(purchaseDate == null
                      ? 'No date chosen'
                      : getFormattedDate(purchaseDate!)),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ElevatedButton(onPressed: _saveProduct, child: const Text('Save Data')),
          )
        ],
      ),
    );
  }

  void _selectDate() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 2),
      lastDate: DateTime.now(),
    );
    if (selectedDate != null) {
      setState(() {
        purchaseDate = selectedDate;
      });
    }
  }

  void _getImage(ImageSource imageSource) async {
    final pickedImage = await ImagePicker().pickImage(
      source: imageSource,
      imageQuality: 70,
    );
    if (pickedImage != null) {
      setState(() {
        thumbnailImageLocalPath = pickedImage.path;
      });
    }
  }


  void _saveProduct() async {

    //image validate **
    if (thumbnailImageLocalPath == null) {
      showMsg(context, 'Please select a product image');
      return;
    }

    //Date validate **
    if (purchaseDate == null) {
      showMsg(context, 'Please select a purchase date');
      return;
    }

    if (_formKey.currentState!.validate()) {
      String? downloadUrl;
      EasyLoading.show(status: 'Please wait', dismissOnTap: false);
      try {
        downloadUrl =
            await _productProvider.uploadImage(thumbnailImageLocalPath!);
        final productModel = ProductModel(
          thumbnailImageUrl: downloadUrl,
          productName: _nameController.text,
          shortDescription: _shortDescriptionController.text,
          longDescription: _longDescriptionController.text,
          stock: num.parse(_quantityController.text),
          salePrice: num.parse(_salePriceController.text),
          category: categoryModel!,
          productDiscount: num.parse(_discountController.text),
          additionalImages: [
            '',
            '',
            '',
          ],
        );
        final purchaseModel = PurchaseModel(
          dateModel: DateModel(
            timestamp: Timestamp.now(),
            day: DateTime.now().day,
            month: DateTime.now().month,
            year: DateTime.now().year,
          ),
          purchasePrice: num.parse(
            _purchasePriceController.text,
          ),
          purchaseQuantity: num.parse(
            _quantityController.text,
          ),
        );
        await _productProvider.addNewProduct(productModel, purchaseModel);
        _resetFields();
        EasyLoading.dismiss();
        showMsg(context, 'Added');


      } catch (error) {
        showMsg(context, 'Something went wrong ${error.toString()}');
        EasyLoading.dismiss();
        print(error.toString());
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _shortDescriptionController.dispose();
    _longDescriptionController.dispose();
    _purchasePriceController.dispose();
    _quantityController.dispose();
    _discountController.dispose();
    _salePriceController.dispose();
    subscription.cancel();
    super.dispose();
  }

  void _resetFields() {
    setState(() {
      _nameController.clear();
      _shortDescriptionController.clear();
      _longDescriptionController.clear();
      _purchasePriceController.clear();
      _quantityController.clear();
      _discountController.clear();
      _salePriceController.clear();
      categoryModel = null;
      purchaseDate = null;
      thumbnailImageLocalPath = null;
    });
  }
}
