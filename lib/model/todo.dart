class ToDo {
  int? _id;

  String? _title;
  String? _description;

  String? _date;
  int? _proiority;

  ToDo(this._title, this._proiority, this._date, this._description);

  ToDo.withID(
      this._id, this._title, this._proiority, this._date, this._description);

  int get proiority => _proiority!;

  String get date => _date!;

  String get description => _description!;

  String get title => _title!;

  int  get id => _id?? 0 ;

  set proiority(int value) {
    _proiority = value;
  }

  set date(String value) {
    _date = value;
  }

  set description(String value) {
    _description = value;
  }

  set title(String value) {
    _title = value;
  }

  set id(int value) {
    _id = value;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;
    map['proiority'] = _proiority;

        map['id'] = _id;



    return map;
  }

  ToDo.fromobject(dynamic o) {
    this.id = o["id"];
    this._title = o["title"];
    this._description = o["description"];
    this._date = o["date"];
    this._proiority = o["proiority"];
  }
}
