// ignore_for_file: unused_field

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

import 'encryptiondecription.dart';
import 'package:chats_app/chatmodel.dart';
class ChatServices extends ChangeNotifier{
  List<ChatMessage> messages=[];
  List<ChatMessage> decryptedmesssages=[];
// final String _rpcUrl =
//    Platform.isAndroid ? 'http://172.17.9.89:7545' : 'http://127.0.0.1:7545';
// final String _wsUrl =
//       Platform.isAndroid ? 'http://172.17.9.89:7545' : 'ws://127.0.0.1:7545';

  final String _rpcUrl =
      'http://192.168.217.124:7545';
  final String _wsUrl =
      'http://192.168.217.124:7545';
  // final String _privatekey =
  //     'af241155a09bbe6b3e7a19cd8a82ac10f2f7c1824f435c3725f8bb4afbb602d5';
      final String _privatekey =
      '4ac9c9b5773e98683118c221d0db147cef72f095fb3dcfe8b68be8fe4674d8c7';
  late Web3Client _web3cient;
  bool isLoading = true;
  ChatServices() {
    init();
  }

  Future<void> init() async {
    _web3cient = Web3Client(
      _rpcUrl,
      http.Client(),
      socketConnector: () {
        return IOWebSocketChannel.connect(_wsUrl).cast<String>();
      },
    );
    await getABI();
    await getCredentials();
    await getDeployedContract();
  }
   late ContractAbi _abiCode;
   late EthereumAddress _contractAddress;
  Future<void> getABI() async {
    String abiFile =
        await rootBundle.loadString('build/contracts/Payment.json');
    var jsonABI = jsonDecode(abiFile);
    _abiCode =
        ContractAbi.fromJson(jsonEncode(jsonABI['abi']), 'Payment');
    _contractAddress =
        EthereumAddress.fromHex(jsonABI["networks"]["5777"]["address"]);
  }

   late EthPrivateKey _creds;
  Future<void> getCredentials() async {
    _creds = EthPrivateKey.fromHex(_privatekey);
  }

   late DeployedContract _deployedContract;
  late ContractFunction _createMessage;
   late ContractFunction _chats;
  late ContractFunction _chatCount;

  Future<void> getDeployedContract() async {
    _deployedContract = DeployedContract(_abiCode, _contractAddress);
    _createMessage = _deployedContract.function('sendMessage');
    _chats = _deployedContract.function('chats');
    _chatCount= _deployedContract.function('Count');
    await fetchChats();
  }

  Future<void> fetchChats() async {
    List totalTaskList = await _web3cient.call(
      contract: _deployedContract,
      function: _chatCount,
      params: [],
    );

    int totalTaskLen = totalTaskList[0].toInt();
    messages.clear();
    decryptedmesssages.clear();
    for (var i = 0; i < totalTaskLen; i++) {
      var temp = await _web3cient.call(
          contract: _deployedContract,
          function: _chats,
          params: [BigInt.from(i)]);
      if (temp[1] != "") {
        messages.add(
          ChatMessage(
            count: (temp[0] as BigInt).toInt(),
            messageContent: temp[1],
            messageType: temp[2],
          ),
        );
      }
    }
     isLoading = false;
    notifyListeners();
  }

  Future<void> addMessage(String msg,String msgtype) async {
    msg= MyEncryptionDecryption.encryptAES(msg).base64;
     await _web3cient.sendTransaction(
      _creds,
      Transaction.callContract(
        contract: _deployedContract,
        function: _createMessage,
        parameters: [msg, msgtype],
      ),
    );
     isLoading = true;
    fetchChats();
  }
}