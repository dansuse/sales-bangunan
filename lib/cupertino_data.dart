class CupertinoData{
  String information;
  int idInformation;
  int index;
  CupertinoData(this.index,this.idInformation,this.information);
  CupertinoData.empty(){
    index = -1;
    idInformation = -1;
    information = "";
  }
  bool isEmpty(){
    return index == -1;
  }
}