import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:manziliapp/model/category_store.dart';
import 'package:manziliapp/widget/add_product/add_category_dialog.dart';
import 'package:manziliapp/widget/add_product/image_picker_widget.dart';
import 'package:manziliapp/widget/home/categorysection.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  CategoryStore? _selectedCategory;
  final List<String> _selectedImages = [];
  List<CategoryStore> _categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    final url = Uri.parse('http://man.runasp.net/api/Category/List');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        if (body['isSuccess'] == true && body['data'] != null) {
          setState(() {
            _categories = List<CategoryStore>.from(
              body['data'].map((cat) => CategoryStore(
                    id: cat['id'].toString(),
                    name: cat['name'],
                  )),
            );
          });
        }
      }
    } catch (e) {
      // Optionally handle error
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showAddCategoryDialog() {
    showDialog(
      context: context,
      builder: (ctx) => const AddCategoryDialog(),
    );
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final url = Uri.parse('http://man.runasp.net/api/Product/Create?storeId=1');
      final request = http.MultipartRequest('POST', url);

      request.fields['Name'] = _nameController.text;
      request.fields['Price'] = _priceController.text;
      request.fields['ProductCategoryId'] = _selectedCategory!.id;
      request.fields['Description'] = _descriptionController.text;
      request.fields['Quantity'] = '1';

      // Attach images if any (assuming _selectedImages contains file paths)
      for (var imagePath in _selectedImages) {
        request.files.add(await http.MultipartFile.fromPath('formImages', imagePath));
      }

      try {
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        final body = json.decode(response.body);

        if (response.statusCode == 200 && body['isSuccess'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(body['message'] ?? 'تم حفظ المنتج بنجاح')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(body['message'] ?? 'حدث خطأ أثناء حفظ المنتج')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء الاتصال بالخادم')),
        );
      }
    } else if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء اختيار تصنيف')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'إضافة منتج جديد',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {_saveProduct;},
            child: const Text(
              'إعادة تعيين',
              style: TextStyle(color: Color(0xFF1548C7)),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'اسم المنتج',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'برجر لحم',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال اسم المنتج';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'قم بتحميل صورة المنتج',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ImagePickerWidget(
                    isMainImage: true,
                    onImageSelected: (image) {
                      if (image != null && _selectedImages.isEmpty) {
                        setState(() {
                          _selectedImages.add(image);
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  ImagePickerWidget(
                    onImageSelected: (image) {
                      if (image != null && _selectedImages.length < 3) {
                        setState(() {
                          _selectedImages.add(image);
                        });
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  ImagePickerWidget(
                    onImageSelected: (image) {
                      if (image != null && _selectedImages.length < 3) {
                        setState(() {
                          _selectedImages.add(image);
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Prepare images before uploading. Upload images larger than 750px × 450px. Max number of images is 5. Max image size is 134MB.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              const Text(
                'التصنيف',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              CategoryDropdown(
                categories: _categories,
                selectedCategory: _selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                onAddNewCategory: _showAddCategoryDialog,
              ),
              const SizedBox(height: 16),
              const Text(
                'السعر',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: '50',
                  suffixText: '\$',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال السعر';
                  }
                  if (double.tryParse(value) == null) {
                    return 'الرجاء إدخال رقم صحيح';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'تفاصيل المنتج',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Bibendum in vel, mattis mauris turpis.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرجاء إدخال تفاصيل المنتج';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1548C7), // Button background color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12), // Optional padding
                  textStyle: const TextStyle(fontSize: 18), // Text size
                ),
                child: const Text('حفظ التغييرات'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryDropdown extends StatefulWidget {
  final List<CategoryStore> categories;
  final CategoryStore? selectedCategory;
  final Function(CategoryStore) onCategorySelected;
  final VoidCallback onAddNewCategory;

  const CategoryDropdown({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onAddNewCategory,
  });

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.selectedCategory?.name ?? (widget.categories.isNotEmpty ? widget.categories[0].name : ''), 
                  style: TextStyle(
                    color: widget.selectedCategory == null
                        ? Colors.grey
                        : Colors.black,
                  ),
                ),
                Icon(
                  _isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ...widget.categories.map((category) => ListTile(
                      title: Text(category.name),
                      onTap: () {
                        widget.onCategorySelected(category);
                        setState(() {
                          _isExpanded = false;
                        });
                      },
                    )),
                ListTile(
                  leading: const Icon(Icons.add_circle_outline,
                      color: Color(0xFF1548C7)),
                  title: const Text(
                    'إضافة صنف جديد',
                    style: TextStyle(color: Color(0xFF1548C7)),
                  ),
                  onTap: () {
                    widget.onAddNewCategory();
                    setState(() {
                      _isExpanded = false;
                    });
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }
}
