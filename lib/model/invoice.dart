/// invoId : null
/// invoCode : null
/// invoRef : null
/// invoPayType : null
/// invoDate : null
/// invoCreatedBy : null
/// invoCreatedDate : null
/// invoStatus : null
/// invoAccId : null
/// invoAccType : null
/// invoPatId : null
/// invoBillType : null
/// invoPaidAmount : null
/// invoAmount : null
/// invoUpdatedBy : null
/// invoUpdatedDate : null
/// invoOwner : null
/// invoOwnerId : null
/// invoOpId : null
/// invoPdId : null
/// invoCreatedTime : null
/// invoUpdatedTime : null
/// invoDesc : null
/// invoCount : null
/// prodImgOne : null
/// user : null

class Invoice {
  Invoice({
      dynamic invoId, 
      dynamic invoCode, 
      dynamic invoRef, 
      dynamic invoPayType, 
      dynamic invoDate, 
      dynamic invoCreatedBy, 
      dynamic invoCreatedDate, 
      dynamic invoStatus, 
      dynamic invoAccId, 
      dynamic invoAccType, 
      dynamic invoPatId, 
      dynamic invoBillType, 
      dynamic invoPaidAmount, 
      dynamic invoAmount, 
      dynamic invoUpdatedBy, 
      dynamic invoUpdatedDate, 
      dynamic invoOwner, 
      dynamic invoOwnerId, 
      dynamic invoOpId, 
      dynamic invoPdId, 
      dynamic invoCreatedTime, 
      dynamic invoUpdatedTime, 
      dynamic invoDesc, 
      dynamic invoCount, 
      dynamic prodImgOne, 
      dynamic user,}){
    invoId = invoId;
    invoCode = invoCode;
    invoRef = invoRef;
    invoPayType = invoPayType;
    invoDate = invoDate;
    invoCreatedBy = invoCreatedBy;
    invoCreatedDate = invoCreatedDate;
    invoStatus = invoStatus;
    invoAccId = invoAccId;
    invoAccType = invoAccType;
    invoPatId = invoPatId;
    invoBillType = invoBillType;
    invoPaidAmount = invoPaidAmount;
    invoAmount = invoAmount;
    invoUpdatedBy = invoUpdatedBy;
    invoUpdatedDate = invoUpdatedDate;
    invoOwner = invoOwner;
    invoOwnerId = invoOwnerId;
    invoOpId = invoOpId;
    invoPdId = invoPdId;
    invoCreatedTime = invoCreatedTime;
    invoUpdatedTime = invoUpdatedTime;
    invoDesc = invoDesc;
    invoCount = invoCount;
     prodImgOne = prodImgOne;
     user = user;
}

  Invoice.fromJson(dynamic json) {
    invoId = json['invoId'];
    invoCode = json['invoCode'];
    invoRef = json['invoRef'];
    invoPayType = json['invoPayType'];
    invoDate = json['invoDate'];
    invoCreatedBy = json['invoCreatedBy'];
    invoCreatedDate = json['invoCreatedDate'];
    invoStatus = json['invoStatus'];
    invoAccId = json['invoAccId'];
    invoAccType = json['invoAccType'];
    invoPatId = json['invoPatId'];
    invoBillType = json['invoBillType'];
    invoPaidAmount = json['invoPaidAmount'];
    invoAmount = json['invoAmount'];
    invoUpdatedBy = json['invoUpdatedBy'];
    invoUpdatedDate = json['invoUpdatedDate'];
    invoOwner = json['invoOwner'];
    invoOwnerId = json['invoOwnerId'];
    invoOpId = json['invoOpId'];
    invoPdId = json['invoPdId'];
    invoCreatedTime = json['invoCreatedTime'];
    invoUpdatedTime = json['invoUpdatedTime'];
    invoDesc = json['invoDesc'];
    invoCount = json['invoCount'];
     prodImgOne = json['prodImgOne'];
     user = json['user'];
  }
  dynamic invoId;
  dynamic invoCode;
  dynamic invoRef;
  dynamic invoPayType;
  dynamic invoDate;
  dynamic invoCreatedBy;
  dynamic invoCreatedDate;
  dynamic invoStatus;
  dynamic invoAccId;
  dynamic invoAccType;
  dynamic invoPatId;
  dynamic invoBillType;
  dynamic invoPaidAmount;
  dynamic invoAmount;
  dynamic invoUpdatedBy;
  dynamic invoUpdatedDate;
  dynamic invoOwner;
  dynamic invoOwnerId;
  dynamic invoOpId;
  dynamic invoPdId;
  dynamic invoCreatedTime;
  dynamic invoUpdatedTime;
  dynamic invoDesc;
  dynamic invoCount;
  dynamic  prodImgOne;
  dynamic  user;
Invoice copyWith({  dynamic invoId,
  dynamic invoCode,
  dynamic invoRef,
  dynamic invoPayType,
  dynamic invoDate,
  dynamic invoCreatedBy,
  dynamic invoCreatedDate,
  dynamic invoStatus,
  dynamic invoAccId,
  dynamic invoAccType,
  dynamic invoPatId,
  dynamic invoBillType,
  dynamic invoPaidAmount,
  dynamic invoAmount,
  dynamic invoUpdatedBy,
  dynamic invoUpdatedDate,
  dynamic invoOwner,
  dynamic invoOwnerId,
  dynamic invoOpId,
  dynamic invoPdId,
  dynamic invoCreatedTime,
  dynamic invoUpdatedTime,
  dynamic invoDesc,
  dynamic invoCount,
  dynamic prodImgOne,
  dynamic user,
}) => Invoice(  invoId: invoId ?? invoId,
  invoCode: invoCode ?? invoCode,
  invoRef: invoRef ?? invoRef,
  invoPayType: invoPayType ?? invoPayType,
  invoDate: invoDate ?? invoDate,
  invoCreatedBy: invoCreatedBy ?? invoCreatedBy,
  invoCreatedDate: invoCreatedDate ?? invoCreatedDate,
  invoStatus: invoStatus ?? invoStatus,
  invoAccId: invoAccId ?? invoAccId,
  invoAccType: invoAccType ?? invoAccType,
  invoPatId: invoPatId ?? invoPatId,
  invoBillType: invoBillType ?? invoBillType,
  invoPaidAmount: invoPaidAmount ?? invoPaidAmount,
  invoAmount: invoAmount ?? invoAmount,
  invoUpdatedBy: invoUpdatedBy ?? invoUpdatedBy,
  invoUpdatedDate: invoUpdatedDate ?? invoUpdatedDate,
  invoOwner: invoOwner ?? invoOwner,
  invoOwnerId: invoOwnerId ?? invoOwnerId,
  invoOpId: invoOpId ?? invoOpId,
  invoPdId: invoPdId ?? invoPdId,
  invoCreatedTime: invoCreatedTime ?? invoCreatedTime,
  invoUpdatedTime: invoUpdatedTime ?? invoUpdatedTime,
  invoDesc: invoDesc ?? invoDesc,
  invoCount: invoCount ?? invoCount,
  prodImgOne: prodImgOne ??  prodImgOne,
  user: user ??  user,
);

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['invoId'] = invoId;
    map['invoCode'] = invoCode;
    map['invoRef'] = invoRef;
    map['invoPayType'] = invoPayType;
    map['invoDate'] = invoDate;
    map['invoCreatedBy'] = invoCreatedBy;
    map['invoCreatedDate'] = invoCreatedDate;
    map['invoStatus'] = invoStatus;
    map['invoAccId'] = invoAccId;
    map['invoAccType'] = invoAccType;
    map['invoPatId'] = invoPatId;
    map['invoBillType'] = invoBillType;
    map['invoPaidAmount'] = invoPaidAmount;
    map['invoAmount'] = invoAmount;
    map['invoUpdatedBy'] = invoUpdatedBy;
    map['invoUpdatedDate'] = invoUpdatedDate;
    map['invoOwner'] = invoOwner;
    map['invoOwnerId'] = invoOwnerId;
    map['invoOpId'] = invoOpId;
    map['invoPdId'] = invoPdId;
    map['invoCreatedTime'] = invoCreatedTime;
    map['invoUpdatedTime'] = invoUpdatedTime;
    map['invoDesc'] = invoDesc;
    map['invoCount'] = invoCount;
    map['prodImgOne'] =  prodImgOne;
    map['user'] =  user;
    return map;
  }

}