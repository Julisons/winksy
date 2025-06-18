/// notiId : "85f2b1d6-f659-4587-a6c3-736080ee6051"
/// notiTitle : "Friends Zoo"
/// notiDesc : "You’ve been bought! You earned 20 WNK points."
/// notiUsrId : "4d4b19e6-5906-4743-9771-68af311ee028"
/// notiCreatedDate : "2025-06-15T21:00:00.000+00:00"
/// notiCreatedTime : "2025-06-16T06:53:32.006+00:00"
/// notiStatus : "SENT"
/// notiMessage : "You’ve been bought! You earned 20 WNK points."
/// notiEvent : "Pet Messages"
/// notiCode : "EVT001"
/// notiUrl : ""
/// notiCreatedBy : "6fe5ebdd-310a-4dd4-8ea9-6d7240fc7ad5"
/// notiInstId : "4d4b19e6-5906-4743-9771-68af311ee028"
/// notiUpdatedBy : "2c0ccf7a-0242-4608-98c0-ff6914e65a51"
/// notiUpdatedDate : "2025-06-15T21:00:00.000+00:00"
/// notiUpdatedTime : "2025-06-16T06:53:32.006+00:00"
/// notiType : "PETNOTIFICATION"

class INotification {
  INotification({
      dynamic notiId, 
      dynamic notiTitle, 
      dynamic notiDesc, 
      dynamic notiUsrId, 
      dynamic notiCreatedDate, 
      dynamic notiCreatedTime, 
      dynamic notiStatus, 
      dynamic notiMessage, 
      dynamic notiEvent, 
      dynamic notiCode, 
      dynamic notiUrl, 
      dynamic notiCreatedBy, 
      dynamic notiInstId, 
      dynamic notiUpdatedBy, 
      dynamic notiUpdatedDate, 
      dynamic notiUpdatedTime, 
      dynamic notiType,}){
    notiId = notiId;
    notiTitle = notiTitle;
    notiDesc = notiDesc;
    notiUsrId = notiUsrId;
    notiCreatedDate = notiCreatedDate;
    notiCreatedTime = notiCreatedTime;
    notiStatus = notiStatus;
    notiMessage = notiMessage;
    notiEvent = notiEvent;
    notiCode = notiCode;
    notiUrl = notiUrl;
    notiCreatedBy = notiCreatedBy;
    notiInstId = notiInstId;
    notiUpdatedBy = notiUpdatedBy;
    notiUpdatedDate = notiUpdatedDate;
    notiUpdatedTime = notiUpdatedTime;
    notiType = notiType;
}

  INotification.fromJson(dynamic json) {
    notiId = json['notiId'];
    notiTitle = json['notiTitle'];
    notiDesc = json['notiDesc'];
    notiUsrId = json['notiUsrId'];
    notiCreatedDate = json['notiCreatedDate'];
    notiCreatedTime = json['notiCreatedTime'];
    notiStatus = json['notiStatus'];
    notiMessage = json['notiMessage'];
    notiEvent = json['notiEvent'];
    notiCode = json['notiCode'];
    notiUrl = json['notiUrl'];
    notiCreatedBy = json['notiCreatedBy'];
    notiInstId = json['notiInstId'];
    notiUpdatedBy = json['notiUpdatedBy'];
    notiUpdatedDate = json['notiUpdatedDate'];
    notiUpdatedTime = json['notiUpdatedTime'];
    notiType = json['notiType'];
  }
  dynamic notiId;
  dynamic notiTitle;
  dynamic notiDesc;
  dynamic notiUsrId;
  dynamic notiCreatedDate;
  dynamic notiCreatedTime;
  dynamic notiStatus;
  dynamic notiMessage;
  dynamic notiEvent;
  dynamic notiCode;
  dynamic notiUrl;
  dynamic notiCreatedBy;
  dynamic notiInstId;
  dynamic notiUpdatedBy;
  dynamic notiUpdatedDate;
  dynamic notiUpdatedTime;
  dynamic notiType;
INotification copyWith({  dynamic notiId,
  dynamic notiTitle,
  dynamic notiDesc,
  dynamic notiUsrId,
  dynamic notiCreatedDate,
  dynamic notiCreatedTime,
  dynamic notiStatus,
  dynamic notiMessage,
  dynamic notiEvent,
  dynamic notiCode,
  dynamic notiUrl,
  dynamic notiCreatedBy,
  dynamic notiInstId,
  dynamic notiUpdatedBy,
  dynamic notiUpdatedDate,
  dynamic notiUpdatedTime,
  dynamic notiType,
}) => INotification(  notiId: notiId ?? notiId,
  notiTitle: notiTitle ?? notiTitle,
  notiDesc: notiDesc ?? notiDesc,
  notiUsrId: notiUsrId ?? notiUsrId,
  notiCreatedDate: notiCreatedDate ?? notiCreatedDate,
  notiCreatedTime: notiCreatedTime ?? notiCreatedTime,
  notiStatus: notiStatus ?? notiStatus,
  notiMessage: notiMessage ?? notiMessage,
  notiEvent: notiEvent ?? notiEvent,
  notiCode: notiCode ?? notiCode,
  notiUrl: notiUrl ?? notiUrl,
  notiCreatedBy: notiCreatedBy ?? notiCreatedBy,
  notiInstId: notiInstId ?? notiInstId,
  notiUpdatedBy: notiUpdatedBy ?? notiUpdatedBy,
  notiUpdatedDate: notiUpdatedDate ?? notiUpdatedDate,
  notiUpdatedTime: notiUpdatedTime ?? notiUpdatedTime,
  notiType: notiType ?? notiType,
);


  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['notiId'] = notiId;
    map['notiTitle'] = notiTitle;
    map['notiDesc'] = notiDesc;
    map['notiUsrId'] = notiUsrId;
    map['notiCreatedDate'] = notiCreatedDate;
    map['notiCreatedTime'] = notiCreatedTime;
    map['notiStatus'] = notiStatus;
    map['notiMessage'] = notiMessage;
    map['notiEvent'] = notiEvent;
    map['notiCode'] = notiCode;
    map['notiUrl'] = notiUrl;
    map['notiCreatedBy'] = notiCreatedBy;
    map['notiInstId'] = notiInstId;
    map['notiUpdatedBy'] = notiUpdatedBy;
    map['notiUpdatedDate'] = notiUpdatedDate;
    map['notiUpdatedTime'] = notiUpdatedTime;
    map['notiType'] = notiType;
    return map;
  }

}