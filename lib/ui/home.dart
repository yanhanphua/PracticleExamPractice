import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_practice_two/ui/edit.dart';

import '../data/model/product.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<Product> _products = [];

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
      setState(() {
        _products.add(product);
      });
    }
  }

  _navigateToAdd()async{
    var result = await context.push("/add");
    if(result != null){
      _products = [];
      getProduct();
    }
  }

  _navigateToEdit(String id)async{
    var result = await Navigator.push(context,MaterialPageRoute(builder: (context) => EditProduct(id: id)));
    if (result != null) {
      _products = [];
      getProduct();
    }
  }

  deleteProduct(String id){
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference documentReference = firestore.collection("products").doc(id);
    documentReference.delete();
    setState(() {
      _products.removeWhere((product) => product.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:
        Column(
          children: [
            _products.isEmpty ?
            Container(
              height: MediaQuery.of(context).size.height - 100,
              child: const Center(
                child: Text(
                  "No products",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ) :
            const Text("Products"),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.white),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Text("${product.title}"),
                              Row(
                                children: [
                                  Text("${product.price}"),
                                  Icon(Icons.star),
                                  Text("${product.rating}g"),
                                ],
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _navigateToEdit(product.id),
                          child: Icon(Icons.edit),
                        ),
                        GestureDetector(
                          onTap: () => deleteProduct(product.id),
                          child: Icon(Icons.delete),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        alignment: Alignment.bottomRight,
        margin: const EdgeInsets.only(bottom:16,right: 16),
        child: FloatingActionButton(
          onPressed: () => _navigateToAdd(),
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
