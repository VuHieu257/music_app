class UserData{
  String displayName;
  String email;
  String password;
  String img;
  String role;


  UserData({
    required this.displayName,
    required this.email,
    required this.password,
    required this.img,
    required this.role,
  });
  UserData.formJson(Map<String,Object>?json):this(
    displayName: json?['displayName']! as String,
    email: json?['email']! as String,
    password: json?['password']! as String,
    img: json?['img']! as String,
    role: json?['role']! as String,
  );
  UserData copyWith(
      {
        String? displayName,
        String? email,
        String?password,
        String?img,
        String?role,
      }){
    return UserData(
      displayName: displayName??this.displayName,
      email: email??this.email,
      password: password??this.password,
      img: img??this.img,
      role: role??this.role,
    );
  }
  Map<String,Object?>toJson(){
    return{
      'displayName':displayName,
      'email':email,
      'password':password,
      'img':img,
      'role':role,
    };
  }
}
