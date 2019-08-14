class User {
  String _uID;

  User(this._uID);
  String get uID => _uID;

  set uID(String newID) {
    this._uID = newID;
  }

  //convert into Map obj
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if(uID != null) {
      map['uID'] = _uID;
    }

    return map;
  }

  //extract uid obj from map obj
  User.fromMapObject(Map<String, dynamic> map) {
    this._uID = map['uID'];
  }
}