import 'package:flutter/material.dart';
import 'package:flutter_pa3/checkProvider.dart';
import 'login.dart';
import 'cases.dart';
import 'vaccine.dart';
import 'package:provider/provider.dart';

String page='';

class NavigationPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final check_Provider page=Provider.of<check_Provider>(context);
    return new Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: new Text('Menu'),
      ),
      body:
      new Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextButton.icon(
              onPressed: () {
                return Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CasesPage()),
                );
              },
              icon: Icon(Icons.coronavirus_outlined,
              color: Colors.grey,),
              label: Text("     Cases/Deaths",
              style: TextStyle(
                color: Colors.grey,
              ),),
            ),
            TextButton.icon(
              onPressed: () {
                return Navigator.push(
                  context, MaterialPageRoute(builder: (context) => VaccinePage()),
                );
              },
              icon: Icon(Icons.local_hospital,
                color: Colors.grey,),
              label: Text("     Vaccine",
                style: TextStyle(
                  color: Colors.grey,
                ),),
            ),
        Container(
          margin: EdgeInsets.only(left:130.0, top:400.0),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Welcome! " + userName,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  )),
              Consumer<check_Provider>(builder: (context,page,child)=>
              Text("Previous: ${page.page} Page")),
            ],
          )
             ),
          ],
        ),
      ),
    );

  }
}