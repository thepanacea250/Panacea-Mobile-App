import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartServices{
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> addToCart(document){
    cart.doc(user!.uid).set({
      'user' : user!.uid,
      'sellerUid' : document.data()['seller']['sellerUid'],
      'shopName' : document.data()['seller']['shopName'],
    });

    return cart.doc(user!.uid).collection('products').add({
      'productId' : document.data()['productId'],
      'productName' : document.data()['productName'],
      'productImage' : document.data()['productImage'],
      'weight' : document.data()['weight'],
      'price' : document.data()['price'],
      'comparedPrice' : document.data()['comparedPrice'],
      'sku' : document.data()['sku'],
      'qty' : 1,
      'total' : document.data()['price'],
    });
  }

  Future<void> updateCartQty(docId, qty,total) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid).collection('products').doc(docId);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("The product does not exist in the cart!");
      }

      transaction.update(documentReference, {
        'qty': qty,
        'total' : total ,
      });

      return qty;
    })
        .then((value) => print("Cart updated"))
        .catchError((error) => print("Cart update failed"));
  }

  Future<void> removeFromCart(docId) async{
    cart.doc(user!.uid).collection('products').doc(docId).delete();
  }

  Future<void> checkData() async{
    final snapshot = await cart.doc(user!.uid).collection('products').get();
    if (snapshot.docs.length == 0) {
      cart.doc(user!.uid).delete();
    }
  }

  Future<void> deleteCart() async{
    final result = await cart.doc(user!.uid).collection('products').get().then((snapshot){
      for (DocumentSnapshot ds in snapshot.docs){
        ds.reference.delete();
      }
    });
  }

  Future<String> checkSeller() async{
    final snapshot = await cart.doc(user!.uid).get();
    return snapshot.exists ? (snapshot.data() as Map)['shopName'] : null;
  }

  Future<DocumentSnapshot> getShopName() async{
    DocumentSnapshot doc = await cart.doc(user!.uid).get();
    return doc;
  }
}