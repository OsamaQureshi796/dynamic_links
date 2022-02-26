import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:story_view/story_view.dart';

class StoryScreen extends StatelessWidget {

  StoryScreen(this.urlOfStory,this.type);

  String urlOfStory;
  String type;




  StoryController storyController = StoryController();

  /// Text-story  --> StoryItem.text
  /// Video-story  --> StoryItem.pageVideo
  /// Image-story  ---> StoryItem.image

  List<StoryItem> storyItems  = [];


  @override
  Widget build(BuildContext context) {

    if(type == 'image'){
      storyItems.add(StoryItem.pageImage(url: urlOfStory, controller: storyController));
    }


    return Scaffold(
      body: StoryView(
        storyItems: storyItems,
        onStoryShow: (s){},
        onComplete: (){
          Get.back();
        },
        progressPosition: ProgressPosition.top,
        controller: storyController,
      )
    );
  }
}
