/// ugiftId : "b4cfdb95-c6ab-490e-a6e5-109c480eec57"
/// ugiftGiftId : "b4cfdb95-c6ab-490e-a6e5-109c480eec57"
/// ugiftUsrId : "b4cfdb95-c6ab-490e-a6e5-109c480eec57"
/// ugiftCreatedBy : null
/// ugiftCreatedDate : null
/// ugiftCreatedTime : null
/// ugiftInstId : null
/// ugiftUpdatedBy : null
/// ugiftUpdatedDate : null
/// ugiftUpdatedTime : null
/// ugiftDesc : null
/// ugiftStatus : null
/// ugiftCode : null
/// ugiftType : null
/// giftPath : "https://icons.iconarchive.com/icons/pictogrammers/material/128/bee-flower-icon.png"

class Gift {
  Gift({
      dynamic ugiftId, 
      dynamic ugiftGiftId, 
      dynamic ugiftUsrId, 
      dynamic ugiftCreatedBy, 
      dynamic ugiftCreatedDate, 
      dynamic ugiftCreatedTime, 
      dynamic ugiftInstId, 
      dynamic ugiftUpdatedBy, 
      dynamic ugiftUpdatedDate, 
      dynamic ugiftUpdatedTime, 
      dynamic ugiftDesc, 
      dynamic ugiftStatus, 
      dynamic ugiftCode, 
      dynamic ugiftType, 
      dynamic giftPath,}){
    ugiftId = ugiftId;
    ugiftGiftId = ugiftGiftId;
    ugiftUsrId = ugiftUsrId;
    ugiftCreatedBy = ugiftCreatedBy;
    ugiftCreatedDate = ugiftCreatedDate;
    ugiftCreatedTime = ugiftCreatedTime;
    ugiftInstId = ugiftInstId;
    ugiftUpdatedBy = ugiftUpdatedBy;
    ugiftUpdatedDate = ugiftUpdatedDate;
    ugiftUpdatedTime = ugiftUpdatedTime;
    ugiftDesc = ugiftDesc;
    ugiftStatus = ugiftStatus;
    ugiftCode = ugiftCode;
    ugiftType = ugiftType;
    giftPath = giftPath;
}

  Gift.fromJson(dynamic json) {
    ugiftId = json['ugiftId'];
    ugiftGiftId = json['ugiftGiftId'];
    ugiftUsrId = json['ugiftUsrId'];
    ugiftCreatedBy = json['ugiftCreatedBy'];
    ugiftCreatedDate = json['ugiftCreatedDate'];
    ugiftCreatedTime = json['ugiftCreatedTime'];
    ugiftInstId = json['ugiftInstId'];
    ugiftUpdatedBy = json['ugiftUpdatedBy'];
    ugiftUpdatedDate = json['ugiftUpdatedDate'];
    ugiftUpdatedTime = json['ugiftUpdatedTime'];
    ugiftDesc = json['ugiftDesc'];
    ugiftStatus = json['ugiftStatus'];
    ugiftCode = json['ugiftCode'];
    ugiftType = json['ugiftType'];
    giftPath = json['giftPath'];
  }
  dynamic ugiftId;
  dynamic ugiftGiftId;
  dynamic ugiftUsrId;
  dynamic ugiftCreatedBy;
  dynamic ugiftCreatedDate;
  dynamic ugiftCreatedTime;
  dynamic ugiftInstId;
  dynamic ugiftUpdatedBy;
  dynamic ugiftUpdatedDate;
  dynamic ugiftUpdatedTime;
  dynamic ugiftDesc;
  dynamic ugiftStatus;
  dynamic ugiftCode;
  dynamic ugiftType;
  dynamic giftPath;
Gift copyWith({  dynamic ugiftId,
  dynamic ugiftGiftId,
  dynamic ugiftUsrId,
  dynamic ugiftCreatedBy,
  dynamic ugiftCreatedDate,
  dynamic ugiftCreatedTime,
  dynamic ugiftInstId,
  dynamic ugiftUpdatedBy,
  dynamic ugiftUpdatedDate,
  dynamic ugiftUpdatedTime,
  dynamic ugiftDesc,
  dynamic ugiftStatus,
  dynamic ugiftCode,
  dynamic ugiftType,
  dynamic giftPath,
}) => Gift(  ugiftId: ugiftId ?? ugiftId,
  ugiftGiftId: ugiftGiftId ?? ugiftGiftId,
  ugiftUsrId: ugiftUsrId ?? ugiftUsrId,
  ugiftCreatedBy: ugiftCreatedBy ?? ugiftCreatedBy,
  ugiftCreatedDate: ugiftCreatedDate ?? ugiftCreatedDate,
  ugiftCreatedTime: ugiftCreatedTime ?? ugiftCreatedTime,
  ugiftInstId: ugiftInstId ?? ugiftInstId,
  ugiftUpdatedBy: ugiftUpdatedBy ?? ugiftUpdatedBy,
  ugiftUpdatedDate: ugiftUpdatedDate ?? ugiftUpdatedDate,
  ugiftUpdatedTime: ugiftUpdatedTime ?? ugiftUpdatedTime,
  ugiftDesc: ugiftDesc ?? ugiftDesc,
  ugiftStatus: ugiftStatus ?? ugiftStatus,
  ugiftCode: ugiftCode ?? ugiftCode,
  ugiftType: ugiftType ?? ugiftType,
  giftPath: giftPath ?? giftPath,
);


  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['ugiftId'] = ugiftId;
    map['ugiftGiftId'] = ugiftGiftId;
    map['ugiftUsrId'] = ugiftUsrId;
    map['ugiftCreatedBy'] = ugiftCreatedBy;
    map['ugiftCreatedDate'] = ugiftCreatedDate;
    map['ugiftCreatedTime'] = ugiftCreatedTime;
    map['ugiftInstId'] = ugiftInstId;
    map['ugiftUpdatedBy'] = ugiftUpdatedBy;
    map['ugiftUpdatedDate'] = ugiftUpdatedDate;
    map['ugiftUpdatedTime'] = ugiftUpdatedTime;
    map['ugiftDesc'] = ugiftDesc;
    map['ugiftStatus'] = ugiftStatus;
    map['ugiftCode'] = ugiftCode;
    map['ugiftType'] = ugiftType;
    map['giftPath'] = giftPath;
    return map;
  }

}