import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatelessWidget {

  String productId;
  ProductDetailScreen(this.productId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: Icon(Icons.arrow_back,color: Colors.black,),
        ),
        centerTitle: true,
        title: const Text("Product Detail",style: TextStyle(color: Colors.black),),

      ),

      body: Column(
        children: [




          Container(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('ads').doc(productId).snapshots(),
              builder: (ctx,snapshot){

                if(!snapshot.hasData){
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }


                DocumentSnapshot productData = snapshot.data!;

                String title = '',image = '',price='',description = '';

                try{
                  title = productData.get('title');
                }catch(e){
                  title = '';
                }

                try{
                  image = productData.get('image');
                }catch(e){
                  image = '';
                }

                try{
                  price = productData.get('price');
                }catch(e){
                  price = '';
                }

                try{
                  description = productData.get('description');
                }catch(e){
                  description = '';
                }


                return Container(

                  child: Column(
                    children: [



                      Container(
                        width: Get.width,
                        height: Get.width*0.5,
                        child: Image.network(image,fit: BoxFit.cover,),
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      Text(title,style: TextStyle(fontWeight: FontWeight.bold),),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Price: \$$price",style: TextStyle(fontWeight: FontWeight.bold),),
                          IconButton(onPressed: (){}, icon: Icon(Icons.share)),
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Padding(padding: EdgeInsets.symmetric(horizontal: 20),child: Text(description,textAlign: TextAlign.center,),),




                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
