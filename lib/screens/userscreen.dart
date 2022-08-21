import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:musicapp/repository/user_operations.dart';
import 'package:musicapp/screens/songs.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  _UserScreenState createState() => _UserScreenState();
}

Text _getText(String text, double fontsize, FontWeight fweight,
    {Color color = Colors.black}) {
  return Text(
    text,
    style: GoogleFonts.laila(
        textStyle:
            TextStyle(fontSize: fontsize, fontWeight: fweight, color: color)),
  );
}

class DeviceDimensions {
  BuildContext context;

  DeviceDimensions(this.context);

  double get width => MediaQuery.of(context).size.width;
  double get height => MediaQuery.of(context).size.height;
}

class _UserScreenState extends State<UserScreen> {
  TextEditingController loginEmail = TextEditingController();
  TextEditingController loginPwd = TextEditingController();
  bool obscure = true;

  _showLogin() {
    // ignore: sized_box_for_whitespace
    return Container(
      height: DeviceDimensions(context).height,
      width: DeviceDimensions(context).width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.center,

        children: [
          SizedBox(
            height: DeviceDimensions(context).height / 10,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 10),
              child: _getText('Login', 40, FontWeight.bold)),
          SizedBox(
            height: DeviceDimensions(context).height / 50,
          ),
          Padding(
              padding: const EdgeInsets.only(left: 10),
              child: _getText(
                'Please sign in to continue.',
                20,
                FontWeight.bold,
              )),
          SizedBox(
            height: DeviceDimensions(context).height / 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: loginEmail,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.mail_outline_rounded,
                    size: 30,
                  ),
                  suffixIcon: GestureDetector(
                    child: const Icon(Icons.cancel),
                    onTap: () {
                      loginEmail.text = "";
                      setState(() {});
                    },
                  ),
                  hintText: 'Type Email Here',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          width: 3, style: BorderStyle.solid))),
            ),
          ),
          SizedBox(
            height: DeviceDimensions(context).height / 70,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: loginPwd,
              obscureText: obscure,
              obscuringCharacter: "•",
              // style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.password),
                  suffixIcon: GestureDetector(
                    child: obscure
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onTap: () {
                      obscure = !obscure;
                      setState(() {});
                    },
                  ),
                  hintText: 'Type Password Here',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          width: 3, style: BorderStyle.solid))),
            ),
          ),
          SizedBox(
            height: DeviceDimensions(context).height / 8.5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                child: Text("Login",
                    style: GoogleFonts.laila(
                        textStyle: const TextStyle(
                            color: Colors.black, fontSize: 20))),
                onPressed: () {
                  _doLogin();
                },
                elevation: 2,
                minWidth: 150,
                height: 60,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                color: Colors.cyanAccent,
              )
            ],
          ),
          SizedBox(
            height: DeviceDimensions(context).height / 8.8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _getText("Don't have an account yet?", 16, FontWeight.bold),
              TextButton(
                  child: _getText('Sign up now!', 16, FontWeight.bold,
                      color: Colors.red),
                  onPressed: () {
                    _index = 1;
                    _loadPages()[_index];
                    setState(() {});
                  })
            ],
          )
        ],
      ),
    );
  }

  TextEditingController regEmail = TextEditingController();
  TextEditingController regPwd = TextEditingController();
  _showRegister() {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(padding: EdgeInsets.only(left: 10)),
            GestureDetector(
              child: const Icon(Icons.arrow_back),
              onTap: () {
                _index = 0;
                _loadPages()[_index];
                setState(() {});
              },
            ),
          ],
        ),
        SizedBox(
          height: DeviceDimensions(context).height / 10,
        ),
        _getText('Create Account', 40, FontWeight.bold),
        SizedBox(
          height: DeviceDimensions(context).height / 10,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: regEmail,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.email),
                suffixIcon: GestureDetector(
                  child: const Icon(Icons.cancel),
                  onTap: () {
                    loginEmail.text = "";
                    setState(() {});
                  },
                ),
                hintText: 'Type Email Here',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(width: 3, style: BorderStyle.solid))),
          ),
        ),
        SizedBox(
          height: DeviceDimensions(context).height / 70,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: regPwd,
            obscureText: obscure,
            //obscuringCharacter: "&",
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.password),
                suffixIcon: GestureDetector(
                  child: obscure
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                  onTap: () {
                    obscure = !obscure;
                    setState(() {});
                  },
                ),
                hintText: 'Type Password Here',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(width: 3, style: BorderStyle.solid))),
          ),
        ),
        SizedBox(
          height: DeviceDimensions(context).height / 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              child: Text("Register Now",
                  style: GoogleFonts.laila(
                      textStyle:
                          const TextStyle(color: Colors.black, fontSize: 20))),
              onPressed: () {
                _doRegister();
              },
              elevation: 2,
              minWidth: 150,
              height: 60,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
              color: Colors.cyanAccent,
            )
          ],
        )
      ],
    );
  }

  @override
  initState() {
    super.initState();
    _checkConnectivity();
  }

  _loadPages() {
    return [_showLogin, _showRegister];
  }

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          //color: Colors.amberAccent,
          height: DeviceDimensions(context).height,
          width: DeviceDimensions(context).width,
          child: _loadPages()[_index](),
        ),
      ),
    );
  }

  _showMessage(String msg) async {
    await Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  final UserOperations _opr = UserOperations();
  void _doRegister() async {
    String email = regEmail.text;
    String password = regPwd.text;
    try {
      String fireBaseRegEmailId = await _opr.register(email, password);
      _showMessage("Register SuccessFully $fireBaseRegEmailId");
      _index = 0;
      _loadPages()[_index];
      setState(() {});
    } catch (e) {
      _showMessage("Register Fails $e");
      print("Some Exception Generated During Reg $e");
    }
  }

  late StreamSubscription subscription;
  _checkConnectivity() {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if (result == ConnectivityResult.none) {
        _showMessage("No Internet, please check your connection.");
      } else if (result == ConnectivityResult.wifi) {
        _showMessage("Connected to wifi ");
      }
      if (result == ConnectivityResult.mobile) {
        _showMessage("Connected to mobile data ");
      }
    });
  }

  void _doLogin() async {
    try {
      String result = await _opr.login(loginEmail.text, loginPwd.text);

      if (result.isNotEmpty) {
        _showMessage("Login SuccessFully....");
        Navigator.of(context).push(MaterialPageRoute(builder: (_) {
          return const Songs();
        }));
      } else {
        _showMessage("Invalid Userid or Password");
      }
    } catch (e) {
      _showMessage("Invalid Userid or Password");
    }
  }
}
