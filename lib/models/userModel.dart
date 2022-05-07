class UserModel{
  String? uid;
  String? email;
  String? name;
  String? profileimg;

  UserModel({this.uid,this.email,this.name,this.profileimg});

  UserModel.formMap(Map<String,dynamic> u){
    uid=u["uid"];
    email=u["email"];
    name=u["name"];
    profileimg=u["profileimg"];
  }

  Map<String,dynamic> toMap(){
    return{
      "uid":uid,
      "email":email,
      "name":name,
      "profileimg":profileimg
    };
  }

}