/// msgId : "c95ba4b7-6593-4946-84e7-ded0091674d8"
/// msgChatId : "f0775335-fd49-4871-afd1-7bdbdeffff3b"
/// msgSenderId : "2c0ccf7a-0242-4608-98c0-ff6914e65a51"
/// msgReceiverId : "202e4835-854e-47f0-8433-ecc5364b0cc2"
/// msgText : "Welcome to Gboard clipboard, any text you copy will be saved here."
/// msgType : null
/// msgSentAt : null
/// msgIsEdited : null
/// msgCreatedBy : "2c0ccf7a-0242-4608-98c0-ff6914e65a51"
/// msgCreatedDate : "2025-06-07T21:00:00.000+00:00"
/// msgCreatedTime : "2025-06-08T12:27:59.459+00:00"
/// msgUpdatedBy : null
/// msgUpdatedDate : "2025-06-07T21:00:00.000+00:00"
/// msgUpdatedTime : "2025-06-08T12:27:59.459+00:00"
/// msgDesc : null
/// msgStatus : "UNREAD"
/// msgCode : null
/// msgInstId : null
/// chatName : null
/// usrSender : "Austine Julisons"
/// usrReceiver : "Julisons"
/// usrImage : "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=800&h=800&fit=crop&crop=face"

class Message {
  Message({
      dynamic msgId, 
      dynamic msgChatId, 
      dynamic msgSenderId, 
      dynamic msgReceiverId, 
      dynamic msgText, 
      dynamic msgType, 
      dynamic msgSentAt, 
      dynamic msgIsEdited, 
      dynamic msgCreatedBy, 
      dynamic msgCreatedDate, 
      dynamic msgCreatedTime, 
      dynamic msgUpdatedBy, 
      dynamic msgUpdatedDate, 
      dynamic msgUpdatedTime, 
      dynamic msgDesc, 
      dynamic msgStatus, 
      dynamic msgCode, 
      dynamic msgInstId, 
      dynamic chatName, 
      dynamic usrSender, 
      dynamic usrReceiver, 
      dynamic usrImage,}){
    msgId = msgId;
    msgChatId = msgChatId;
    msgSenderId = msgSenderId;
    msgReceiverId = msgReceiverId;
    msgText = msgText;
    msgType = msgType;
    msgSentAt = msgSentAt;
    msgIsEdited = msgIsEdited;
    msgCreatedBy = msgCreatedBy;
    msgCreatedDate = msgCreatedDate;
    msgCreatedTime = msgCreatedTime;
    msgUpdatedBy = msgUpdatedBy;
    msgUpdatedDate = msgUpdatedDate;
    msgUpdatedTime = msgUpdatedTime;
    msgDesc = msgDesc;
    msgStatus = msgStatus;
    msgCode = msgCode;
    msgInstId = msgInstId;
    chatName = chatName;
    usrSender = usrSender;
    usrReceiver = usrReceiver;
    usrImage = usrImage;
}

  Message.fromJson(dynamic json) {
    msgId = json['msgId'];
    msgChatId = json['msgChatId'];
    msgSenderId = json['msgSenderId'];
    msgReceiverId = json['msgReceiverId'];
    msgText = json['msgText'];
    msgType = json['msgType'];
    msgSentAt = json['msgSentAt'];
    msgIsEdited = json['msgIsEdited'];
    msgCreatedBy = json['msgCreatedBy'];
    msgCreatedDate = json['msgCreatedDate'];
    msgCreatedTime = json['msgCreatedTime'];
    msgUpdatedBy = json['msgUpdatedBy'];
    msgUpdatedDate = json['msgUpdatedDate'];
    msgUpdatedTime = json['msgUpdatedTime'];
    msgDesc = json['msgDesc'];
    msgStatus = json['msgStatus'];
    msgCode = json['msgCode'];
    msgInstId = json['msgInstId'];
    chatName = json['chatName'];
    usrSender = json['usrSender'];
    usrReceiver = json['usrReceiver'];
    usrImage = json['usrImage'];
  }
  dynamic msgId;
  dynamic msgChatId;
  dynamic msgSenderId;
  dynamic msgReceiverId;
  dynamic msgText;
  dynamic msgType;
  dynamic msgSentAt;
  dynamic msgIsEdited;
  dynamic msgCreatedBy;
  dynamic msgCreatedDate;
  dynamic msgCreatedTime;
  dynamic msgUpdatedBy;
  dynamic msgUpdatedDate;
  dynamic msgUpdatedTime;
  dynamic msgDesc;
  dynamic msgStatus;
  dynamic msgCode;
  dynamic msgInstId;
  dynamic chatName;
  dynamic usrSender;
  dynamic usrReceiver;
  dynamic usrImage;
Message copyWith({  dynamic msgId,
  dynamic msgChatId,
  dynamic msgSenderId,
  dynamic msgReceiverId,
  dynamic msgText,
  dynamic msgType,
  dynamic msgSentAt,
  dynamic msgIsEdited,
  dynamic msgCreatedBy,
  dynamic msgCreatedDate,
  dynamic msgCreatedTime,
  dynamic msgUpdatedBy,
  dynamic msgUpdatedDate,
  dynamic msgUpdatedTime,
  dynamic msgDesc,
  dynamic msgStatus,
  dynamic msgCode,
  dynamic msgInstId,
  dynamic chatName,
  dynamic usrSender,
  dynamic usrReceiver,
  dynamic usrImage,
}) => Message(  msgId: msgId ?? msgId,
  msgChatId: msgChatId ?? msgChatId,
  msgSenderId: msgSenderId ?? msgSenderId,
  msgReceiverId: msgReceiverId ?? msgReceiverId,
  msgText: msgText ?? msgText,
  msgType: msgType ?? msgType,
  msgSentAt: msgSentAt ?? msgSentAt,
  msgIsEdited: msgIsEdited ?? msgIsEdited,
  msgCreatedBy: msgCreatedBy ?? msgCreatedBy,
  msgCreatedDate: msgCreatedDate ?? msgCreatedDate,
  msgCreatedTime: msgCreatedTime ?? msgCreatedTime,
  msgUpdatedBy: msgUpdatedBy ?? msgUpdatedBy,
  msgUpdatedDate: msgUpdatedDate ?? msgUpdatedDate,
  msgUpdatedTime: msgUpdatedTime ?? msgUpdatedTime,
  msgDesc: msgDesc ?? msgDesc,
  msgStatus: msgStatus ?? msgStatus,
  msgCode: msgCode ?? msgCode,
  msgInstId: msgInstId ?? msgInstId,
  chatName: chatName ?? chatName,
  usrSender: usrSender ?? usrSender,
  usrReceiver: usrReceiver ?? usrReceiver,
  usrImage: usrImage ?? usrImage,
);


  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['msgId'] = msgId;
    map['msgChatId'] = msgChatId;
    map['msgSenderId'] = msgSenderId;
    map['msgReceiverId'] = msgReceiverId;
    map['msgText'] = msgText;
    map['msgType'] = msgType;
    map['msgSentAt'] = msgSentAt;
    map['msgIsEdited'] = msgIsEdited;
    map['msgCreatedBy'] = msgCreatedBy;
    map['msgCreatedDate'] = msgCreatedDate;
    map['msgCreatedTime'] = msgCreatedTime;
    map['msgUpdatedBy'] = msgUpdatedBy;
    map['msgUpdatedDate'] = msgUpdatedDate;
    map['msgUpdatedTime'] = msgUpdatedTime;
    map['msgDesc'] = msgDesc;
    map['msgStatus'] = msgStatus;
    map['msgCode'] = msgCode;
    map['msgInstId'] = msgInstId;
    map['chatName'] = chatName;
    map['usrSender'] = usrSender;
    map['usrReceiver'] = usrReceiver;
    map['usrImage'] = usrImage;
    return map;
  }

}