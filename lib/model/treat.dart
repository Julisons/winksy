/// giftId : "58281366-43a6-470b-925b-c708a915f92c"
/// giftPath : "Yellow-2-Gift-icon.png"
/// giftAmount : 17.23
/// giftPathn : null
/// giftCreatedBy : null
/// giftCreatedDate : "2025-06-17T21:00:00.000+00:00"
/// giftCreatedTime : "2025-06-18T17:30:46.000+00:00"
/// giftInstId : null
/// giftUpdatedBy : null
/// giftUpdatedDate : null
/// giftUpdatedTime : null
/// giftDesc : "Yellow 2 Gift"
/// giftStatus : "active"
/// giftCode : null
/// giftType : "image"

class Treat {
  Treat({
      dynamic giftId, 
      dynamic giftPath, 
      dynamic giftAmount, 
      dynamic giftPathn, 
      dynamic giftCreatedBy, 
      dynamic giftCreatedDate, 
      dynamic giftCreatedTime, 
      dynamic giftInstId, 
      dynamic giftUpdatedBy, 
      dynamic giftUpdatedDate, 
      dynamic giftUpdatedTime, 
      dynamic giftDesc, 
      dynamic giftStatus, 
      dynamic giftCode, 
      dynamic giftType,}){
    giftId = giftId;
    giftPath = giftPath;
    giftAmount = giftAmount;
    giftPathn = giftPathn;
    giftCreatedBy = giftCreatedBy;
    giftCreatedDate = giftCreatedDate;
    giftCreatedTime = giftCreatedTime;
    giftInstId = giftInstId;
    giftUpdatedBy = giftUpdatedBy;
    giftUpdatedDate = giftUpdatedDate;
    giftUpdatedTime = giftUpdatedTime;
    giftDesc = giftDesc;
    giftStatus = giftStatus;
    giftCode = giftCode;
    giftType = giftType;
}

  Treat.fromJson(dynamic json) {
    giftId = json['giftId'];
    giftPath = json['giftPath'];
    giftAmount = json['giftAmount'];
    giftPathn = json['giftPathn'];
    giftCreatedBy = json['giftCreatedBy'];
    giftCreatedDate = json['giftCreatedDate'];
    giftCreatedTime = json['giftCreatedTime'];
    giftInstId = json['giftInstId'];
    giftUpdatedBy = json['giftUpdatedBy'];
    giftUpdatedDate = json['giftUpdatedDate'];
    giftUpdatedTime = json['giftUpdatedTime'];
    giftDesc = json['giftDesc'];
    giftStatus = json['giftStatus'];
    giftCode = json['giftCode'];
    giftType = json['giftType'];
  }
  dynamic giftId;
  dynamic giftPath;
  dynamic giftAmount;
  dynamic giftPathn;
  dynamic giftCreatedBy;
  dynamic giftCreatedDate;
  dynamic giftCreatedTime;
  dynamic giftInstId;
  dynamic giftUpdatedBy;
  dynamic giftUpdatedDate;
  dynamic giftUpdatedTime;
  dynamic giftDesc;
  dynamic giftStatus;
  dynamic giftCode;
  dynamic giftType;
Treat copyWith({  dynamic giftId,
  dynamic giftPath,
  dynamic giftAmount,
  dynamic giftPathn,
  dynamic giftCreatedBy,
  dynamic giftCreatedDate,
  dynamic giftCreatedTime,
  dynamic giftInstId,
  dynamic giftUpdatedBy,
  dynamic giftUpdatedDate,
  dynamic giftUpdatedTime,
  dynamic giftDesc,
  dynamic giftStatus,
  dynamic giftCode,
  dynamic giftType,
}) => Treat(  giftId: giftId ?? giftId,
  giftPath: giftPath ?? giftPath,
  giftAmount: giftAmount ?? giftAmount,
  giftPathn: giftPathn ?? giftPathn,
  giftCreatedBy: giftCreatedBy ?? giftCreatedBy,
  giftCreatedDate: giftCreatedDate ?? giftCreatedDate,
  giftCreatedTime: giftCreatedTime ?? giftCreatedTime,
  giftInstId: giftInstId ?? giftInstId,
  giftUpdatedBy: giftUpdatedBy ?? giftUpdatedBy,
  giftUpdatedDate: giftUpdatedDate ?? giftUpdatedDate,
  giftUpdatedTime: giftUpdatedTime ?? giftUpdatedTime,
  giftDesc: giftDesc ?? giftDesc,
  giftStatus: giftStatus ?? giftStatus,
  giftCode: giftCode ?? giftCode,
  giftType: giftType ?? giftType,
);


  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['giftId'] = giftId;
    map['giftPath'] = giftPath;
    map['giftAmount'] = giftAmount;
    map['giftPathn'] = giftPathn;
    map['giftCreatedBy'] = giftCreatedBy;
    map['giftCreatedDate'] = giftCreatedDate;
    map['giftCreatedTime'] = giftCreatedTime;
    map['giftInstId'] = giftInstId;
    map['giftUpdatedBy'] = giftUpdatedBy;
    map['giftUpdatedDate'] = giftUpdatedDate;
    map['giftUpdatedTime'] = giftUpdatedTime;
    map['giftDesc'] = giftDesc;
    map['giftStatus'] = giftStatus;
    map['giftCode'] = giftCode;
    map['giftType'] = giftType;
    return map;
  }

}