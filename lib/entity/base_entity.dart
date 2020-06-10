abstract class BaseEntity<T>{
  T fromJson(Map<String,dynamic> json);
}