import 'package:chats_app/logics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'encryptiondecription.dart';

class Chat extends StatefulWidget {
  final String user;
  final String privatekey;
  const Chat(this.user,this.privatekey);
  
  @override
  State<Chat> createState() => _ChatState();
}
class _ChatState extends State<Chat> {
secureScreen() async{
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("hi");
    secureScreen();
  }
  String get name{
    return widget.user;
  }
  final TextEditingController titleController = TextEditingController();
  var decrypt=false;
   @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    }
  @override
  Widget build(BuildContext context) {
    var chatServices = Provider.of<ChatServices>(context);
    return Scaffold(
      appBar: AppBar(title:Text(name),backgroundColor:  Color.fromARGB(153, 50, 59, 229)),
      body:
      chatServices.isLoading?const Center(
              child: CircularProgressIndicator(),
            ):
      RefreshIndicator(
        onRefresh: 
        () {
    return Future.delayed(
      Duration(seconds: 1),
      () {
        setState(() {
          decrypt=true;
        });
      });
        },
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 55.00),
              child: ListView.builder(
                  itemCount: chatServices.messages.length,
                  padding: EdgeInsets.only(top: 10,bottom: 10),
                  itemBuilder: (context, index){
                    return InkWell(
                      onDoubleTap: () {
                        setState(() {
                          chatServices.messages[index].messageType == name?null:
                          chatServices.messages[index].messageContent=MyEncryptionDecryption.decryptAES(chatServices.messages[index].messageContent);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
                        child: Align(
                          alignment: (chatServices.messages[index].messageType != name?Alignment.topLeft:Alignment.topRight),
                          child: Container(
                                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: (chatServices.messages[index].messageType != name?Colors.grey.shade200:Colors.blue[200]),
                                  ),
                                  padding: EdgeInsets.all(16),
                                  child: Text(chatServices.messages[index].messageType == name?MyEncryptionDecryption.decryptAES(chatServices.messages[index].messageContent):chatServices.messages[index].messageContent, style: TextStyle(fontSize: 15),),
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ),
      Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                padding: EdgeInsets.only(left: 10,bottom: 10,top: 10),
                height: 60,
                width: double.infinity,
                color: Colors.white,
                child: Row(
                  children: <Widget>[
                    /*GestureDetector(
                      onTap: (){
                      },
                      child: Container(
                        height: 30,
                        width: 30,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(Icons.add, color: Colors.white, size: 20, ),
                      ),
                    ),*/
                    //SizedBox(width: 15,),
                    Expanded(
                      child: TextField(
                        controller: titleController,
                        decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none
                        ),
                      ),
                    ),
                    SizedBox(width: 15,),
                    FloatingActionButton(
                      onPressed: (){
                        setState(() {
                          chatServices.addMessage(
                          titleController.text,name
                        );
                        });
                        titleController.clear();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },   
                      child: Icon(Icons.send,color: Colors.white,size: 18,),
                      backgroundColor: Colors.blue,
                      elevation: 0,
                    ),
                  ],
                  
                ),
              ),
            ),
         ] ),
      ),
    );
  }
}
