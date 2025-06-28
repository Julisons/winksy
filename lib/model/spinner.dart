/// spinId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// spinName : "dynamic"
/// spinAmount : 0
/// spinPath : "dynamic"
/// spinInstId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// spinDesc : "dynamic"
/// spinStatus : "dynamic"
/// spinCode : "dynamic"
/// spinType : "dynamic"

class Spinner {
  Spinner({
      dynamic spinId, 
      dynamic spinName, 
      dynamic spinAmount, 
      dynamic spinPath, 
      dynamic spinInstId, 
      dynamic spinDesc, 
      dynamic spinStatus, 
      dynamic spinCode, 
      dynamic spinType,}){
    spinId = spinId;
    spinName = spinName;
    spinAmount = spinAmount;
    spinPath = spinPath;
    spinInstId = spinInstId;
    spinDesc = spinDesc;
    spinStatus = spinStatus;
    spinCode = spinCode;
    spinType = spinType;
}

  Spinner.fromJson(dynamic json) {
    spinId = json['spinId'];
    spinName = json['spinName'];
    spinAmount = json['spinAmount'];
    spinPath = json['spinPath'];
    spinInstId = json['spinInstId'];
    spinDesc = json['spinDesc'];
    spinStatus = json['spinStatus'];
    spinCode = json['spinCode'];
    spinType = json['spinType'];
  }
  dynamic spinId;
  dynamic spinName;
  dynamic spinAmount;
  dynamic spinPath;
  dynamic spinInstId;
  dynamic spinDesc;
  dynamic spinStatus;
  dynamic spinCode;
  dynamic spinType;
Spinner copyWith({  dynamic spinId,
  dynamic spinName,
  dynamic spinAmount,
  dynamic spinPath,
  dynamic spinInstId,
  dynamic spinDesc,
  dynamic spinStatus,
  dynamic spinCode,
  dynamic spinType,
}) => Spinner(  spinId: spinId ?? spinId,
  spinName: spinName ?? spinName,
  spinAmount: spinAmount ?? spinAmount,
  spinPath: spinPath ?? spinPath,
  spinInstId: spinInstId ?? spinInstId,
  spinDesc: spinDesc ?? spinDesc,
  spinStatus: spinStatus ?? spinStatus,
  spinCode: spinCode ?? spinCode,
  spinType: spinType ?? spinType,
);

  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['spinId'] = spinId;
    map['spinName'] = spinName;
    map['spinAmount'] = spinAmount;
    map['spinPath'] = spinPath;
    map['spinInstId'] = spinInstId;
    map['spinDesc'] = spinDesc;
    map['spinStatus'] = spinStatus;
    map['spinCode'] = spinCode;
    map['spinType'] = spinType;
    return map;
  }

}