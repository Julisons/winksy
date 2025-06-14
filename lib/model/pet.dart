/// petId : "81d48941-69db-42aa-9f67-cb9511b18d27"
/// petUsrId : "202e4835-854e-47f0-8433-ecc5364b0cc2"
/// petOwnerId : "2c0ccf7a-0242-4608-98c0-ff6914e65a51"
/// petValue : 0
/// petLockedUntil : "2025-06-13T17:49:05.036+00:00"
/// petBoosts : "string"
/// petRename : "string"
/// petLastBoughtAt : "2025-06-13T17:49:05.036+00:00"
/// petCash : 0
/// petCreatedBy : "202e4835-854e-47f0-8433-ecc5364b0cc2"
/// petCreatedDate : "2025-06-12T21:00:00.000+00:00"
/// petCreatedTime : "2025-06-13T17:50:09.268+00:00"
/// petInstId : null
/// petUpdatedBy : null
/// petUpdatedDate : "2025-06-12T21:00:00.000+00:00"
/// petUpdatedTime : "2025-06-13T17:50:09.268+00:00"
/// petDesc : "string"
/// petStatus : "ACTIVE"
/// petCode : "string"
/// petType : "string"
/// petLastActive : "string"
/// petLastActiveTime : "2025-06-13T17:49:05.036+00:00"
/// petLastPurchase : "2025-06-13T17:49:05.036+00:00"
/// usrFullNames : "Julisons"
/// usrImage : "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=800&h=800&fit=crop&crop=face"
/// usrOwner : "Austine Julisons"

class Pet {
  Pet({
      dynamic petId, 
      dynamic petUsrId, 
      dynamic petOwnerId, 
      dynamic petValue, 
      dynamic petLockedUntil, 
      dynamic petBoosts, 
      dynamic petRename, 
      dynamic petLastBoughtAt, 
      dynamic petCash, 
      dynamic petCreatedBy, 
      dynamic petCreatedDate, 
      dynamic petCreatedTime, 
      dynamic petInstId, 
      dynamic petUpdatedBy, 
      dynamic petUpdatedDate, 
      dynamic petUpdatedTime, 
      dynamic petDesc, 
      dynamic petStatus, 
      dynamic petCode, 
      dynamic petType, 
      dynamic petLastActive, 
      dynamic petLastActiveTime, 
      dynamic petLastPurchase, 
      dynamic usrFullNames, 
      dynamic usrImage, 
      dynamic usrOwner,}){
    petId = petId;
    petUsrId = petUsrId;
    petOwnerId = petOwnerId;
    petValue = petValue;
    petLockedUntil = petLockedUntil;
    petBoosts = petBoosts;
    petRename = petRename;
    petLastBoughtAt = petLastBoughtAt;
    petCash = petCash;
    petCreatedBy = petCreatedBy;
    petCreatedDate = petCreatedDate;
    petCreatedTime = petCreatedTime;
    petInstId = petInstId;
    petUpdatedBy = petUpdatedBy;
    petUpdatedDate = petUpdatedDate;
    petUpdatedTime = petUpdatedTime;
    petDesc = petDesc;
    petStatus = petStatus;
    petCode = petCode;
    petType = petType;
    petLastActive = petLastActive;
    petLastActiveTime = petLastActiveTime;
    petLastPurchase = petLastPurchase;
    usrFullNames = usrFullNames;
    usrImage = usrImage;
    usrOwner = usrOwner;
}

  Pet.fromJson(dynamic json) {
    petId = json['petId'];
    petUsrId = json['petUsrId'];
    petOwnerId = json['petOwnerId'];
    petValue = json['petValue'];
    petLockedUntil = json['petLockedUntil'];
    petBoosts = json['petBoosts'];
    petRename = json['petRename'];
    petLastBoughtAt = json['petLastBoughtAt'];
    petCash = json['petCash'];
    petCreatedBy = json['petCreatedBy'];
    petCreatedDate = json['petCreatedDate'];
    petCreatedTime = json['petCreatedTime'];
    petInstId = json['petInstId'];
    petUpdatedBy = json['petUpdatedBy'];
    petUpdatedDate = json['petUpdatedDate'];
    petUpdatedTime = json['petUpdatedTime'];
    petDesc = json['petDesc'];
    petStatus = json['petStatus'];
    petCode = json['petCode'];
    petType = json['petType'];
    petLastActive = json['petLastActive'];
    petLastActiveTime = json['petLastActiveTime'];
    petLastPurchase = json['petLastPurchase'];
    usrFullNames = json['usrFullNames'];
    usrImage = json['usrImage'];
    usrOwner = json['usrOwner'];
  }
  dynamic petId;
  dynamic petUsrId;
  dynamic petOwnerId;
  dynamic petValue;
  dynamic petLockedUntil;
  dynamic petBoosts;
  dynamic petRename;
  dynamic petLastBoughtAt;
  dynamic petCash;
  dynamic petCreatedBy;
  dynamic petCreatedDate;
  dynamic petCreatedTime;
  dynamic petInstId;
  dynamic petUpdatedBy;
  dynamic petUpdatedDate;
  dynamic petUpdatedTime;
  dynamic petDesc;
  dynamic petStatus;
  dynamic petCode;
  dynamic petType;
  dynamic petLastActive;
  dynamic petLastActiveTime;
  dynamic petLastPurchase;
  dynamic usrFullNames;
  dynamic usrImage;
  dynamic usrOwner;
Pet copyWith({  dynamic petId,
  dynamic petUsrId,
  dynamic petOwnerId,
  dynamic petValue,
  dynamic petLockedUntil,
  dynamic petBoosts,
  dynamic petRename,
  dynamic petLastBoughtAt,
  dynamic petCash,
  dynamic petCreatedBy,
  dynamic petCreatedDate,
  dynamic petCreatedTime,
  dynamic petInstId,
  dynamic petUpdatedBy,
  dynamic petUpdatedDate,
  dynamic petUpdatedTime,
  dynamic petDesc,
  dynamic petStatus,
  dynamic petCode,
  dynamic petType,
  dynamic petLastActive,
  dynamic petLastActiveTime,
  dynamic petLastPurchase,
  dynamic usrFullNames,
  dynamic usrImage,
  dynamic usrOwner,
}) => Pet(  petId: petId ?? petId,
  petUsrId: petUsrId ?? petUsrId,
  petOwnerId: petOwnerId ?? petOwnerId,
  petValue: petValue ?? petValue,
  petLockedUntil: petLockedUntil ?? petLockedUntil,
  petBoosts: petBoosts ?? petBoosts,
  petRename: petRename ?? petRename,
  petLastBoughtAt: petLastBoughtAt ?? petLastBoughtAt,
  petCash: petCash ?? petCash,
  petCreatedBy: petCreatedBy ?? petCreatedBy,
  petCreatedDate: petCreatedDate ?? petCreatedDate,
  petCreatedTime: petCreatedTime ?? petCreatedTime,
  petInstId: petInstId ?? petInstId,
  petUpdatedBy: petUpdatedBy ?? petUpdatedBy,
  petUpdatedDate: petUpdatedDate ?? petUpdatedDate,
  petUpdatedTime: petUpdatedTime ?? petUpdatedTime,
  petDesc: petDesc ?? petDesc,
  petStatus: petStatus ?? petStatus,
  petCode: petCode ?? petCode,
  petType: petType ?? petType,
  petLastActive: petLastActive ?? petLastActive,
  petLastActiveTime: petLastActiveTime ?? petLastActiveTime,
  petLastPurchase: petLastPurchase ?? petLastPurchase,
  usrFullNames: usrFullNames ?? usrFullNames,
  usrImage: usrImage ?? usrImage,
  usrOwner: usrOwner ?? usrOwner,
);


  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['petId'] = petId;
    map['petUsrId'] = petUsrId;
    map['petOwnerId'] = petOwnerId;
    map['petValue'] = petValue;
    map['petLockedUntil'] = petLockedUntil;
    map['petBoosts'] = petBoosts;
    map['petRename'] = petRename;
    map['petLastBoughtAt'] = petLastBoughtAt;
    map['petCash'] = petCash;
    map['petCreatedBy'] = petCreatedBy;
    map['petCreatedDate'] = petCreatedDate;
    map['petCreatedTime'] = petCreatedTime;
    map['petInstId'] = petInstId;
    map['petUpdatedBy'] = petUpdatedBy;
    map['petUpdatedDate'] = petUpdatedDate;
    map['petUpdatedTime'] = petUpdatedTime;
    map['petDesc'] = petDesc;
    map['petStatus'] = petStatus;
    map['petCode'] = petCode;
    map['petType'] = petType;
    map['petLastActive'] = petLastActive;
    map['petLastActiveTime'] = petLastActiveTime;
    map['petLastPurchase'] = petLastPurchase;
    map['usrFullNames'] = usrFullNames;
    map['usrImage'] = usrImage;
    map['usrOwner'] = usrOwner;
    return map;
  }

}