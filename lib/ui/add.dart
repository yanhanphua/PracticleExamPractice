import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/model/product.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  final TextEditingController _titleController = TextEditingController();
  var _titleError = "";
  final TextEditingController _ratingController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  _addToDatabase()async{
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference products = firestore.collection("products");
    var id = products.doc().id;
    var productData = Product(
      id:id,
      title:_titleController.text,
      price:int.parse(_priceController.text),
      rating:double.parse(_ratingController.text)
    ).toMap();
    products.doc(id).set(productData);
    context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("add"),
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
            ElevatedButton(onPressed: ()=> _addToDatabase(), child: Text("add"))
          ],
        ),
    );
  }
}
