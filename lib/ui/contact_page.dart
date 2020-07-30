import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_agenda_contato/helpers/contact_helper.dart';


class ContactPage extends StatefulWidget {

  final Contact contact;

  //construtor com parametro opcional
  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  Contact _editedContact;

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _userEdited = false;

  @override
  void initState() {
    super.initState();

    //acessando var da classe acima
    if(widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      //para preencher os campos em caso de edição
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text( _editedContact.name ?? "Contatos"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.save),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            GestureDetector(
              child: Container(
                width: 140.0,
                height: 140.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: _editedContact.img != null ?
                      FileImage(File(_editedContact.img)) :
                      AssetImage("images/person.png"),
                      fit: BoxFit.cover
                  ),
                ),
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Nome"),
              onChanged: (text) {
                setState(() {
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                });
              },
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "E-mail"),
              keyboardType: TextInputType.emailAddress,
              onChanged: (text) {
                setState(() {
                  _userEdited = true;
                  setState(() {
                    _editedContact.email = text;
                  });
                });
              },
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Phone"),
              keyboardType: TextInputType.phone,
              onChanged: (text) {
                setState(() {
                  _userEdited = true;
                  setState(() {
                    _editedContact.phone = text;
                  });
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
