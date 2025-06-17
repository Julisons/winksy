/// room : "quadrixroom"
/// usrId : "2c0ccf7a-0242-4608-98c0-ff6914e65a51"
/// user : "Austine Julisons"
/// action : "joinRoom"

class Quad {
  Quad({
      dynamic room, 
      dynamic usrId, 
      dynamic user, 
      dynamic action,
      dynamic row,
      dynamic column,
      dynamic player,

  }){
    room = room;
    usrId = usrId;
    user = user;
    action = action;
     row =row;
    column = column;
    player = player;
}

  Quad.fromJson(dynamic json) {
    room = json['room'];
    usrId = json['usrId'];
    user = json['user'];
    action = json['action'];
    row = json['row'];
    column = json['column'];
    player = json['player'];
  }
  dynamic room;
  dynamic usrId;
  dynamic user;
  dynamic action;
  dynamic row;
  dynamic column;
  dynamic player;
Quad copyWith({  dynamic room,
  dynamic usrId,
  dynamic user,
  dynamic action,
  dynamic row,
  dynamic column,
  dynamic player,
}) => Quad(  room: room ?? room,
  usrId: usrId ?? usrId,
  user: user ?? user,
  action: action ?? action,
  row: row ?? row,
  column: column ?? column,
  player: player ?? player,
);


  Map<dynamic, dynamic> toJson() {
    final map = <dynamic, dynamic>{};
    map['room'] = room;
    map['usrId'] = usrId;
    map['user'] = user;
    map['action'] = action;
    map['row'] = row;
    map['column'] = column;
    map['player'] = player;
    return map;
  }

}