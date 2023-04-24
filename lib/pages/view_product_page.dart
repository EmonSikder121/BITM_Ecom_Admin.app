import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/category_model.dart';
import '../providers/product_provider.dart';
import 'product_details_page.dart';

class ViewProductPage extends StatefulWidget {
  static const String routeName = '/viewproduct';
  const ViewProductPage({Key? key}) : super(key: key);

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  CategoryModel? categoryModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: kIsWeb ? null : AppBar(
        title: const Text('Products'),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField<CategoryModel>(
                  hint: const Text('Select Category'),
                  value: categoryModel,
                  isExpanded: true,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  items: [],
                  onChanged: (value) {

                  },
                ),
              ),
              provider.productList.isEmpty ?
              const Expanded(child: Center(child: Text('No item found'),)) :
              Expanded(
                child: ListView.builder(
                  itemCount: provider.productList.length,
                  itemBuilder: (context, index) {
                    final product = provider.productList[index];
                    return ListTile(
                      onTap: () => Navigator.pushNamed(
                          context,
                          ProductDetailsPage.routeName,
                          arguments: product),
                      leading: CachedNetworkImage(
                        width: 75,
                        imageUrl: product.thumbnailImageUrl,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) {
                          print(error.toString());
                          return const Icon(Icons.error);
                        },
                      ),
                      title: Text(product.productName),
                      subtitle: Text(product.category.categoryName),
                      trailing: Text('Stock: ${product.stock}'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
