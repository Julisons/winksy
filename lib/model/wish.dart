/// wishId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// wishPetId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// wishUsrId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// wishInstId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// wishDesc : "dynamic"
/// wishStatus : "dynamic"
/// wishCode : "dynamic"
/// wishType : "dynamic"

class Wish {
  Wish({
      dynamic wishId, 
      dynamic wishPetId, 
      dynamic wishUsrId, 
      dynamic wishInstId, 
      dynamic wishDesc, 
      dynamic wishStatus, 
      dynamic wishCode, 
      dynamic wishType,}){
    wishId = wishId;
    wishPetId = wishPetId;
    wishUsrId = wishUsrId;
    wishInstId = wishInstId;
    wishDesc = wishDesc;
    wishStatus = wishStatus;
    wishCode = wishCode;
    wishType = wishType;
}

  Wish.fromJson(dynamic json) {
    wishId = json['wishId'];
    wishPetId = json['wishPetId'];
    wishUsrId = json['wishUsrId'];
    wishInstId = json['wishInstId'];
    wishDesc = json['wishDesc'];
    wishStatus = json['wishStatus'];
    wishCode = json['wishCode'];
    wishType = json['wishType'];
  }
  dynamic wishId;
  dynamic wishPetId;
  dynamic wishUsrId;
  dynamic wishInstId;
  dynamic wishDesc;
  dynamic wishStatus;
  dynamic wishCode;
  dynamic wishType;
Wish copyWith({  dynamic wishId,
  dynamic wishPetId,
  dynamic wishUsrId,
  dynamic wishInstId,
  dynamic wishDesc,
  dynamic wishStatus,
  dynamic wishCode,
  dynamic wishType,
}) => Wish(  wishId: wishId ?? wishId,
  wishPetId: wishPetId ?? wishPetId,
  wishUsrId: wishUsrId ?? wishUsrId,
  wishInstId: wishInstId ?? wishInstId,
  wishDesc: wishDesc ?? wishDesc,
  wishStatus: wishStatus ?? wishStatus,
  wishCode: wishCode ?? wishCode,
  wishType: wishType ?? wishType,
);


  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['wishId'] = wishId;
    map['wishPetId'] = wishPetId;
    map['wishUsrId'] = wishUsrId;
    map['wishInstId'] = wishInstId;
    map['wishDesc'] = wishDesc;
    map['wishStatus'] = wishStatus;
    map['wishCode'] = wishCode;
    map['wishType'] = wishType;
    return map;
  }

}