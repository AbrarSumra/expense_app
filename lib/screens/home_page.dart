import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wscube_expense_app/app_constant/content_constant.dart';
import 'package:wscube_expense_app/app_constant/date_utils.dart';
import 'package:wscube_expense_app/exp_bloc/expense_bloc.dart';
import 'package:wscube_expense_app/exp_bloc/expense_event.dart';
import 'package:wscube_expense_app/exp_bloc/expense_state.dart';
import 'package:wscube_expense_app/screens/add_expense_screen.dart';

import '../Screens/login_screen.dart';
import '../model/date_wise_expense_model.dart';
import '../model/expense_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<ExpenseBloc>(context).add(FetchAllExpenseEvent());
  }

  @override
  Widget build(BuildContext context) {
    var mQuery = MediaQuery.of(context);
    var mWidth = mQuery.size.width;
    var mHeight = mQuery.size.height;

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
            var dateWiseExpense = filterDateWiseExpense(state.loadData);

            return mQuery.orientation == Orientation.landscape
                ? landscapeLayout(dateWiseExpense)
                : portraitLayout(dateWiseExpense);
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

  /// Portrait Layout
  Widget portraitLayout(List<DateWiseExpenseModel> dateWiseExpense) {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your balance till now",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
                ),
                Text(
                  "0.0",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: listOfExpense(dateWiseExpense),
        ),
      ],
    );
  }

  /// Landscape Layout
  Widget landscapeLayout(List<DateWiseExpenseModel> dateWiseExpense) {
    return Row(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Your balance till now",
                  style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),
                ),
                Text(
                  "0.0",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: listOfExpense(dateWiseExpense),
        ),
      ],
    );
  }

  /// List of Expense
  Widget listOfExpense(List<DateWiseExpenseModel> dateWiseExpense) {
    return ListView.builder(
      itemCount: dateWiseExpense.length,
      itemBuilder: (ctx, parentIndex) {
        var eachItem = dateWiseExpense[parentIndex];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
              child: Container(
                color: Colors.grey.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      eachItem.date,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                    Text(
                      eachItem.totalAmount,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
              itemCount: eachItem.allTransaction.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, childIndex) {
                var eachTrans = eachItem.allTransaction[childIndex];

                return Container(
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade200,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Dismissible(
                    key: Key(eachItem.date),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      BlocProvider.of<ExpenseBloc>(context)
                          .add(DeleteExpenseEvent(id: eachTrans.expId));
                    },
                    background: Container(
                      alignment: AlignmentDirectional.centerEnd,
                      color: Colors.red,
                      child: const Center(
                        child: Icon(Icons.delete_forever),
                      ),
                    ),
                    child: ListTile(
                      /*onLongPress: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => AddExpense(
                                              isUpdate: true,
                                              expTitle: eachTrans.expTitle,
                                              expDesc: eachTrans.expDesc,
                                              expAmt: eachTrans.expAmt,
                                              expCatType: eachTrans.expCatType,
                                              expId: eachTrans.expId,
                                              expTimeStamp:
                                                  eachTrans.expTimeStamp,
                                              expType: eachTrans.expType,
                                            )));
                              },*/
                      leading: Image.asset(
                        AppConstants
                            .mCategories[eachTrans.expCatType].catImgPath,
                        height: 45,
                        width: 45,
                      ),
                      title: Text(
                        eachTrans.expTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      subtitle: Text(
                        eachTrans.expDesc,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      trailing: Column(
                        children: [
                          Text(
                            eachTrans.expAmt.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  /// Filtration of Date Wise Expense
  List<DateWiseExpenseModel> filterDateWiseExpense(
      List<ExpenseModel> allExpense) {
    List<DateWiseExpenseModel> dateWiseExpenses = [];

    /// This is for each Expense
    var listUniqueDate = [];

    for (ExpenseModel eachExp in allExpense) {
      var mDate = DateTimeUtils.getFormattedDateFromMilli(
          int.parse(eachExp.expTimeStamp));

      if (!listUniqueDate.contains(mDate)) {
        /// Not contains
        listUniqueDate.add(mDate);
      }
    }

    /// This is for each Date
    for (String date in listUniqueDate) {
      List<ExpenseModel> eachDateExp = [];
      var totalAmt = 0.0;

      for (ExpenseModel eachExp in allExpense) {
        var mDate = DateTimeUtils.getFormattedDateFromMilli(
            int.parse(eachExp.expTimeStamp));

        if (date == mDate) {
          eachDateExp.add(eachExp);

          if (eachExp.expType == 0) {
            /// Debit
            totalAmt -= eachExp.expAmt;
          } else {
            /// Credit
            totalAmt += eachExp.expAmt;
          }
        }
      }

      /// for Today
      var formattedTodayDate =
          DateTimeUtils.getFormattedDateFromDateTime(DateTime.now());

      if (formattedTodayDate == date) {
        date = "Today";
      }

      /// for Yesterday
      var formattedYesterdayDate = DateTimeUtils.getFormattedDateFromDateTime(
          DateTime.now().subtract(const Duration(days: 1)));

      if (formattedYesterdayDate == date) {
        date = "Yesterday";
      }

      dateWiseExpenses.add(DateWiseExpenseModel(
        date: date,
        totalAmount: totalAmt.toString(),
        allTransaction: eachDateExp,
      ));
    }

    return dateWiseExpenses;
  }
}
