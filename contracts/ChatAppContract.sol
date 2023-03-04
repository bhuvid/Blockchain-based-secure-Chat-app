// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.4.22 <0.9.0;

contract Payment{
uint256 public Count = 0;

struct Chat{
        uint256 id;
        string message;
        string msgtype;
    }
mapping(uint256 => Chat) public chats;    
event Message(uint256 id,string message ,string msgtype);
function sendMessage(string memory _message,string memory _msgtype) public {
    chats[Count]=Chat(Count,_message,_msgtype);
    emit Message(Count,_message,_msgtype);
    Count++;
}
    
}
