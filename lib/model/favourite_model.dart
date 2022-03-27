class FavouriteModel{
  String id,userId,typeId;
  String type;


  FavouriteModel(this.id, this.userId, this.typeId,this.type);

  FavouriteModel.fromMap(Map<String,dynamic> map)
      : id=map['id'],
        userId = map['userId'],
        type = map['type'],
        typeId = map['typeId'];


}
