import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_link_example/product_detail_screen.dart';
import 'package:dynamic_link_example/story_screen.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';



class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  void initDynamicLinks() async{
    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData? dynamicLink)async{
        final Uri? deeplink = dynamicLink!.link;

        if(deeplink != null){
          handleMyLink(deeplink);
        }
      },
      onError: (OnLinkErrorException e)async{
        print("We got error $e");

      }

    );
  }



  void handleMyLink(Uri url){
    List<String> sepeatedLink = [];
    /// osama.link.page/Hellow --> osama.link.page and Hellow
    sepeatedLink.addAll(url.path.split('/'));

    print("The Token that i'm interesed in is ${sepeatedLink[1]}");
    Get.to(()=>ProductDetailScreen(sepeatedLink[1]));

  }


  buildDynamicLinks(String title,String image,String docId) async {
    String url = "http://osam.page.link";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/$docId'),
      androidParameters: AndroidParameters(
        packageName: "com.dotcoder.dynamic_link_example",
        minimumVersion: 0,
      ),
      iosParameters: IosParameters(
        bundleId: "Bundle-ID",
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          description: '',
          imageUrl:
          Uri.parse("$image"),
          title: title),
    );
    final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();

    String? desc = '${dynamicUrl.shortUrl.toString()}';

    await Share.share(desc, subject: title,);

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDynamicLinks();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading:  Icon(Icons.menu,color: Colors.black,),
        centerTitle: true,
        title: Text("Ayyan Shop",style: TextStyle(color: Colors.black),),
        actions: [
          Icon(Icons.input,color: Colors.black,),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Container(
          color: Colors.white,
          width: Get.width,
          height: Get.height,
          child: Column(
            children: [


              SizedBox(
                height: 10,
              ),


              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: const [
                    Text("Advertisment",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),

                  ],
                ),
              ),


              Container(
                width: Get.width,
                height: Get.width*0.2,
                margin: EdgeInsets.only(left: 10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('ads').snapshots(),
                  builder: (ctx,snapshot){
                    if(!snapshot.hasData){
                      return Center(child: CircularProgressIndicator(),);
                    }

                    List<DocumentSnapshot> ads = snapshot.data!.docs;

                    return ListView.builder(itemBuilder: (ctx,index){

                      String image = ads[index].get('image');

                      return InkWell(
                        onTap: (){

                          Get.to(()=> StoryScreen(image, 'image'));

                        },
                        child: Container(
                          width: Get.width*0.15,
                          height: Get.width*0.15,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(image,),
                                  fit: BoxFit.contain
                              )

                          ),
                        ),
                      );
                    },itemCount: ads.length,scrollDirection: Axis.horizontal,);
                  },
                ),

              ),


              Container(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                child: Row(
                  children: const [
                    Text("Popular Ads",style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),

                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('ads').snapshots(),
                  builder: (ctx,snapshot){

                    if(!snapshot.hasData){
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }


                    List<DocumentSnapshot> ads = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: ads.length,

                      itemBuilder: (ctx,index){


                        String title = '',image = '',price='';

                        try{
                          title = ads[index].get('title');
                        }catch(e){
                          title = '';
                        }

                        try{
                          image = ads[index].get('image');
                        }catch(e){
                          image = '';
                        }

                        try{
                          price = ads[index].get('price');
                        }catch(e){
                          price = '';
                        }

                        return Container(
                          width: Get.width,
                          height: Get.width*0.72,

                          child: Column(
                            children: [



                              InkWell(
                                onTap: (){
                                  Get.to(()=> ProductDetailScreen(ads[index].id));
                                },
                                child: Container(
                                  width: Get.width,
                                  height: Get.width*0.5,
                                  child: Image.network(image,fit: BoxFit.cover,),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              Text(title,style: TextStyle(fontWeight: FontWeight.bold),),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Price: \$$price",style: TextStyle(fontWeight: FontWeight.bold),),
                                  IconButton(onPressed: (){
                                    buildDynamicLinks(title, image, ads[index].id);
                                  }, icon: Icon(Icons.share)),
                                ],
                              ),

                              Divider(),

                            ],
                          ),
                        );

                      },);
                  },
                ),
              ),

            ],
          )
      ),
    ));
  }
}


