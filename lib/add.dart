import 'package:flutter/material.dart';
import 'package:liter/home.dart';
import 'db_helper.dart' as db;

class Add extends StatefulWidget {
  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  final TextEditingController _dogName = new TextEditingController();
  final TextEditingController _dogAge = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Add dog'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _dogName,
                validator: (value) => value.isEmpty ? 'Must not null' : null,
                decoration: InputDecoration(
                    hintText: 'Dog name', labelText: 'Dog name'),
              ),
              SizedBox(
                height: 15.0,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _dogAge,
                validator: (value) => value.isEmpty ? 'Must not null' : null,
                decoration: InputDecoration(
                  hintText: 'Dog age',
                  labelText: 'Age',
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  child: Text('Save'),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      print('name: ${_dogName.text}\nage: ${_dogAge.text}');

                      var newDog = db.Dog(
                        name: _dogName.text,
                        age: int.parse(_dogAge.text),
                      );

                      await db.insertDog(newDog);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Home(),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
