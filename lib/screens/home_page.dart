import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wscube_expense_app/screens/add_expense_screen.dart';

import '../Screens/login_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomeScreen"),
        backgroundColor: Colors.blue,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 21),
              TextButton.icon(
                onPressed: () async {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (ctx) => LoginScreen()));
                  var prefs = await SharedPreferences.getInstance();
                  prefs.setBool(LoginScreen.LOGIN_PREFS_KEY, false);
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.blue,
                ),
                label: const Text(
                  "Log out",
                  style: TextStyle(color: Colors.blue),
                ),
              )
            ],
          ),
        ),
      ),
      /*body: ListView.builder(
          itemCount: AppConstants.mCategories.length,
          itemBuilder: (context, index) {
            var expenses = AppConstants.mCategories[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: ListTile(
                leading: Image.asset(expenses.catImgPath),
                title: Text(
                  expenses.catTitle,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                ),
                subtitle: Text(expenses.catTitle),
              ),
            );
          }),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => const AddExpense()));
        },
        child: const Icon(
          Icons.add,
          size: 35,
        ),
      ),
    );
  }
}
