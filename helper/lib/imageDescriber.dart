import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:test/askAI.dart';
import 'language.dart';
import 'package:flutter/material.dart';
import 'app.dart';
class ImageDescriber extends StatefulWidget {
  final dynamic file;
  var isFile=true;
  ImageDescriber({Key? key, required this.file,this.isFile=true}) : super(key: key);

  @override
  State<ImageDescriber> createState() => _ImageDescriberState(file,isFile);
}

class _ImageDescriberState extends State<ImageDescriber> {
  late final dynamic file;
  var isFile=true;
  var _ = Language.translate;
  String result = "";
  _ImageDescriberState(this.file,this.isFile);
  void initState(){
    super.initState();
  getResponce();
  }
  void getResponce() async{
    try{
    var model=GenerativeModel(model: 'models/gemini-1.5-flash-latest', apiKey: App.apiKey );
    var content=TextPart("""The following is a detailed description of an image intended to provide a vivid and comprehensive understanding for blind users. Describe the scene, objects, actions, and any other relevant details with specific locations, distances, and sizes where possible. Clearly and concisely describe each element to help the listener visualize the scene. If objects are unclear, indicate this. If text is present in the image, output the text along with its location.
                                      
[IMAGE DESCRIPTION START]
The image shows a bustling city street during the day. On the left side of the image, approximately 100 meters from the bottom, there is a row of tall buildings with glass windows reflecting the sunlight. The street is lined with trees spaced about 20 meters apart, each around 10 meters tall. There are people walking on the sidewalk, some holding shopping bags; the sidewalk is about 3 meters wide.
A yellow taxi is parked at the curb on the left side of the street, around 50 meters from the bottom of the image, and a red double-decker bus is driving down the street, approximately 150 meters from the bottom of the image. In the background, the sky is clear with a few scattered clouds.
A street vendor is selling hot dogs from a cart near the corner of the street, positioned about 30 meters from the bottom left corner. A group of children is playing near a fountain in the park, visible in the distance on the right side of the image, roughly 200 meters from the bottom right corner. The fountain is large, with water cascading down multiple tiers, and the children are running around it, laughing and playing. Some objects in the background are not clear.
[IMAGE DESCRIPTION END]
Provide a similarly detailed description for the given image """);
    dynamic image;
    if (isFile){
      image=DataPart("image/jpeg", await File(file).readAsBytes());
    } else{
      image=DataPart("image/jpeg", file);
    }
    final response = await model.generateContent([Content.multi([content,image])]);
    setState(() {
      result=response.text??"";
    });
    } catch(error){
      setState(() {
        result=_("an error detected");
      });
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(_("helperAI")),
        actions: [
                if (!result.isEmpty)
            ElevatedButton(onPressed: () async{
              dynamic image;
                  if (this.isFile){
      image=DataPart("image/jpeg", await File(this.file).readAsBytes());
    } else{
      image=DataPart("image/jpeg", this.file);
    }
    Navigator.push(context, MaterialPageRoute(builder: (context)=>AskAI(file: image)));

            }, child: Text(_("ask helperAI about this image"))),

        ],
      ),
      body: Center(
        child: Column(
          children: [
                        if (result.isEmpty)
            Text(_("describing ... please wait"))
            else
            MarkdownBody(data: result),

          ],
        ),
      ),
    );
  }
}