import 'package:flutter/material.dart';
import 'package:flutter_app/provideors/product.dart';
import 'package:flutter_app/provideors/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key key}) : super(key: key);
  static const routName = '/edit-product-screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _imageUrlControler = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _fromKey = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _initialValue = {
    'title': '',
    'description': '',
    'imageUrl': '',
    'price': 0.0,
  };
  var isLoadding = false;
  var _isInit = true;

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImageUrl);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _imageUrlControler.dispose();
    _imageUrlFocusNode.dispose();
    _descriptionFocusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct = Provider.of<Products>(
          context,
          listen: false,
        ).findById(productId);
        _initialValue = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'imageUrl': '',
          'price': _editedProduct.price.toString(),
        };
        _imageUrlControler.text = _editedProduct.imageUrl;
      }
    }
  }

  void _updateImageUrl() {
    if (_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlControler.text.startsWith('http') &&
              !_imageUrlControler.text.startsWith('https')) ||
          !_imageUrlControler.text.endsWith('.png') &&
              !_imageUrlControler.text.endsWith('.jpeg') &&
              !_imageUrlControler.text.endsWith('.jpg')) {
        return;
      }
      setState(() {

      });
    }
  }

  Future<void> _saveForm() async {
    final isValid = _fromKey.currentState.validate();
    if (!isValid) {
       return;
    }
    _fromKey.currentState.save();
    setState(() {
      isLoadding = true;
    });

    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen : false)
          .updateProduct(_editedProduct, _editedProduct.id);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Somthing  went wrong'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('okey!'))
            ],
          ),
        );
      }  }
      setState(() {
        isLoadding = false;
      });
      Navigator.of(context).pop();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(onPressed: () => _saveForm(), icon: Icon(Icons.save))
        ],
      ),
      body: isLoadding
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _fromKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initialValue['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter  a value";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: val,
                          description: _editedProduct.description,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      initialValue: _initialValue['price'].toString(),
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter valid price ";
                        }
                        if (double.tryParse(val) == null) {
                          return "please enter valid price ";
                        }
                        if (double.parse(val) <= 0) {
                          return "please enter a number grater than zero";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(val),
                            imageUrl: _editedProduct.imageUrl);
                      },
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                    ),
                    TextFormField(
                      focusNode: _descriptionFocusNode,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      initialValue: _initialValue['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      validator: (val) {
                        if (val.isEmpty) {
                          return "please enter  a description ";
                        }
                        if (val.length < 10) {
                          return " Should be at least 10 character";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          title: _editedProduct.title,
                          description: val,
                          price: _editedProduct.price,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1), color: Colors.grey),
                          child: _imageUrlControler.text.isEmpty
                              ? Center(child: Text('Enter URL'))
                              : FittedBox(
                                  child: Image.network(
                                    _editedProduct.imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _imageUrlControler,
                            focusNode: _imageUrlFocusNode,
                            keyboardType: TextInputType.url,
                            decoration: InputDecoration(labelText: 'ImageUrl'),
                            validator: (val) {
                              if (val.isEmpty) {
                                return "please enter  a valid URL ";
                              }
                              if ((!_imageUrlControler.text
                                          .startsWith('http') &&
                                      !_imageUrlControler.text
                                          .startsWith('https')) ||
                                  !_imageUrlControler.text.endsWith('.png') &&
                                      _imageUrlControler.text
                                          .endsWith('.jpeg') &&
                                      !_imageUrlControler.text
                                          .endsWith('.jpg')) {
                                return "please enter   a valid URL ";
                              }
                              return null;
                            },
                            onSaved: (val) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                price: _editedProduct.price,
                                imageUrl: val,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
