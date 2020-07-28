import 'package:flutter/material.dart';
import 'package:flutter_agenda_contato/helpers/contact_helper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper _helper = ContactHelper();


  @override
  void initState() {
    super.initState();

//    Contact c = new Contact();
//    c.name = "Nome da pessoa";
//    c.email = "email@email.com";
//    c.phone = "34343434";
//    c.img = "imagem";
//
//    _helper.saveContact(c);

  _helper.getAllContacts().then((list) => print(list));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
