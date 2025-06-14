/// intId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// intUsrId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// intFolId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// intDesc : "dynamic"
/// intStatus : "dynamic"
/// intOwnerId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// intCode : "dynamic"
/// intInstId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// intType : "dynamic"

class Interest {
  Interest({
      dynamic intId, 
      dynamic intUsrId, 
      dynamic intFolId, 
      dynamic intDesc, 
      dynamic intStatus, 
      dynamic intOwnerId, 
      dynamic intCode, 
      dynamic intInstId, 
      dynamic intType,}){
    intId = intId;
    intUsrId = intUsrId;
    intFolId = intFolId;
    intDesc = intDesc;
    intStatus = intStatus;
    intOwnerId = intOwnerId;
    intCode = intCode;
    intInstId = intInstId;
    intType = intType;
}

  Interest.fromJson(dynamic json) {
    intId = json['intId'];
    intUsrId = json['intUsrId'];
    intFolId = json['intFolId'];
    intDesc = json['intDesc'];
    intStatus = json['intStatus'];
    intOwnerId = json['intOwnerId'];
    intCode = json['intCode'];
    intInstId = json['intInstId'];
    intType = json['intType'];
  }
  dynamic intId;
  dynamic intUsrId;
  dynamic intFolId;
  dynamic intDesc;
  dynamic intStatus;
  dynamic intOwnerId;
  dynamic intCode;
  dynamic intInstId;
  dynamic intType;
Interest copyWith({  dynamic intId,
  dynamic intUsrId,
  dynamic intFolId,
  dynamic intDesc,
  dynamic intStatus,
  dynamic intOwnerId,
  dynamic intCode,
  dynamic intInstId,
  dynamic intType,
}) => Interest(  intId: intId ?? intId,
  intUsrId: intUsrId ?? intUsrId,
  intFolId: intFolId ?? intFolId,
  intDesc: intDesc ?? intDesc,
  intStatus: intStatus ?? intStatus,
  intOwnerId: intOwnerId ?? intOwnerId,
  intCode: intCode ?? intCode,
  intInstId: intInstId ?? intInstId,
  intType: intType ?? intType,
);


  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['intId'] = intId;
    map['intUsrId'] = intUsrId;
    map['intFolId'] = intFolId;
    map['intDesc'] = intDesc;
    map['intStatus'] = intStatus;
    map['intOwnerId'] = intOwnerId;
    map['intCode'] = intCode;
    map['intInstId'] = intInstId;
    map['intType'] = intType;
    return map;
  }

}