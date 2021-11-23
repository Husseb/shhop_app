import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/provideors/auth.dart';
import 'package:provider/provider.dart';
import '../models/http_exptions.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key key}) : super(key: key);
  static const routName = '/auth-screen';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(
                        bottom: 20,
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 94),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.deepOrange.shade900,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 8,
                              color: Colors.black26,
                              offset: Offset(0, 2),
                            )
                          ]),
                      child: Text(
                        'My Shop',
                        style: TextStyle(
                            color: Theme.of(context).textTheme.headline6.color,
                            fontSize: 50,
                            fontFamily: 'Anton'),
                      ),
                    ),
                  ),
                  Flexible(
                    child: AuthCard(),
                    flex: (deviceSize.width > 600) ? 2 : 1,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

enum AuthMode { Login, SignUp }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoadding = false;
  final _passwordController = TextEditingController();

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _passwordController.text ='123456';
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _slideAnimation = Tween<Offset>(begin: Offset(0, -.15), end: Offset(0, 0))
        .animate(
            CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));
    _opacityAnimation = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    _formKey.currentState.save();
    setState(() {
      _isLoadding = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .login(_authData['email'], _authData['password']);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authData['email'], _authData['password']);
      }
    } on HttpExptions catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (e) {
      const errorMessage = "";
      _showErrorDialog(errorMessage);
    }
    ;

    setState(() {
      _isLoadding = false;
    });
  }

  void switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  void _showErrorDialog(String errorMessage) {
    showDialog<void>(
      context: context,
      // false = user must tap button, true = tap outside dialog
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('An Error Occurred!'),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: Text('Okey!'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss alert dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 8,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.SignUp ? 400 : 300,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.SignUp ? 400 : 300,
        ),
        width: deviceSize.width * .75,
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: 'test@test.com',
                   decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val.isEmpty || !val.contains('@')) {
                      return "Invalied Email";
                    }
                    return null;
                  },
                  onSaved: (val) => _authData['email'] = val,
                ),
                TextFormField(
                   decoration: InputDecoration(labelText: 'password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (val) {
                    if (val.isEmpty || val.length < 5) {
                      return "password is to short ";
                    }
                    return null;
                  },
                  onSaved: (val) => _authData['password'] = val,
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                    maxHeight: _authMode == AuthMode.SignUp ? 120 : 0,
                  ),
                  curve: Curves.easeIn,
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.SignUp,
                        decoration:
                            InputDecoration(labelText: 'Confirm password'),
                        obscureText: true,
                        validator: _authMode == AuthMode.SignUp
                            ? (val) {
                                if (val != _passwordController.text) {
                                  return "password  do not match     ";
                                }
                                return null;
                              }
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                _isLoadding
                    ? CircularProgressIndicator()
                    : Column(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 8),
                              textStyle: TextStyle(
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .headline6
                                    .color,
                              ),
                              primary: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            onPressed: () {
                              submit();
                            },
                            child: Text(
                              _authMode == AuthMode.SignUp
                                  ? "Sign Up"
                                  : "Login",
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 4),
                              textStyle: TextStyle(
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .headline6
                                    .color,
                              ),
                            ),
                            onPressed: () {
                              switchAuthMode();
                            },
                            child: Text(
                              " ${_authMode == AuthMode.Login ? 'Sign Up' : 'Login '} INSTEAD ",
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} /*      String message = "error dedicated";
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }*/
/*e se
await Provider.ofvkithy(context, listen: false) .signUpLauthDataremail.), authilatar [assword.th
) onIlttpException catch (error) 11
var errortlessage . Authentacation (errOr.l.lring().Contains(•MILJNISTS.))
errortlessage . •This email address is already in use.•; ) eiae (error.toString().containE(•IIPIAIIP_MIL•)) erroxPlessage • 'This is not a valid email address.; eiae if (error.toString().Ventains(IMAK PASS.OPO•)) errortilessage • 'This password is too weai..;
-,(error.toString().cntainsCEMAIL NOTFOUNO•)) errorPlessage • 'Could not find a user witr: that email..;
,f(errnr.tnItring().containsCINVALIppASSWOR0.» errortiessage . Invalid password.•■
showErroDialog(errorMessage); catch (error) 1
roost erroMessage •'Could not authenticate you. Please try again later.•; shlyeErrorDialog(errorMessage);
setState(0
isloading •• false; ));
e se
await Provider.ofvkithy(context, listen: false) .signUpLauthDataremail.), authilatar [assword.th
) onIlttpException catch (error) 11
var errortlessage . Authentacation (errOr.l.lring().Contains(•MILJNISTS.))
errortlessage . •This email address is already in use.•; ) eiae (error.toString().containE(•IIPIAIIP_MIL•)) erroxPlessage • 'This is not a valid email address.; eiae if (error.toString().Ventains(IMAK PASS.OPO•)) errortilessage • 'This password is too weai..;
-,(error.toString().cntainsCEMAIL NOTFOUNO•)) errorPlessage • 'Could not find a user witr: that email..;
,f(errnr.tnItring().containsCINVALIppASSWOR0.» errortiessage . Invalid password.•■
showErroDialog(errorMessage); catch (error) 1
roost erroMessage •'Could not authenticate you. Please try again later.•; shlyeErrorDialog(errorMessage);
setState(0
isloading •• false; ));
*/
