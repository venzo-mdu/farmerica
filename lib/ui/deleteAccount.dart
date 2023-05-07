import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Farmerica/models/Customers.dart';
import 'package:Farmerica/networks/ApiServices.dart';
import 'package:Farmerica/ui/Welcome.dart';
import 'package:Farmerica/utils/sharedServices.dart';

class DeleteAccount extends StatefulWidget {
  Customers customers;
  DeleteAccount({this.customers});

  @override
  _DeleteAccountState createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  SharedServices sharedServices = SharedServices();
  Api_Services api_services = Api_Services();

  @override
  Widget build(BuildContext context) {
    // print(widget.customers.id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff00AA55),
      ),
      body: SingleChildScrollView(
        child: ListTile(
          title: Text("Delete Account"),
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Farmerica App"),
                    content: Text("Are you sure to delete the account??"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("No")),
                      TextButton(
                          onPressed: () async {
                            api_services.deleteAccount(75).then(
                              (value) {
                                sharedServices.logOut();
                                Fluttertoast.showToast(
                                    msg:
                                        "Account has been Successfully deleted",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WelcomePage()));
                              },
                            );
                          },
                          child: Text("Yes"))
                    ],
                  );
                });
          },
        ),
      ),
    );
  }
}
