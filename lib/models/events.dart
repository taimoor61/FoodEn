class Event{

  Event({this.amount = 0, this.volunteerRequired = 0, this.description = "", this.isHandled = false, this.location = "", this.id, this.latitude, this.longitude});

  int amount;
  int volunteerRequired;
  String description;
  bool isHandled;
  String location;
  String id;
  String latitude;
  String longitude;
}