/// quadId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// quadUsrId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// quadAgainstId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// quadState : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// quadWinnerId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// quadInstId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// quadDesc : "dynamic"
/// quadStatus : "dynamic"
/// quadCode : "dynamic"
/// quadType : "dynamic"
/// quadRow : "dynamic"
/// quadPlayer : "dynamic"
/// quadColumn : "dynamic"
/// quadUser : "dynamic"
/// quadAgainst : "dynamic"
/// quadFirstPlayer : 0
/// quadFirstPlayerId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"
/// quadPlayerId : "3fa85f64-5717-4562-b3fc-2c963f66afa6"

class Quad {
  Quad({
      dynamic quadId, 
      dynamic quadUsrId, 
      dynamic quadAgainstId, 
      dynamic quadState, 
      dynamic quadWinnerId, 
      dynamic quadInstId, 
      dynamic quadDesc, 
      dynamic quadStatus, 
      dynamic quadCode, 
      dynamic quadType, 
      dynamic quadRow, 
      dynamic quadPlayer, 
      dynamic quadColumn, 
      dynamic quadUser, 
      dynamic quadAgainst, 
      dynamic quadFirstPlayer, 
      dynamic quadFirstPlayerId, 
      dynamic quadPlayerId,}){
    quadId = quadId;
    quadUsrId = quadUsrId;
    quadAgainstId = quadAgainstId;
    quadState = quadState;
    quadWinnerId = quadWinnerId;
    quadInstId = quadInstId;
    quadDesc = quadDesc;
    quadStatus = quadStatus;
    quadCode = quadCode;
    quadType = quadType;
    quadRow = quadRow;
    quadPlayer = quadPlayer;
    quadColumn = quadColumn;
    quadUser = quadUser;
    quadAgainst = quadAgainst;
    quadFirstPlayer = quadFirstPlayer;
    quadFirstPlayerId = quadFirstPlayerId;
    quadPlayerId = quadPlayerId;
}

  Quad.fromJson(dynamic json) {
    quadId = json['quadId'];
    quadUsrId = json['quadUsrId'];
    quadAgainstId = json['quadAgainstId'];
    quadState = json['quadState'];
    quadWinnerId = json['quadWinnerId'];
    quadInstId = json['quadInstId'];
    quadDesc = json['quadDesc'];
    quadStatus = json['quadStatus'];
    quadCode = json['quadCode'];
    quadType = json['quadType'];
    quadRow = json['quadRow'];
    quadPlayer = json['quadPlayer'];
    quadColumn = json['quadColumn'];
    quadUser = json['quadUser'];
    quadAgainst = json['quadAgainst'];
    quadFirstPlayer = json['quadFirstPlayer'];
    quadFirstPlayerId = json['quadFirstPlayerId'];
    quadPlayerId = json['quadPlayerId'];
  }
  dynamic quadId;
  dynamic quadUsrId;
  dynamic quadAgainstId;
  dynamic quadState;
  dynamic quadWinnerId;
  dynamic quadInstId;
  dynamic quadDesc;
  dynamic quadStatus;
  dynamic quadCode;
  dynamic quadType;
  dynamic quadRow;
  dynamic quadPlayer;
  dynamic quadColumn;
  dynamic quadUser;
  dynamic quadAgainst;
  dynamic quadFirstPlayer;
  dynamic quadFirstPlayerId;
  dynamic quadPlayerId;
Quad copyWith({  dynamic quadId,
  dynamic quadUsrId,
  dynamic quadAgainstId,
  dynamic quadState,
  dynamic quadWinnerId,
  dynamic quadInstId,
  dynamic quadDesc,
  dynamic quadStatus,
  dynamic quadCode,
  dynamic quadType,
  dynamic quadRow,
  dynamic quadPlayer,
  dynamic quadColumn,
  dynamic quadUser,
  dynamic quadAgainst,
  dynamic quadFirstPlayer,
  dynamic quadFirstPlayerId,
  dynamic quadPlayerId,
}) => Quad(  quadId: quadId ?? quadId,
  quadUsrId: quadUsrId ?? quadUsrId,
  quadAgainstId: quadAgainstId ?? quadAgainstId,
  quadState: quadState ?? quadState,
  quadWinnerId: quadWinnerId ?? quadWinnerId,
  quadInstId: quadInstId ?? quadInstId,
  quadDesc: quadDesc ?? quadDesc,
  quadStatus: quadStatus ?? quadStatus,
  quadCode: quadCode ?? quadCode,
  quadType: quadType ?? quadType,
  quadRow: quadRow ?? quadRow,
  quadPlayer: quadPlayer ?? quadPlayer,
  quadColumn: quadColumn ?? quadColumn,
  quadUser: quadUser ?? quadUser,
  quadAgainst: quadAgainst ?? quadAgainst,
  quadFirstPlayer: quadFirstPlayer ?? quadFirstPlayer,
  quadFirstPlayerId: quadFirstPlayerId ?? quadFirstPlayerId,
  quadPlayerId: quadPlayerId ?? quadPlayerId,
);


  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['quadId'] = quadId;
    map['quadUsrId'] = quadUsrId;
    map['quadAgainstId'] = quadAgainstId;
    map['quadState'] = quadState;
    map['quadWinnerId'] = quadWinnerId;
    map['quadInstId'] = quadInstId;
    map['quadDesc'] = quadDesc;
    map['quadStatus'] = quadStatus;
    map['quadCode'] = quadCode;
    map['quadType'] = quadType;
    map['quadRow'] = quadRow;
    map['quadPlayer'] = quadPlayer;
    map['quadColumn'] = quadColumn;
    map['quadUser'] = quadUser;
    map['quadAgainst'] = quadAgainst;
    map['quadFirstPlayer'] = quadFirstPlayer;
    map['quadFirstPlayerId'] = quadFirstPlayerId;
    map['quadPlayerId'] = quadPlayerId;
    return map;
  }

}