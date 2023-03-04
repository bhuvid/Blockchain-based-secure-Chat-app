import 'package:flutter/material.dart';

import 'package:chats_app/chatpage.dart';

class AllChatPage extends StatefulWidget {
  final String myaddress;

  AllChatPage(this.myaddress);

  @override
  State<AllChatPage> createState() => _AllChatPageState();
}

class _AllChatPageState extends State<AllChatPage> {
  List<String> chats=[];

   String get Key{
    String _privatekey;
    if(widget.myaddress=="Bhuvi" && chats.isEmpty){
      chats.add("Bhuvanesh");
      _privatekey="af241155a09bbe6b3e7a19cd8a82ac10f2f7c1824f435c3725f8bb4afbb602d5";
    }
    else if(widget.myaddress=="Bhuvanesh" && chats.isEmpty){
      chats.add("Bhuvi");
      _privatekey="af241155a09bbe6b3e7a19cd8a82ac10f2f7c1824f435c3725f8bb4afbb602d5";
    }
    else{
      _privatekey="";
    }
    return _privatekey;
  }

  @override
  Widget build(BuildContext context) {
    print(Key);
    return Scaffold(
      appBar: AppBar(title: Text("Chats"),automaticallyImplyLeading: false,backgroundColor:   Color.fromARGB(153, 50, 59, 229)),
      body:
    Stack(
      children:[
       ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
                    return InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(top:5.0),
                        child: Card(
                          child: SizedBox(
                            height:53,
                            child: Container(
                            //  margin:EdgeInsets.only(top:7.0) ,
                              padding: const EdgeInsets.all(14.0),
                              child: Text(chats[index].toString()),
                            )),
                            ),
                      ),
                          onTap: () {
                                      Navigator.push(
                                      context,
                                       MaterialPageRoute(builder: (context) => Chat(chats[index].toString(),Key)),
                                         );},
                    );
        }
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                                  
                                    margin: new EdgeInsets.symmetric(horizontal: 20.0,vertical: 40.0),
                                    child: ElevatedButton(
                                      style:ElevatedButton.styleFrom(primary:  Color.fromARGB(153, 50, 59, 229)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child:const Text("logout"),
                                      
                                    ),),
                        )
                        
                        ]
    ),
    );
  }
}