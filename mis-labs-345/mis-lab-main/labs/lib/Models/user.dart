import 'list_item.dart';

class User {
  final String id;
  final String username;
  final String password;
  final List<ListItem> listItems;

  User({required this.id, required this.username, required this.password, required this.listItems});
  
}