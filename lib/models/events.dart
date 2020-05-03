class Event{

  Event({this.amount = 0, this.volunteerRequired = 0, this.description = "", this.isHandled = false});

  int amount;
  int volunteerRequired;
  String description;
  bool isHandled;
}

List<Event> events = [
  Event(amount: 5, volunteerRequired: 2, description: "Left over burgers and pizza", isHandled: true),
  Event(amount: 10, volunteerRequired: 2, description: "Left over food from a marriage hall"),
  Event(amount: 15, volunteerRequired: 3, description: "Prepared food to be distributed among the needy", isHandled: true),
  Event(amount: 2, volunteerRequired: 1, description: "Some leftover food", isHandled: true),
  Event(amount: 5, volunteerRequired: 2, description: "Left over burgers and pizza"),
  Event(amount: 10, volunteerRequired: 2, description: "Left over food from a marriage hall", isHandled: true),
  Event(amount: 15, volunteerRequired: 3, description: "Prepared food to be distributed among the needy"),
  Event(amount: 2, volunteerRequired: 1, description: "Some leftover food", isHandled: true),
  Event(amount: 5, volunteerRequired: 2, description: "Left over burgers and pizza", isHandled: true),
  Event(amount: 10, volunteerRequired: 2, description: "Left over food from a marriage hall"),
  Event(amount: 15, volunteerRequired: 3, description: "Prepared food to be distributed among the needy"),
  Event(amount: 2, volunteerRequired: 1, description: "Some leftover food", isHandled: true),
  Event(amount: 5, volunteerRequired: 2, description: "Left over burgers and pizza"),
  Event(amount: 10, volunteerRequired: 2, description: "Left over food from a marriage hall"),
  Event(amount: 15, volunteerRequired: 3, description: "Prepared food to be distributed among the needy"),
  Event(amount: 2, volunteerRequired: 1, description: "Some leftover food"),
  Event(amount: 5, volunteerRequired: 2, description: "Left over burgers and pizza"),
  Event(amount: 10, volunteerRequired: 2, description: "Left over food from a marriage hall"),
  Event(amount: 15, volunteerRequired: 3, description: "Prepared food to be distributed among the needy"),
  Event(amount: 2, volunteerRequired: 1, description: "Some leftover food")
];