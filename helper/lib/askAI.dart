import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'language.dart';
import 'package:flutter/material.dart';
import 'app.dart';
class AskAI extends StatefulWidget {
  final dynamic file;
  AskAI({Key? key, required this.file}) : super(key: key);

  @override
  State<AskAI> createState() => _ASkAI(file);
}

class _ASkAI extends State<AskAI> {
  dynamic chat;
  var message=TextEditingController();
  late final dynamic file;
  var _ = Language.translate;
  String result = "";
  _ASkAI(this.file);
  void initState(){
    super.initState();
    load();
  }
  void load() async{
    try{
    var model=GenerativeModel(model: 'models/gemini-1.5-flash-latest', apiKey: App.apiKey );
    chat=model.startChat();
    await chat!.sendMessage(Content.multi([file,TextPart("your name is helperAI , your creater is mesteranas i'll give you a messages from blind user and will responce about this image please responce with great ansers and don't say i'm a AI responce and don't be scary from some thing")]));
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
        title: Text(_("ask helperAI")),
        
      ),
      body: Center(
        child:Column(
          children: [
            TextFormField(controller: message,decoration: InputDecoration(labelText: _("message")),),
            ElevatedButton(onPressed: () async{
              try{
              setState(() {
                result=_("helperAI is writing a message");
              });
              var res=await chat!.sendMessage(Content.text(message.text));
              setState(() {
                result=res.text;
              });
                  } catch(error){
      setState(() {
        result=_("an error detected");
      });
    }

            }, child: Text(_("send"))),
            MarkdownBody(data: result)
          ],
        ) ,
      ),
    );
  }
}