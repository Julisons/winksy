/// ugiftId : "0f221e12-9615-4887-99d4-361808e82994"
/// ugiftGiftId : "b4cfdb25-c6ab-491e-a6e5-109c480eec56"
/// ugiftUsrId : "56beec56-fc28-413e-a1de-c8080c50e150"
/// ugiftCreatedBy : "2c0ccf7a-0242-4608-98c0-ff6914e65a51"
/// ugiftCreatedDate : "2025-06-18T21:00:00.000+00:00"
/// ugiftCreatedTime : "2025-06-19T18:13:19.490+00:00"
/// ugiftInstId : null
/// ugiftUpdatedBy : null
/// ugiftUpdatedDate : "2025-06-18T21:00:00.000+00:00"
/// ugiftUpdatedTime : "2025-06-19T18:13:19.490+00:00"
/// ugiftDesc : null
/// ugiftStatus : "ACTIVE"
/// ugiftCode : null
/// ugiftType : null
/// ugiftGifterId : "2c0ccf7a-0242-4608-98c0-ff6914e65a51"
/// giftPath : "https://icons.iconarchive.com/icons/aha-soft/free-large-love/128/Rose-icon.png"
/// usrFullNames : "Austine Julisons"

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
      dynamic ugiftGifterId, 
      dynamic giftPath, 
      dynamic usrFullNames,}){
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
    ugiftGifterId = ugiftGifterId;
    giftPath = giftPath;
    usrFullNames = usrFullNames;
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
    ugiftGifterId = json['ugiftGifterId'];
    giftPath = json['giftPath'];
    usrFullNames = json['usrFullNames'];
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
  dynamic ugiftGifterId;
  dynamic giftPath;
  dynamic usrFullNames;
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
  dynamic ugiftGifterId,
  dynamic giftPath,
  dynamic usrFullNames,
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
  ugiftGifterId: ugiftGifterId ?? ugiftGifterId,
  giftPath: giftPath ?? giftPath,
  usrFullNames: usrFullNames ?? usrFullNames,
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
    map['ugiftGifterId'] = ugiftGifterId;
    map['giftPath'] = giftPath;
    map['usrFullNames'] = usrFullNames;
    return map;
  }

}