import 'package:accountabill/data/repositories/authentication_repository.dart';
import 'package:accountabill/pages/dashboard.dart';
import 'package:accountabill/widgets/main_cta.dart';
import 'package:accountabill/widgets/page_container.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthenticationRepository _repository = AuthenticationRepository();

  Future<void> _signIn() async {
    final hasUser = await _repository.signIn(
      context,
      _emailController.text,
      _passwordController.text,
    );
    if (hasUser) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DashboardPage()),
      );
    }
  }

  Future<void> _signUp() async {
    final hasUser = await _repository.signUp(
      context,
      _emailController.text,
      _passwordController.text,
    );
    if (hasUser) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => DashboardPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasData) {
          return DashboardPage();
        } else {
          return _buildUI();
        }
      },
    );
  }

  Widget _buildUI() {
    return Scaffold(appBar: _appBar(), body: _loginScreen());
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text("Sign in"),
    );
  }

  Widget _loginScreen() {
    return PageContainer(
      child: Form(
        child: Column(
          spacing: 16,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            Column(
              children: [
                MainCTA(onPressed: _signIn, child: Text('Sign In')),
                TextButton(onPressed: _signUp, child: Text('Sign Up')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
