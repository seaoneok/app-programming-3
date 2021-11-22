import 'package:flutter/material.dart';
import 'checkProvider.dart';
import 'navigation.dart';
import 'package:provider/provider.dart';

String userName = '';
String password = '';

class LoginPage extends StatelessWidget {

  final formKey = new GlobalKey<FormState>();

  void validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      print('Form is valid Email: $userName, password: $password');
    } else {
      print('Form is invalid Email: $userName, password: $password');
    }
  }

  Widget makeRowContainer(String title, bool isUserName) {
    return Container(
      child: Row(
        children: <Widget>[
          makeText(title),
          makeTextField(isUserName),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
      padding: EdgeInsets.only(left: 50, right: 50, top: 8, bottom: 8),
    );
  }

  Widget makeText(String title) {
    return Text( title,
      style: TextStyle(
        fontSize: 21,
      ),
    );
  }

  Widget makeTextField(bool isUserName) {
    // TextField 위젯의 크기를 변경하고 padding을 주려면 Container 위젯 필요.
    // TextField 독자적으로는 할 수 없음.
    return Container(
      child: TextField(
        controller: TextEditingController(),
        style: TextStyle(fontSize: 21, color: Colors.black),
        onChanged: (String str) {
          if(isUserName)
            userName = str;
          else
            password = str;
          page = 'Login';
        },
      ),
      width: 150,
      //padding: EdgeInsets.only(left: 16),
    );
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('2018313531 옥시원'),
      ),
      body:
        new Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
           children: <Widget>[
            Text("CORONA LIVE",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 41,
              color: Colors.blueGrey,
            )),

             Text("Login Please..",style: TextStyle(
              fontSize: 30,
              color: Colors.grey,
            )),
             Container(
              margin: EdgeInsets.only(left:50.0, top:50.0,right:50.0),
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(10.0),
                   border: Border.all(
                       color: Colors.grey
                   )
               ),
               child: new Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 crossAxisAlignment: CrossAxisAlignment.center,
                 children: <Widget>[
                   makeRowContainer('ID:', true),
                    makeRowContainer('PW:', false),
                    Container(child: RaisedButton(
                        child: Text('Login', style: TextStyle(fontSize: 21)),
                        onPressed: () {
                          if(userName == 'skku' && password == '1234') {
                          //new BodyPanel();
                          // new changeText();
                          return Navigator.push(
                            context, MaterialPageRoute(builder: (context) => NewPage()),
                            );
                          }
                        }
                        ),
                    ),
                ],
                  ),
                ),
              ],
              ),
            ),
          );

  }
}

class NewPage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    final check_Provider page=Provider.of<check_Provider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('2018313531 옥시원'),
      ),
      body: new Center(
        child:new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("CORONA LIVE",
                style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 41,
              color: Colors.blueGrey,
            )),
            Text("Login Success. Hello " + userName + "!!",
                style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            )),
            SizedBox(
              width:300,
              height:400,
              child:
              Image.asset('assets/images/coronalive.jpg'),
            ),
            ElevatedButton(
              onPressed: (){
                page.updatePage('Login');
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NavigationPage()),
                );
              },
              child:Text('Start CORONA LIVE'),
            )
          ],
        ),
      ),
    );
  }
}
