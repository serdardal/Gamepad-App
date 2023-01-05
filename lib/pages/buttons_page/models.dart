class DataModel {
  int button;
  bool pushed;
  DataModel(this.button, this.pushed);
  Map toJson() => {'button': button, 'pushed': pushed};
}
