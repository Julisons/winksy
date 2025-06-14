/// notiId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// notiTitle : "string"
/// notiDesc : "string"
/// notiUsrId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// notiStatus : "string"
/// notiMessage : "string"
/// notiEvent : "string"
/// notiCode : "string"
/// notiUrl : "string"
/// notiInstId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// notiType : "string"

class Notification {
  Notification({
      dynamic notiId, 
      dynamic notiTitle, 
      dynamic notiDesc, 
      dynamic notiUsrId, 
      dynamic notiStatus, 
      dynamic notiMessage, 
      dynamic notiEvent, 
      dynamic notiCode, 
      dynamic notiUrl, 
      dynamic notiInstId, 
      dynamic notiType,}){
    notiId = notiId;
    notiTitle = notiTitle;
    notiDesc = notiDesc;
    notiUsrId = notiUsrId;
    notiStatus = notiStatus;
    notiMessage = notiMessage;
    notiEvent = notiEvent;
    notiCode = notiCode;
    notiUrl = notiUrl;
    notiInstId = notiInstId;
    notiType = notiType;
}

  Notification.fromJson(dynamic json) {
    notiId = json['notiId'];
    notiTitle = json['notiTitle'];
    notiDesc = json['notiDesc'];
    notiUsrId = json['notiUsrId'];
    notiStatus = json['notiStatus'];
    notiMessage = json['notiMessage'];
    notiEvent = json['notiEvent'];
    notiCode = json['notiCode'];
    notiUrl = json['notiUrl'];
    notiInstId = json['notiInstId'];
    notiType = json['notiType'];
  }
  dynamic notiId;
  dynamic notiTitle;
  dynamic notiDesc;
  dynamic notiUsrId;
  dynamic notiStatus;
  dynamic notiMessage;
  dynamic notiEvent;
  dynamic notiCode;
  dynamic notiUrl;
  dynamic notiInstId;
  dynamic notiType;
Notification copyWith({  dynamic notiId,
  dynamic notiTitle,
  dynamic notiDesc,
  dynamic notiUsrId,
  dynamic notiStatus,
  dynamic notiMessage,
  dynamic notiEvent,
  dynamic notiCode,
  dynamic notiUrl,
  dynamic notiInstId,
  dynamic notiType,
}) => Notification(  notiId: notiId ?? notiId,
  notiTitle: notiTitle ?? notiTitle,
  notiDesc: notiDesc ?? notiDesc,
  notiUsrId: notiUsrId ?? notiUsrId,
  notiStatus: notiStatus ?? notiStatus,
  notiMessage: notiMessage ?? notiMessage,
  notiEvent: notiEvent ?? notiEvent,
  notiCode: notiCode ?? notiCode,
  notiUrl: notiUrl ?? notiUrl,
  notiInstId: notiInstId ?? notiInstId,
  notiType: notiType ?? notiType,
);


  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['notiId'] = notiId;
    map['notiTitle'] = notiTitle;
    map['notiDesc'] = notiDesc;
    map['notiUsrId'] = notiUsrId;
    map['notiStatus'] = notiStatus;
    map['notiMessage'] = notiMessage;
    map['notiEvent'] = notiEvent;
    map['notiCode'] = notiCode;
    map['notiUrl'] = notiUrl;
    map['notiInstId'] = notiInstId;
    map['notiType'] = notiType;
    return map;
  }

}