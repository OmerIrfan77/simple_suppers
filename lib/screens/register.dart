import 'package:flutter/material.dart';
import 'package:simple_suppers/api_service.dart';

class Register extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Validation function could use some improvment...
  bool isFormValid() {
    return usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        passwordController.text == confirmPasswordController.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          leading: const BackButton(
            color: Colors.white,
          ),
          title: const Text(
            'SimpleSuppers',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.amber[900],
            body: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 50.0),
                  child: const Text(
                    'Register New Account',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 15, top: 60, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: const EdgeInsets.only(left: 15),
                          alignment: Alignment.bottomLeft,
                          child: const Text(
                            "Username",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: usernameController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(15),
                            fillColor: Colors.grey[850],
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            errorStyle: const TextStyle(color: Colors.white),
                            errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    const BorderSide(color: Colors.white)),
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 15),
                          alignment: Alignment.bottomLeft,
                          child: const Text(
                            "Password",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              fillColor: Colors.grey[850],
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              errorStyle: const TextStyle(color: Colors.white),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                      const BorderSide(color: Colors.white))),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          obscureText: true,
                        ),
                      ),
                      Container(
                          padding: const EdgeInsets.only(left: 15),
                          alignment: Alignment.bottomLeft,
                          child: const Text(
                            "Confirm Password",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: confirmPasswordController,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(15),
                              fillColor: Colors.grey[850],
                              filled: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              errorStyle: const TextStyle(color: Colors.white),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                      const BorderSide(color: Colors.white))),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          obscureText: true,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () async {
                          if (isFormValid()) {
                            // TODO: Implement registration logic
                            await AuthService().register(
                                usernameController.text,
                                passwordController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "New user registered! Enter your credentials to login.")));
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Something went wrong. Reenter your username and password and try again.")));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                const Color.fromARGB(255, 85, 63, 183),
                            minimumSize: const Size(150, 45)),
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
