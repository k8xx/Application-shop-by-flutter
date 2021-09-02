import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shop1/providers/product.dart';
import '../providers/products.dart';
import 'dart:io';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-products';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  File imageFile;
  _showphoto(BuildContext context){
    return showDialog(
        context: context,
        builder: (context)=>
            AlertDialog(
              title: Text('Make a Choose'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.image),
                      title: Text('Gallery'),
                      onTap: ()=> _imageFormGallery(context),
                    ),
                    ListTile(
                      leading: Icon(Icons.camera),
                      title: Text('Camera'),
                      onTap: ()=> _imageFormCamera(context),
                    ),
                  ],
                ),
              ),
            )
    );
  }

  Future _imageFormGallery (BuildContext context) async{
var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile = image;
    });
    Navigator.pop(context);
  }
  Future _imageFormCamera (BuildContext context) async{
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      imageFile = image;
    });
    Navigator.pop(context);
  }


  final _priceFucosNode = FocusNode();
  final _descriptionFucosNode = FocusNode();
  final _imageUlrController = TextEditingController();
  final _imageUrlFucosNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _editedProduct =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');
  var _initialValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFucosNode.addListener(_updateImageUrl);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initialValue = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUlrController.text = _editedProduct.imageUrl;
      }
      _isInit = false;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _imageUrlFucosNode.removeListener(_updateImageUrl);
    _priceFucosNode.dispose();
    _imageUrlFucosNode.dispose();
    _imageUlrController.dispose();
    _descriptionFucosNode.dispose();
  }

  void _updateImageUrl() {
    // if (!_imageUrlFucosNode.hasFocus) {
    //   if ((!_imageUlrController.text.startsWith('http') &&
    //           !_imageUlrController.text.startsWith('https')) ||
    //       (!_imageUlrController.text.endsWith('.png') &&
    //               !_imageUlrController.text.endsWith('.jpg') ||
    //           !_imageUlrController.text.endsWith('.jpeg'))) {
    //     return;
    //   }
    //   setState(() {});
    // }
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (e) {
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: [
              FlatButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(ctx).pop(),
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
            ),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initialValue['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFucosNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please Provide a Value. ';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            price: _editedProduct.price,
                            title: value,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: _initialValue['price'],
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFucosNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFucosNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a valid price. ';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number. ';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number grater then zero. ';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            price: double.parse(value),
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite);
                      },
                    ),
                    TextFormField(
                      initialValue: _initialValue['description'],
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFucosNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a valid description. ';
                        }
                        if (value.length < 10) {
                          return 'Should be at least 10 characters long. ';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            price: _editedProduct.price,
                            title: _editedProduct.title,
                            description: value,
                            imageUrl: _editedProduct.imageUrl,
                            isFavorite: _editedProduct.isFavorite);
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
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: imageFile != null
                              ? Image.file(
                            imageFile,
                            fit: BoxFit.cover,
                          ):
                              Text('Enter Your Image'),
                        ),
                        Expanded(
                          child: TextFormField(
                           // controller: _imageUlrController,
                            decoration: InputDecoration(
                              labelText: 'Image URL',
                            ),
                            keyboardType: TextInputType.url,
                            focusNode: _imageUrlFucosNode,
                          //  validator: (value) {
                              // if (value.isEmpty) {
                              //   return 'Please enter a Image URL. ';
                              // }
                              // if (!value.startsWith('http') &&
                              //     !value.startsWith('https')) {
                              //   return 'Please enter a Valid URL. ';
                              // }
                              // if (!value.endsWith('png') &&
                              //     !value.endsWith('jpg') &&
                              //     !value.endsWith('jpeg')) {
                              //   return 'Please enter a Valid URL. ';
                              // }
                           //   return null;
                          //  },
                            onSaved: (value) {
                              _editedProduct = Product(
                                  id: _editedProduct.id,
                                  price: _editedProduct.price,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  imageUrl: _imageUlrController.text,
                                  isFavorite: _editedProduct.isFavorite);
                            },
                          ),
                        ),
                      ],

                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=> _showphoto(context),
        child: Icon(Icons.add_photo_alternate),
      ),
    );
  }
}


//
// _imageUlrController.text.isEmpty
// ? Text("Enter a image")
// : FittedBox(
// child: Image.network(
// _imageUlrController.text,
// fit: BoxFit.cover,
// ),
// ),