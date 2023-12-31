import 'package:flutter/material.dart';
import 'package:simple_suppers/api_service.dart';
import 'package:simple_suppers/components/recipe_preview.dart';
import 'package:simple_suppers/models/recipe.dart';
import 'package:simple_suppers/screens/recipe_details.dart';
import 'package:simple_suppers/screens/register.dart';

class Login extends StatefulWidget {
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _password;
  Login({super.key, required String title});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<bool> _checkLoginStatus() async {
    return AuthService().isLoggedIn();
  }

  Future<String?> _getUsername() async {
    return AuthService().getUsername();
  }

  Future<List<Recipe>> userRecipes() async {
    return await fetchUserRecipes(AuthService().getId()!);
  }

  Widget LoggedIn() {
    return SingleChildScrollView(
      // Account icon/picture and username
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.account_circle,
                  size: 124.0,
                  color: Colors.grey[350],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0, left: 5.0),
                  child: Text(
                    AuthService().getUsername()!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Add any additional content for the logged-in state.
          ElevatedButton(
            onPressed: () async {
              // Trigger the logout function when the button is pressed.
              await AuthService().logout();

              //rerenders the screen, important!
              setState(() {});
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.red, // Customize button color
              minimumSize: const Size(150, 45),
            ),
            child: const Text('LOGOUT'),
          ),
          const SizedBox(height: 20),

          // Display the number of recipes the user has
          FutureBuilder(
              future: userRecipes(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  String recipeCount = snapshot.data!.length.toString();
                  return (Text(
                    '$recipeCount recipes',
                    style: TextStyle(
                      color: Colors.amber[900],
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ));
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              }),
          // User recieps
          FutureBuilder(
            future: userRecipes(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: List.generate(
                    snapshot.data!.length,
                    (index) => RecipePreview(
                      title: snapshot.data![index].title,
                      difficultyLevel: snapshot.data![index].difficulty,
                      time: snapshot.data![index].time,
                      shortDescription: snapshot.data![index].shortDescription,
                      imageLink: snapshot.data![index].imageLink,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetails(
                              // title: snapshot.data![index].title,
                              recipeId: snapshot.data![index].id,
                            ),
                          ),
                        ).then((value) => setState(() {}));
                      },
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }

  Widget LoginForm() {
    return Form(
      key: widget._formKey,
      child: Column(
        children: <Widget>[
          Container(
              padding: const EdgeInsets.only(left: 15),
              alignment: Alignment.bottomLeft,
              child: const Text(
                "Username",
                style: TextStyle(fontSize: 18, color: Colors.white),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
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
                    borderSide: const BorderSide(color: Colors.white)),
              ),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
              onSaved: (value) {
                widget._username = value;
              },
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
            child: TextFormField(
              style: const TextStyle(color: Colors.white),
              obscureText: true,
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
                      borderSide: const BorderSide(color: Colors.white))),
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              onSaved: (value) {
                widget._password = value;
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20, left: 15),
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Register()),
                );
              },
              child: const Text(
                'Register new account',
                style: TextStyle(
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 55),
            child: ElevatedButton(
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.
                if (widget._formKey.currentState!.validate()) {
                  widget._formKey.currentState!.save();

                  await AuthService()
                      .login(widget._username!, widget._password!);

                  //rerenders the screen, important!
                  setState(() {});
                }
              },
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(255, 85, 63, 183),
                  minimumSize: const Size(150, 45)),
              child: const Text('LOGIN'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      // Use your authentication service or method to check if the user is logged in.
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the user is logged in, show a different widget.
          if (snapshot.data == true) {
            return FutureBuilder<String?>(
              // Use your authentication service or method to get the username.
              future: _getUsername(),
              builder: (context, usernameSnapshot) {
                if (usernameSnapshot.connectionState == ConnectionState.done) {
                  return LoggedIn();
                } else {
                  return const CircularProgressIndicator();
                }
              },
            );
          } else {
            // If the user is not logged in, show the login form.
            return SafeArea(
                child: Scaffold(
                    backgroundColor: Colors.amber[900],
                    body: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 50.0),
                          child: const Text(
                            'Login To Account',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                            padding: const EdgeInsets.only(
                                left: 15, top: 60, right: 15),
                            child: LoginForm()),
                      ],
                    )));
          }
        } else {
          // Show a loading indicator while checking the login status.
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
