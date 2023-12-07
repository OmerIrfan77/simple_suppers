import 'package:flutter/material.dart';
import 'package:simple_suppers/api_service.dart';
import 'package:simple_suppers/components/recipe_preview.dart';
import 'package:simple_suppers/main.dart';
import 'package:simple_suppers/models/recipe.dart';
import 'package:simple_suppers/screens/recipe_details.dart';

class Login extends StatelessWidget {
  Login({super.key, required String title});
  final AuthService auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      // Use your authentication service or method to check if the user is logged in.
      future: auth.isLoggedIn(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If the user is logged in, show a different widget.
          if (snapshot.data == true) {
            return FutureBuilder<String?>(
              // Use your authentication service or method to get the username.
              future: auth.getUsername(),
              builder: (context, usernameSnapshot) {
                if (usernameSnapshot.connectionState == ConnectionState.done) {
                  final loggedInUser = usernameSnapshot.data;
                  return LoggedInScreen(username: loggedInUser ?? 'Unknown');
                } else {
                  return CircularProgressIndicator();
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
                            child: const LoginForm(
                              title:
                                  'SCUBA-dive', // Not sure why this needs a title
                            )),
                      ],
                    )));
          }
        } else {
          // Show a loading indicator while checking the login status.
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class LoggedInScreen extends StatelessWidget {
  final String username;
  final int? userId;
  const LoggedInScreen({required this.username, this.userId});

  Future<List<Recipe>> userRecipes() async {
    return await fetchUserRecipes(userId!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.grey[850],
          title: Text(
            "Simple Suppers",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 100.0,
                child: Text(
                  "username is: $username, and id is: $userId",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FutureBuilder(
                future: userRecipes(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: List.generate(
                        snapshot.data!.length,
                        (index) => RecipePreview(
                          title: snapshot.data![index].title,
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Trigger the logout function when the button is pressed.
                  await AuthService().logout();
                  // Navigate back to the login screen after logging out.
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(
                        title: '',
                      ),
                    ),
                  );
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
      {super.key,
      required String title}); // Constructor, initialises the widget

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
  String? _email;
  String? _password;

  void _navigateToLoggedInScreen(
      BuildContext context, String username, int? userId) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoggedInScreen(
          username: username,
          userId: userId,
        ),
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
                "Email",
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
                  return 'Please enter your email address';
                }
                return null;
              },
              onSaved: (value) {
                _email = value;
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

                  // The login method should return a bool.
                  bool loginSuccess =
                      await AuthService().login(_email!, _password!);

                  if (loginSuccess == true) {
                    // Use the function to navigate to the LoggedInScreen.
                    // Bring username and id from login function.
                    _navigateToLoggedInScreen(context, _email ?? 'Unknown',
                        await AuthService().getId());
                  }
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
