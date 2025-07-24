import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _logout() async {
    await _auth.signOut();
    Navigator.pop(context); // Close the dialog
    Navigator.pushReplacementNamed(context, "/login"); // Navigate to login screen
  }

  void _dismissDialog() {
    Navigator.pop(context);
  }

  void _logout_dialogbox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Log Out"),
        content: Text("Do you want to log out?"),
        actions: [
          TextButton(onPressed: _logout, child: Text("Yes")),
          TextButton(onPressed: _dismissDialog, child: Text("Cancel")),
        ],
      ),
    );
  }

  void _reset_password() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _auth.sendPasswordResetEmail(email: user.email!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password reset email sent")),
      );
    }
  }

  void _change_username() {
    TextEditingController usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Change Username"),
        content: TextField(
          controller: usernameController,
          decoration: InputDecoration(hintText: "Enter new username"),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              String newUsername = usernameController.text.trim();
              if (newUsername.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Username cannot be empty")),
                );
                return;
              }

              User? user = _auth.currentUser;
              if (user != null) {
                try {
                  // Update display name in Firebase Auth
                  await user.updateDisplayName(newUsername);

                  // Update username in Firestore
                  await _firestore.collection('users').doc(user.uid).update({
                    'username': newUsername,
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Username updated successfully")),
                  );

                  Navigator.pop(context); // Close the dialog
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error updating username: ${e.toString()}")),
                  );
                }
              }
            },
            child: Text("Save"),
          ),
          TextButton(
            onPressed: _dismissDialog,
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void _view_user_info() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(user.uid).get();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("User Info"),
          content: Text("Email: ${user.email}\nUsername: ${userDoc['username']}"),
          actions: [
            TextButton(onPressed: _dismissDialog, child: Text("OK")),
          ],
        ),
      );
    }
  }

  void _delete_account() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).delete();
      await user.delete();
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(
        appBar: AppBar(
          title: const Text("User Profile", style: TextStyle(color: Color(0xFFF5F5DC)),
          ),
          backgroundColor: Colors.purple,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child:Column(

              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(
                  height: 150
                  ,)
                ,

                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: ElevatedButton(

                      onPressed: _view_user_info,
                      child: Text(
                          "View User Info",
                          style: TextStyle(
                            fontSize: 25,
                          )
                      )
                  ),
                ),

                const SizedBox(
                  height: 50,
                  width: 600,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: ElevatedButton(
                      onPressed: _change_username,
                      child: Text(
                          "Change Username",
                          style: TextStyle(
                            fontSize: 25,
                          )
                      )
                  ),
                ),

                const SizedBox(
                  height: 50,
                  width: 600,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: ElevatedButton(
                    onPressed: _reset_password,
                    child: Text(
                        "Reset Password",
                        style: TextStyle(
                          fontSize: 25,
                        )
                    ),
                  ),
                ),

                const SizedBox(
                  height: 50,
                  width: 600,
                ),


                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: ElevatedButton(
                      onPressed: _logout_dialogbox,
                      child: Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 25,
                          )
                      )
                  ),
                ),

                const SizedBox(
                  height: 50,
                  width: 600,
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: ElevatedButton(
                    onPressed: _delete_account,
                    child: Text(
                      "Delete Account",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                ),
              ],
            )
        )
    );
  }
}