import 'package:permission_handler/permission_handler.dart';
import 'package:test/imageDescriber.dart';

import 'language.dart';
import 'package:flutter/material.dart ';
import 'package:camera/camera.dart';
class viewCamera extends StatefulWidget{
  viewCamera({Key?key}):super(key:key);
  @override
  State<viewCamera> createState()=>_ViewCamera();
}
class _ViewCamera extends State<viewCamera>{
  int selectedCamera=0;
  List<CameraDescription> ?cameras;
  CameraController? controler;
  var isFlash=false;
  var _=Language.translate;
  _ViewCamera();
  Future <void> setupCamera() async{
    await Permission.storage.request();
    cameras=await availableCameras();
    controler=CameraController(cameras![selectedCamera], ResolutionPreset.high);
    controler!.initialize();
    setState(() {

    });
  }
  void initState(){
    super.initState();
    setupCamera();
  }
  @override
  void dispose(){
    controler!.dispose();
    super.dispose();
  }
  Widget build(BuildContext context){
  return Scaffold(
      appBar:AppBar(
        title: Text(_("camera")),
        actions: [
          IconButton(onPressed: (){
            var flash=FlashMode.auto;
            if (isFlash){
              flash=FlashMode.off;
            } else{
              flash=FlashMode.torch;
            }
            isFlash=!isFlash;
            controler!.setFlashMode(flash);
            setState(() {
              
            });
          }, icon: Icon(isFlash?Icons.flash_on:Icons.flash_off),tooltip: isFlash?_("turn flash off"):_("turn flash on"),),
          IconButton(onPressed: (){
            if (selectedCamera==cameras!.length-1){
              selectedCamera=0;
            } else{
              selectedCamera+=1;
            }
            setupCamera();
            setState(() {
              
            });
          }, icon: Icon(Icons.switch_camera),tooltip:_("switch camera") ,),
        ],),         
        body:Container(alignment: Alignment.center
        ,child: Column(children: [
          CameraPreview(controler!),
          IconButton(onPressed: () async{
            final image=await controler!.takePicture();
            Navigator.pop(context);
            print("taked");
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ImageDescriber(file: image.path)));
          }, icon: Icon(Icons.camera),tooltip:_("take photo"),),
          

    ])),);
  }
}
