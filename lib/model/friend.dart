/// frndId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// frndUsrId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// frndFolId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// frndDesc : "string"
/// frndStatus : "string"
/// frndOwnerId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// frndCode : "string"
/// frndInstId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// frndType : "string"

class Friend {
  Friend({
      dynamic frndId, 
      dynamic frndUsrId, 
      dynamic frndFolId, 
      dynamic frndDesc, 
      dynamic frndStatus, 
      dynamic frndOwnerId, 
      dynamic frndCode, 
      dynamic frndInstId, 
      dynamic frndType,}){
    frndId = frndId;
    frndUsrId = frndUsrId;
    frndFolId = frndFolId;
    frndDesc = frndDesc;
    frndStatus = frndStatus;
    frndOwnerId = frndOwnerId;
    frndCode = frndCode;
    frndInstId = frndInstId;
    frndType = frndType;
}

  Friend.fromJson(dynamic json) {
    frndId = json['frndId'];
    frndUsrId = json['frndUsrId'];
    frndFolId = json['frndFolId'];
    frndDesc = json['frndDesc'];
    frndStatus = json['frndStatus'];
    frndOwnerId = json['frndOwnerId'];
    frndCode = json['frndCode'];
    frndInstId = json['frndInstId'];
    frndType = json['frndType'];
  }
  dynamic frndId;
  dynamic frndUsrId;
  dynamic frndFolId;
  dynamic frndDesc;
  dynamic frndStatus;
  dynamic frndOwnerId;
  dynamic frndCode;
  dynamic frndInstId;
  dynamic frndType;
Friend copyWith({  dynamic frndId,
  dynamic frndUsrId,
  dynamic frndFolId,
  dynamic frndDesc,
  dynamic frndStatus,
  dynamic frndOwnerId,
  dynamic frndCode,
  dynamic frndInstId,
  dynamic frndType,
}) => Friend(  frndId: frndId ?? frndId,
  frndUsrId: frndUsrId ?? frndUsrId,
  frndFolId: frndFolId ?? frndFolId,
  frndDesc: frndDesc ?? frndDesc,
  frndStatus: frndStatus ?? frndStatus,
  frndOwnerId: frndOwnerId ?? frndOwnerId,
  frndCode: frndCode ?? frndCode,
  frndInstId: frndInstId ?? frndInstId,
  frndType: frndType ?? frndType,
);

  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['frndId'] = frndId;
    map['frndUsrId'] = frndUsrId;
    map['frndFolId'] = frndFolId;
    map['frndDesc'] = frndDesc;
    map['frndStatus'] = frndStatus;
    map['frndOwnerId'] = frndOwnerId;
    map['frndCode'] = frndCode;
    map['frndInstId'] = frndInstId;
    map['frndType'] = frndType;
    return map;
  }

}