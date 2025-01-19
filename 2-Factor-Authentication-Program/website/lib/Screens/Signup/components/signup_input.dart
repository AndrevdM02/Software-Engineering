import 'package:flutter/material.dart';

import '../../../components/already_account.dart';
import '../../../constants.dart';
import '../../Login/login_page.dart';
import '../../Welcome/welcome_page.dart';
import 'package:flutter_auth/auth_service.dart';

class SignupInput extends StatefulWidget {
  @override
  _SignupInputState createState() => _SignupInputState();
}

class _SignupInputState extends State<SignupInput> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _PasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          children: [
            TextFormField(
              key: Key("name"),
              controller: _nameController,
              textInputAction: TextInputAction.next,
              cursorColor: MainColour,
              decoration: InputDecoration(
                hintText: "Your name",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (name) {
                if (name!.isEmpty || name.length < 2)
                  return 'Invalid name.';
                else
                  return null;
              },
              onChanged: (name) {
                setState(() {});
              },
            ),
            const SizedBox(height: defaultPadding),
            TextFormField(
              key: Key("surname"),
              controller: _surnameController,
              textInputAction: TextInputAction.next,
              cursorColor: MainColour,
              decoration: InputDecoration(
                hintText: "Your surname",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.person),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (surname) {
                if (surname!.isEmpty || surname.length < 2)
                  return 'Invalid surname.';
                else
                  return null;
              },
              onChanged: (surname) {
                setState(() {});
              },
            ),
            const SizedBox(height: defaultPadding),
            TextFormField(
              key: Key("phone"),
              controller: _phoneNumberController,
              textInputAction: TextInputAction.next,
              cursorColor: MainColour,
              decoration: InputDecoration(
                hintText: "Your phone number",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.phone),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (phone) {
                if (phone!.isEmpty ||
                    !RegExp(r'(0|\+\d{1,9})\d{9}$').hasMatch(phone))
                  return 'Invalid phone number.';
                else
                  return null;
              },
              onChanged: (email) {
                setState(() {});
              },
            ),
            const SizedBox(height: defaultPadding),
            TextFormField(
              key: Key("email"),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              cursorColor: MainColour,
              decoration: InputDecoration(
                hintText: "Your email",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.mail),
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) {
                if (email!.isEmpty ||
                    !RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                        .hasMatch(email))
                  return 'Invalid email adress.';
                else
                  return null;
              },
              onChanged: (email) {
                setState(() {});
              },
            ),
            const SizedBox(height: defaultPadding),
            TextFormField(
              key: Key("password"),
              controller: _passwordController,
              textInputAction: TextInputAction.done,
              obscureText: !_PasswordVisible,
              cursorColor: MainColour,
              decoration: InputDecoration(
                hintText: "Your password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _PasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: MainColour,
                    key: Key("view1"),
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _PasswordVisible = !_PasswordVisible;
                    });
                  },
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (password) {
                if (password!.isEmpty)
                  return 'Can\'t be empty.';
                else if (!RegExp(r'.*[A-Z].*').hasMatch(password))
                  return 'Requires at least one uppercase character.';
                else if (!RegExp(r'.*[a-z].*').hasMatch(password))
                  return 'Requires at least one lowercase character.';
                else if (!RegExp(r'.*[0-9].*').hasMatch(password))
                  return 'Requires at least one digit character.';
                else if (!RegExp(r'.*[0-9].*').hasMatch(password))
                  return 'Requires at least one special character.';
                else if (!RegExp(
                        r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*#?&]{8,}$')
                    .hasMatch(password)) return 'Must be at least 8 characters';
                return null;
              },
              onChanged: (password) {
                setState(() {});
              },
            ),
            const SizedBox(height: defaultPadding),
            TextFormField(
              key: Key("confirm"),
              textInputAction: TextInputAction.done,
              obscureText: !_PasswordVisible,
              cursorColor: MainColour,
              decoration: InputDecoration(
                hintText: "Confirm password",
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Icon(Icons.lock),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    // Based on passwordVisible state choose the icon
                    _PasswordVisible ? Icons.visibility : Icons.visibility_off,
                    color: MainColour,
                    key: Key("view2"),
                  ),
                  onPressed: () {
                    // Update the state i.e. toogle the state of passwordVisible variable
                    setState(() {
                      _PasswordVisible = !_PasswordVisible;
                    });
                  },
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (password) {
                if (password != _passwordController.text) {
                  return 'Password mismatch';
                }
                return null;
              },
              onChanged: (password) {
                setState(() {});
              },
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              key: Key("signup"),
              onPressed: () async {
                final String name = _nameController.text;
                final String surname = _surnameController.text;
                final String phoneNumber = _phoneNumberController.text;
                final String email = _emailController.text;
                final String password = _passwordController.text;
                dynamic result = await _auth.registerWithEmailAndPassword(
                    email, password, name, surname, phoneNumber);
                if (result == null) {
                  // Handle the error (e.g., show a Snackbar with an error message)
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Registration failed.'),
                    ),
                  );
                } else {
                  // Handle the success (e.g., navigate to the home screen)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return WelcomePage();
                      },
                    ),
                  );
                }
              },
              child: Text(
                "SIGN UP",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: MainColour),
            ),
            const SizedBox(height: defaultPadding),
            ElevatedButton(
              key: Key("back"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return WelcomePage();
                    },
                  ),
                );
              },
              child: Text(
                "BACK",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(backgroundColor: MainColour),
            ),
            const SizedBox(height: defaultPadding),
            AlreadyHaveAnAccountCheck(
              key: Key("signin"),
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginPage();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
