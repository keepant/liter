import 'package:flutter/material.dart';
import 'package:liter/add.dart';
import 'package:liter/db_helper.dart' as db;

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liter'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Add()),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<db.Dog>>(
          future: db.dogs(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  var dog = snapshot.data[index];
                  print(dog.id);
                  return ListTile(
                    title: Text(dog.name),
                    subtitle: Text(dog.age.toString()),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        await db.deleteDog(dog.id);
                      },
                    ),
                  );
                },
              );
            }

            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            );
          },
        ),
      ),
    );
  }
}
