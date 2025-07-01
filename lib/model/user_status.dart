/// User online status model to match backend data structure
class UserStatus {
  UserStatus({
    this.usrId,
    this.userName,
    this.status,
    this.timestamp,
    this.lastSeen,
  });

  UserStatus.fromJson(dynamic json) {
    usrId = json['usrId']?.toString();
    userName = json['userName']?.toString();
    status = json['status']?.toString();
    timestamp = json['timestamp'] != null ? _parseDateTime(json['timestamp']) : null;
    lastSeen = json['lastSeen'] != null ? _parseDateTime(json['lastSeen']) : null;
  }
  
  DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return DateTime.tryParse(value);
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    return null;
  }

  String? usrId;
  String? userName;
  String? status; // 'online' or 'offline'
  DateTime? timestamp;
  DateTime? lastSeen;

  bool get isOnline => status == 'online';
  
  String get displayStatus {
    if (isOnline) return 'Online';
    if (lastSeen != null) {
      final now = DateTime.now();
      final difference = now.difference(lastSeen!);
      
      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes}m ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours}h ago';
      } else {
        return '${difference.inDays}d ago';
      }
    }
    return 'Offline';
  }

  UserStatus copyWith({
    String? usrId,
    String? userName,
    String? status,
    DateTime? timestamp,
    DateTime? lastSeen,
  }) => UserStatus(
    usrId: usrId ?? this.usrId,
    userName: userName ?? this.userName,
    status: status ?? this.status,
    timestamp: timestamp ?? this.timestamp,
    lastSeen: lastSeen ?? this.lastSeen,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['usrId'] = usrId;
    map['userName'] = userName;
    map['status'] = status;
    if (timestamp != null) map['timestamp'] = timestamp!.toIso8601String();
    if (lastSeen != null) map['lastSeen'] = lastSeen!.toIso8601String();
    return map;
  }
}