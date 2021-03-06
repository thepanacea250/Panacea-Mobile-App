import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:panacea/screens/no/email_password/confirm_email.dart';
import 'package:panacea/screens/yes/backup_keys.dart';

class SendKeyToEmail extends StatefulWidget {
  static const String id = 'send-key-to-email';

  @override
  _SendKeyToEmailState createState() => _SendKeyToEmailState();
}

class _SendKeyToEmailState extends State<SendKeyToEmail> {
  final _formKey = GlobalKey<FormState>();
  Icon? icon;
  bool _visible = false;
  var _emailTextController = TextEditingController();
  String? email;
  String? password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset : false,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                child: Row(
                  children: [
                    IconButton(onPressed: (){
                      Navigator.pushNamed(context, BackupKeys.id);
                    },
                        icon: Icon(CupertinoIcons.arrow_left, color: Colors.black,)),
                    SizedBox(width: 30,),
                    Center(child: Text('Backup Your Keys',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                      // Text('Sign In')
                    ),

                  ],
                ),
              ),
              SizedBox(height: 80,),
              Container(
                child: TextFormField(
                  cursorColor: Colors.black,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  controller: _emailTextController,
                  validator: (value) {
                    if(value!.isEmpty){
                      return 'Please enter Email';
                    }
                    final bool _isValid = EmailValidator.validate(
                        _emailTextController.text
                    );
                    if(!_isValid){
                      return 'Invalid email format';
                    }
                    setState(() {
                      email = value;
                    });
                    return null;
                  },
                  decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    contentPadding: EdgeInsets.zero,
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.black,),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black,
                          width: 2
                      ),
                    ),
                    focusColor: Colors.black,
                  ),
                ),

              ),
              SizedBox(
                height: 80,
              ),
              Center(
                child: TextButton(onPressed: (){
                  Navigator.pushNamed(context, ConfirmEmail.id);
                },
                  child: Text('Backup Keys'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
