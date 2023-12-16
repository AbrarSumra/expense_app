import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wscube_expense_app/exp_bloc/expense_bloc.dart';
import 'package:wscube_expense_app/exp_bloc/expense_state.dart';
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
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (_, state) {
          if (state is ExpenseLoadingState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is ExpenseErrorState) {
            return Center(
              child: Text(state.errorMsg),
            );
          }
          if (state is ExpenseLoadedState) {
            var expData = state.loadData;
            return ListView.builder(
              itemCount: expData.length,
              itemBuilder: (context, index) {
                var expenses = expData[index];
                return ListTile(
                  title: Text(expenses.expTitle),
                  subtitle: Text(expenses.expDesc),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        Image.asset(expenses.expCatType),
                        Text(expenses.expAmt),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
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
