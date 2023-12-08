import 'package:flutter/material.dart';
import 'package:simple_suppers/api_service.dart';
import 'package:simple_suppers/components/recipe_preview.dart';
import 'package:simple_suppers/models/recipe.dart';
import 'package:simple_suppers/screens/recipe_details.dart';


class Login extends StatelessWidget {
  const Login({super.key, required String title});

  Future<bool> _checkLoginStatus() async {
    return AuthService().isLoggedIn();
  }

  Future<String?> _getUsername() async {
    return AuthService().getUsername();
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
                  return const LoggedInScreen();
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
                            'SimpleSuppers',
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
                            child: const LoginForm()),
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

class LoggedInScreen extends StatelessWidget {
  const LoggedInScreen({super.key});

  Future<List<Recipe>> userRecipes() async {
    return await fetchUserRecipes(AuthService().getId()!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 249, 240),
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          title: const Text(
            "Simple Suppers",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
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
                          shortDescription:
                              snapshot.data![index].shortDescription,
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
                            );
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
              // Add any additional content for the logged-in state.
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Trigger the logout function when the button is pressed.
                  await AuthService().logout().then((value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Login(title: ''),
                        ),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.red, // Customize button color
                  minimumSize: const Size(150, 45),
                ),
                child: const Text('LOGOUT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// This logic of this part is created with code from
// flutter.dev article: "Build a form with validation",
// https://docs.flutter.dev/cookbook/forms/validation

// Define a custom Form widget.
class LoginForm extends StatefulWidget {
  const LoginForm(
      {super.key}); // Constructor, initialises the widget

  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class LoginFormState extends State<LoginForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();
  String? _username;
  String? _password;

  void _navigateToLoggedInScreen(
      BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LoggedInScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
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
                _username = value;
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
                _password = value;
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 15),
            alignment: Alignment.topLeft,
            child: const Text(
              'Forgot your password?',
              style: TextStyle(fontSize: 10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 75),
            child: ElevatedButton(
              onPressed: () async {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  await AuthService()
                      .login(_username!, _password!)
                      .then((value) async {
                    if (value == true) {
                      _navigateToLoggedInScreen(context);
                    }
                  });
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
}
