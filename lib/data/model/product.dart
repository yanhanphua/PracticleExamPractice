class Product{
  final String id;
  final String title;
  final int price;
  final double rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.rating
  });

  Map<String,dynamic> toMap(){
    return {
      "id":id,
      "title":title,
      "price":price,
      "rating":rating,
    };
  }

  static fromMap(Map<String,dynamic> map){
    return Product(
      id:map["id"],
      title: map["title"],
      price: map["price"],
      rating: map["rating"] is double ? map["rating"].toDouble():map["price"]
    );
  }

  @override
  String toString(){
    return "Product(title:$title price:$price rating:$rating)";
  }
}