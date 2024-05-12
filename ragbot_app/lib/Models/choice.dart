class Choice{
  final String choiceId;
  final String choiceText;
  
  bool _isSelected;
  bool get isSelected => _isSelected;
  set isSelected(bool value){
    _isSelected = value;
  }

  Choice({required this.choiceId, required this.choiceText, required newIsSelected}) : _isSelected = newIsSelected;
}