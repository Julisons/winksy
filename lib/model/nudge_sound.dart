/// nudgesId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// nudgesName : "dynamic"
/// nudgesPath : "dynamic"
/// nudgesInstId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// nudgesDesc : "dynamic"
/// nudgesStatus : "dynamic"
/// nudgesCode : "dynamic"
/// nudgesType : "dynamic"

class NudgeSound {
  NudgeSound({
      dynamic nudgesId, 
      dynamic nudgesName, 
      dynamic nudgesPath, 
      dynamic nudgesInstId, 
      dynamic nudgesDesc, 
      dynamic nudgesStatus, 
      dynamic nudgesCode, 
      dynamic nudgesType,}){
    nudgesId = nudgesId;
    nudgesName = nudgesName;
    nudgesPath = nudgesPath;
    nudgesInstId = nudgesInstId;
    nudgesDesc = nudgesDesc;
    nudgesStatus = nudgesStatus;
    nudgesCode = nudgesCode;
    nudgesType = nudgesType;
}

  NudgeSound.fromJson(dynamic json) {
    nudgesId = json['nudgesId'];
    nudgesName = json['nudgesName'];
    nudgesPath = json['nudgesPath'];
    nudgesInstId = json['nudgesInstId'];
    nudgesDesc = json['nudgesDesc'];
    nudgesStatus = json['nudgesStatus'];
    nudgesCode = json['nudgesCode'];
    nudgesType = json['nudgesType'];
  }
  dynamic nudgesId;
  dynamic nudgesName;
  dynamic nudgesPath;
  dynamic nudgesInstId;
  dynamic nudgesDesc;
  dynamic nudgesStatus;
  dynamic nudgesCode;
  dynamic nudgesType;
NudgeSound copyWith({  dynamic nudgesId,
  dynamic nudgesName,
  dynamic nudgesPath,
  dynamic nudgesInstId,
  dynamic nudgesDesc,
  dynamic nudgesStatus,
  dynamic nudgesCode,
  dynamic nudgesType,
}) => NudgeSound(  nudgesId: nudgesId ?? nudgesId,
  nudgesName: nudgesName ?? nudgesName,
  nudgesPath: nudgesPath ?? nudgesPath,
  nudgesInstId: nudgesInstId ?? nudgesInstId,
  nudgesDesc: nudgesDesc ?? nudgesDesc,
  nudgesStatus: nudgesStatus ?? nudgesStatus,
  nudgesCode: nudgesCode ?? nudgesCode,
  nudgesType: nudgesType ?? nudgesType,
);

  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['nudgesId'] = nudgesId;
    map['nudgesName'] = nudgesName;
    map['nudgesPath'] = nudgesPath;
    map['nudgesInstId'] = nudgesInstId;
    map['nudgesDesc'] = nudgesDesc;
    map['nudgesStatus'] = nudgesStatus;
    map['nudgesCode'] = nudgesCode;
    map['nudgesType'] = nudgesType;
    return map;
  }

}