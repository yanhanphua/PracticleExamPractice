import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/model/product.dart';

class EditProduct extends StatefulWidget {
  const EditProduct({Key? key,required this.id}) : super(key: key);
  final String id;

  @override
  State<EditProduct> createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {

  final TextEditingController _titleController = TextEditingController();
  var _titleError = "";
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  late Product _product;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProduct();
  }

  Future getProduct() async{
    var collection = FirebaseFirestore.instance.collection("products");
    var querySnapshot = await collection.get();
    for(var item in querySnapshot.docs){
      var data = item.data();
      var product = Product.fromMap(data);
      if(product.id == widget.id){
        _titleController.text = product.title;
        _ratingController.text = product.rating.toString();
        _priceController.text = product.price.toString();

        setState(() {
          _product = product;
        });
      }
    }
  }

  _updateProduct()async{
    DocumentReference documentReference = FirebaseFirestore.instance.collection("products").doc(widget.id);
    var productData = Product(
        id:widget.id,
        title:_titleController.text,
        price:int.parse(_priceController.text),
        rating:double.parse(_ratingController.text)
    ).toMap();

    documentReference.update(productData);
    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("update"),
          Container(
            padding:const EdgeInsets.all(20.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                  hintText: "title",
                  errorText:_titleError.isEmpty ? null : _titleError,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  )
              ),
            ),
          ),
          Container(
            padding:const EdgeInsets.all(20.0),
            child: TextField(
              keyboardType:TextInputType.number,
              controller: _ratingController,
              decoration: InputDecoration(
                  hintText: "rating",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  )
              ),
            ),
          ),
          Container(
            padding:const EdgeInsets.all(20.0),
            child: TextField(
              keyboardType:TextInputType.number,
              controller: _priceController,
              decoration: InputDecoration(
                  hintText: "price",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)
                  )
              ),
            ),
          ),
          ElevatedButton(onPressed: ()=> _updateProduct(), child: Text("update"))
        ],
      ),
    );
  }
}

