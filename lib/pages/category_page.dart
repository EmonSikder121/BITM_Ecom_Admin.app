import 'package:ecom_pb_bitm/db/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product_provider.dart';
import '../utils/widget_functions.dart';

class CategoryPage extends StatelessWidget {
  static const String routeName = '/category';
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showSingleTextInputDialog(
              context: context,
              title: 'Category',
              positiveButtonText: 'ADD',
              onSubmit: (value) {
                Provider.of<ProductProvider>(context, listen: false)
                    .addNewCategory(value);
              });
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          return provider.categoryList.isEmpty
              ? const Center(
                  child: Text('No category found'),
                )
              : ListView.builder(
                  itemCount: provider.categoryList.length,
                  itemBuilder: (context, index) {
                    final catModel = provider.categoryList[index];
                    return ListTile(
                      title: Text(catModel.categoryName),
                      leading: IconButton(
                        icon: const Icon(Icons.delete), onPressed: () {
                        //My Made
                        // DbHelper.deleteCategory(catModel);
                        provider.DelateCategory(catModel);
                      },
                      ),
                      trailing: Text('Total: ${catModel.productCount}'),
                    );
                  },
                );
        },
      ),
    );
  }
}
