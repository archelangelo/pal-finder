import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pal_finder/core/networking.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final String _welcomeString = 'Login:';
  final Future<int> _timer = Future<int>.delayed(
    Duration(seconds: 2),
    () => 0,
  );

  @override
  Widget build(BuildContext context) {
    print('Building login page... $context');
    return FutureBuilder<int>(
      future: _timer,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        if (snapshot.hasData) {
          return _loginScreen(context);
        } else {
          return _splashScreen(context);
        }
      },
    );
  }
          
  Widget _loginScreen(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if(Navigator.canPop(context)) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/home',
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      child: Scaffold(
        body: Center(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 45.0),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                    ),
                    style: TextStyle(fontSize: 18.0, color: Colors.grey, fontWeight: FontWeight.bold, ),
                  ),
                  SizedBox(height: 25.0),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                    style: TextStyle(fontSize: 18.0, color: Colors.grey, fontWeight: FontWeight.bold, ),
                  ),
                  SizedBox(
                    height: 35.0,
                  ),
                  RaisedButton(
                    onPressed: () {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      // TODO: Implement login and get token method
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => _LoadingScreen(
                            _usernameController.text,
                            _passwordController.text
                          ),
                        ),
                      );
                    },
                    child: Text("LOGIN",
                        style: TextStyle(color: Colors.white,
                            fontSize: 22.0)
                    ),
                    color: Colors.blue,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
          
  Widget _splashScreen(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Column(
          children: <Widget>[
            Expanded(child:
              Container(decoration: BoxDecoration(color: Colors.black),
                alignment: FractionalOffset(0.5, 0.3),
                child: Text("TestApp", style: TextStyle(fontSize: 40.0, color: Colors.white),),
              ),
            ),
            Container(margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
              child: Text("© Copyright Statement 2018", style: TextStyle(fontSize: 16.0, color: Colors.white,),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class _LoadingScreen extends StatefulWidget {
  _LoadingScreen(this._username, this._password);

  final String _username;
  final String _password;

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<_LoadingScreen> {
  
  @override
  void initState() {
    super.initState();
    _loginUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Column(
          children: <Widget>[
            Expanded(child:
              Container(decoration: BoxDecoration(color: Colors.black),
                alignment: FractionalOffset(0.5, 0.3),
                child: Text("Loading...", style: TextStyle(fontSize: 40.0, color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loginUser(BuildContext context) async {
    try {
      await Networking().loginUser(widget._username, widget._password);
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/home',
        (Route<dynamic> route) => false,
      );
    } catch(err) {
      print('Error caught: $err');
      Navigator.pop(context);
    }
  }
}

// class _SplashScreen extends StatelessWidget {
//   // final int splashDuration = 2;

//   // _startTimer(BuildContext context) async {
//   //   Future.delayed(
//   //     Duration(seconds: splashDuration),
//   //     () {
//   //       SystemChannels.textInput.invokeMethod('TextInput.hide');
//   //       Navigator.pushReplacementNamed(context, '/login');
//   //     },
//   //   );
//   // }

//   @override
//   Widget build(BuildContext context) {
//     print('Building splashscreen in $context');
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(color: Colors.black),
//         child: Column(
//           children: <Widget>[
//             Expanded(child:
//               Container(decoration: BoxDecoration(color: Colors.black),
//                 alignment: FractionalOffset(0.5, 0.3),
//                 child: Text("TestApp", style: TextStyle(fontSize: 40.0, color: Colors.white),),
//               ),
//             ),
//             Container(margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 30.0),
//               child: Text("© Copyright Statement 2018", style: TextStyle(fontSize: 16.0, color: Colors.white,),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }