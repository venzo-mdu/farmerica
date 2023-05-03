import 'package:farmerica/ui/verifyAddress.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:farmerica/models/CartRequest.dart';
import 'package:farmerica/models/Customers.dart';
import 'package:farmerica/networks/ApiServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:string_validator/string_validator.dart';

class CreateOrder extends StatefulWidget {
  List<CartProducts> cartProducts;
  var couponSelection;
  List product = [];
  final int id;
  var shippingFee;
  var details;
  CreateOrder({this.cartProducts, this.product, this.id, this.shippingFee, this.details, this.couponSelection});
  @override
  _CreateOrderState createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  final _formKey = GlobalKey<FormState>();
  Customers details;
  String first, last, city, state = 'Odisha', postcode, apartmnt, flat, address, country = 'India', mobile, mail, giftFrom, giftMsg;
  int selected = 2;
  String title = "Create Order";
  String dropDownValue;
  // BasePage basePage = BasePage();
  DateTime intialdate = DateTime.now();
  DateTime selectedDate;
  bool isCurrentDaySelected = false;

  String firstName;
  String lastName;
  String emailId;
  String phoneNumber;

  String address1;
  String address2;
  String townCity;
  String pinsCode;

  Customers customer;

  getPinCode() async {
    SharedPreferences pinCodePrefs = await SharedPreferences.getInstance();
    setState(() {
      pinsCode = pinCodePrefs.getString('pinCode') ?? '';
    });
  }

  Api_Services api_services = Api_Services();

  Future<Customers> getUser() async {
    SharedPreferences userPrefs = await SharedPreferences.getInstance();
    String email = userPrefs.getString('email');
    Customers fetchedCustomer = await api_services.getCustomersByMail(email);
    setState(() {
      customer = fetchedCustomer;
    });
  }

  List<String> timeDropDownValuesT = [
    '08:00 AM - 01:00 PM',
    '01:00 PM - 06:00 PM',
    '06:00 PM - 09:00 PM',
  ];
  List<String> timeDropDownValues = [];
  bool showTime = true;
  bool dateVisible = false;

  @override
  void initState() {
    getPinCode();
    getUser();
    super.initState();
  }

  TextEditingController datePickerController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // if (userData == null) {
    //   return const Center(child: CircularProgressIndicator());
    // }

    // print(widget.product);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff00ab55),
        centerTitle: true,
        title: Image.asset(
          'assets/images/farmerica-logo.png',
          color: Colors.white,
          width: MediaQuery.of(context).size.width * 0.5,
        ),
      ),
      body: customer == null ? const Center(child: CircularProgressIndicator(color: Color(0xff00ab55))) :
      SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Delivery',
                        style: TextStyle(fontFamily: 'OutFit', fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
// Delivery Date
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Date",
                          style: TextStyle(fontFamily: 'OutFit', fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        IntrinsicWidth(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.datetime,
                              controller: datePickerController,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 10),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff00ab55),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                border: InputBorder.none,
                                suffixIcon: const Icon(
                                  Icons.date_range,
                                  size: 20,
                                  color: Color(0xff00ab55),
                                ),
                                hintText: 'Choose Delivery Date',
                                hintStyle: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                              onChanged: (value) async {},
                              validator: (value) {
                                if (value.isEmpty || value == null) {
                                  return 'Select the Date';
                                } else {
                                  return null;
                                }
                              },
                              onTap: () async {
                                print('Shipping: ${widget.shippingFee}');
                                DateTime now = DateTime.now();
                                DateTime timeLimit = DateTime(now.year, now.month, now.day, 17, 0);

                                if (widget.shippingFee == 200) {
                                  selectedDate = intialdate ?? DateTime.now();

                                  final midNightTime = DateTime(now.year, now.month, now.day, 23, 00);
                                  final currentDateTime = DateTime.now();
                                  bool changeDate = true;

                                  if (currentDateTime.isAfter(midNightTime)) {
                                    print(currentDateTime.isAfter(midNightTime));
                                    changeDate = false;
                                  }

                                  final DateTime picked = await showDatePicker(
                                    context: context,
                                    initialDate: changeDate ? selectedDate : selectedDate.add(const Duration(days: 1)),
                                    initialDatePickerMode: DatePickerMode.day,
                                    firstDate: changeDate ? selectedDate : selectedDate.add(const Duration(days: 1)),
                                    lastDate: DateTime(2101),
                                  );

                                  if (picked != null && picked != selectedDate) {
                                    selectedDate = picked;
                                    isCurrentDaySelected = selectedDate.year == DateTime.now().year &&
                                        selectedDate.month == DateTime.now().month &&
                                        selectedDate.day == DateTime.now().day;
                                    if (isCurrentDaySelected == true) {
                                      print(DateTime.now());

                                      if (intialdate.isAfter(timeLimit)) {
                                        Fluttertoast.showToast(
                                            msg: "Please order before 5PM to deliver the product in same day midnight. Kindly change the date.",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 3,
                                            backgroundColor: Color(0xff00ab55),
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    }
                                  }
                                  if (picked != null) {
                                    setState(() {
                                      datePickerController.text = DateFormat.yMd().format(picked);
                                    });
                                  }
                                } else if (widget.shippingFee == 75) {
                                  final earlyTime = DateTime(now.year, now.month, now.day, 06, 30);
                                  final currentDateTime = DateTime.now();
                                  bool changeDate = true;

                                  if (currentDateTime.isAfter(earlyTime)) {
                                    print(currentDateTime.isAfter(earlyTime));
                                    changeDate = false;
                                  }

                                  selectedDate = intialdate ?? DateTime.now();
                                  final DateTime picked = await showDatePicker(
                                      context: context,
                                      initialDate: changeDate ? selectedDate : selectedDate.add(const Duration(days: 1)),
                                      initialDatePickerMode: DatePickerMode.day,
                                      firstDate: changeDate ? selectedDate : selectedDate.add(const Duration(days: 1)),
                                      lastDate: DateTime(2101),
                                      builder: (context, child) => Theme(
                                        data: ThemeData().copyWith(
                                            colorScheme: const ColorScheme.dark(
                                              primary: Color(0xff00ab55),
                                              onPrimary: Colors.white,
                                              surface: Color(0xff00ab55),
                                              onSurface: Colors.white,
                                            )),
                                        child: child,
                                      ));

                                  if (picked != null && picked != selectedDate) {
                                    selectedDate = picked;
                                    isCurrentDaySelected = selectedDate.year == DateTime.now().year &&
                                        selectedDate.month == DateTime.now().month &&
                                        selectedDate.day == DateTime.now().day;
                                    if (isCurrentDaySelected == true) {
                                      print(DateTime.now());
                                      DateTime timeLimit = DateTime(now.year, now.month, now.day, 17, 0);
                                      if (intialdate.isAfter(timeLimit)) {
                                        Fluttertoast.showToast(
                                            msg: "Early morning delivery is not available for today. Kindly change the date",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.BOTTOM,
                                            timeInSecForIosWeb: 3,
                                            backgroundColor: Color(0xff00ab55),
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                      }
                                    }
                                  }
                                  if (picked != null) {
                                    setState(() {
                                      datePickerController.text = DateFormat.yMd().format(picked);
                                    });
                                  }
                                } else if (widget.shippingFee == 0) {
                                  final freeTime = DateTime(now.year, now.month, now.day, 24, 00);
                                  final currentDateTime = DateTime.now();
                                  bool changeDate = true;

                                  print('DateTime: ${currentDateTime.isAfter(freeTime)}');
                                  print('Initial Date: $currentDateTime');


                                  if (currentDateTime.isAfter(freeTime)) {
                                    changeDate = false;
                                  }

                                  DateTime picked = await showDatePicker(
                                    context: context,
                                    initialDate: currentDateTime,
                                    initialDatePickerMode: DatePickerMode.day,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2101),
                                  );
                                  // String datetime = DateFormat('H').format(DateTime.now());
                                  print('objectPicked: ${picked}');

                                  DateTime timeLimit13 = DateTime(now.year, now.month, now.day, 13, 0);
                                  DateTime timeLimit08 = DateTime(now.year, now.month, now.day, 08, 0);
                                  DateTime timeLimit18 = DateTime(now.year, now.month, now.day, 18, 0);

                                  DateTime timeLimit21 = DateTime(now.year, now.month, now.day, 21, 0);
                                  final today = DateTime(now.year, now.month, now.day);
                                  final pickedDay = DateTime(picked.year, picked.month, picked.day);

                                  print('Test: ${intialdate.isAfter(timeLimit08) && pickedDay == today}');


                                  timeDropDownValues = List.from(timeDropDownValuesT);
                                  if (intialdate.isAfter(timeLimit08) && pickedDay == today) {
                                    timeDropDownValues.remove('08:00 AM - 01:00 PM');
                                  }
                                  if (intialdate.isAfter(timeLimit13) && pickedDay == today) {
                                    timeDropDownValues.remove('01:00 PM - 06:00 PM');
                                  }
                                  if (intialdate.isAfter(timeLimit18) && pickedDay == today) {
                                    timeDropDownValues.remove('06:00 PM - 09:00 PM');
                                  }
                                  if (intialdate.isAfter(timeLimit21) && pickedDay == today) {
                                    showTime = false;
                                    setState(() {});
                                    Fluttertoast.showToast(
                                      msg: "Free delivery for the day is closed.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 5,
                                      backgroundColor: Color(0xff00ab55),
                                      textColor: Colors.white,
                                      fontSize: 16.0,
                                    );
                                  } else if (pickedDay == today.add(Duration(days: 1))) {
                                    showTime = true;
                                  }
                                  if (picked != null) {
                                    setState(() {
                                      datePickerController.text = DateFormat.yMd().format(picked);
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
// Delivery Time
                    widget.shippingFee == 0 && datePickerController.text.isNotEmpty
                        ? (showTime
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Time',
                          style: TextStyle(fontFamily: 'OutFit', fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5.0),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          width: MediaQuery.of(context).size.width / 1.7,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: dropDownValue,
                              items: timeDropDownValues.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      value,
                                      style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (onChangedValue) {
                                setState(() {
                                  dropDownValue = onChangedValue;
                                });
                              },
                            ),
                          ),
                        )
                      ],
                    )
                        : Container())
                        : Container(),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.grey.shade400,
                      indent: 100,
                      endIndent: 100,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Center(
                      child: Text(
                        'Contact',
                        style: TextStyle(fontFamily: 'OutFit', fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

//First Name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'First Name',
                          style: TextStyle(fontFamily: 'OutFit', fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.7,
                          child: TextFormField(
                            // controller: firstNameController,
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                            initialValue: customer.firstName,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 10),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff00ab55),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              border: InputBorder.none,
                              suffixIcon: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Color(0xff00ab55),
                              ),
                              hintText: 'First Name',
                              hintStyle: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            onChanged: (String value) {
                              // updateCustomerData('firstName', value);
                              setState(() {
                                firstName = value;
                              });
                              // print(first);
                            },
                            validator: (value) {
                              bool valid = isAlpha(value);
                              if (valid) {
                                return null;
                              } else if (value == null || value.isEmpty) {
                                return '*Fill the Field';
                              } else {
                                return "*Fill the Field";
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
//Last Name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Last Name',
                          style: TextStyle(fontFamily: 'OutFit', fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.7,
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                            initialValue: customer.lastName,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 10),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff00ab55),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              border: InputBorder.none,
                              suffixIcon: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Color(0xff00ab55),
                              ),
                              hintText: 'Last Name',
                              hintStyle: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            onChanged: (String value) {
                              lastName = value;
                              print(first);
                            },
                            validator: (value) {
                              bool valid = isAlpha(value);
                              if (valid) {
                                return null;
                              } else if (value == null || value.isEmpty) {
                                return '*Fill the Field';
                              } else {
                                return "*Fill the Field";
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
//email
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Email-Id',
                          style: TextStyle(fontFamily: 'OutFit', fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.7,
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                            initialValue: customer.email,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 10),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff00ab55),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              border: InputBorder.none,
                              suffixIcon: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Color(0xff00ab55),
                              ),
                              hintText: 'E-mail',
                              hintStyle: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                            maxLines: 1,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (String value) {
                              print(value);
                              mail = value;
                            },
                            validator: (value) {
                              bool valid = isEmail(value);
                              if (valid) {
                                return null;
                              } else if (value == null || value.isEmpty) {
                                return '*Fill the Field';
                              } else {
                                return "Enter valid Mail Id";
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
//mobile
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Mobile Number',
                          style: TextStyle(fontFamily: 'OutFit', fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.7,
                          child: TextFormField(
                            textAlignVertical: TextAlignVertical.center,
                            textAlign: TextAlign.start,
                            initialValue: customer.billing.phone,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(left: 10),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xff00ab55),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              focusedErrorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                ),
                              ),
                              border: InputBorder.none,
                              suffixIcon: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Color(0xff00ab55),
                              ),
                              hintText: 'Mobile Number',
                              hintStyle: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400),
                            ),
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            onChanged: (String value) {
                              mobile = value;
                              print(first);
                            },
                            validator: (value) {
                              bool valid = isLength(value, 10);
                              bool vali = isNumeric(value);
                              if (valid && vali) {
                                return null;
                              } else if (value == null || value.isEmpty) {
                                return '*Fill the Field';
                              } else if (vali) {
                                return "*Fill the Field.";
                              } else if (valid) {
                                return "Enter 10 digit No";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    Divider(
                      color: Colors.grey.shade400,
                      indent: 100,
                      endIndent: 100,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
//Address
                    const Center(
                      child: Text(
                        'Address',
                        style: TextStyle(fontFamily: 'OutFit', fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
//add1 & 2
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Apartment',
                          style: TextStyle(fontFamily: 'OutFit', fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        IntrinsicWidth(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.start,
                              initialValue: customer.billing.address1,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 10, top: 10),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff00ab55),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                border: InputBorder.none,
                                suffixIcon: const Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Color(0xff00ab55),
                                ),
                                hintText: 'Apartment / Flat no',
                                hintStyle: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                              maxLines: 2,
                              keyboardType: TextInputType.text,
                              onChanged: (String value) {
                                flat = value;
                                print(address);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter the Address';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Street',
                          style: TextStyle(fontFamily: 'OutFit', fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        IntrinsicWidth(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.start,
                              initialValue: customer.billing.address2,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 10, top: 10),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff00ab55),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                border: InputBorder.none,
                                suffixIcon: const Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Color(0xff00ab55),
                                ),
                                hintText: 'Street',
                                hintStyle: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                              maxLines: 2,
                              keyboardType: TextInputType.text,
                              onChanged: (String value) {
                                apartmnt = value;
                                return;
                                print(apartmnt);
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '*Fill the Field';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
//pinCode, city, state
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'PinCode',
                              style: TextStyle(fontFamily: 'OutFit', fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            IntrinsicWidth(
                              child: SizedBox(
                                child: TextFormField(
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.end,
                                  initialValue: pinsCode,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(left: 10),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xff00ab55),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    focusedErrorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    suffixIcon: const Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Color(0xff00ab55),
                                    ),
                                    hintText: 'PinCode',
                                    hintStyle: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400),
                                  ),
                                  maxLines: 1,
                                  keyboardType: TextInputType.number,
                                  onChanged: (String value) {
                                    postcode = value;
                                    print(postcode);
                                  },
                                  validator: (value) {
                                    bool valid = isNumeric(value);
                                    if (valid) {
                                      return null;
                                    } else if (value == null || value.isEmpty) {
                                      return '*Fill the Field';
                                    } else {
                                      return "Enter valid PostalCode";
                                    }
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'City',
                              style: TextStyle(fontFamily: 'OutFit', fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            IntrinsicWidth(
                              child: SizedBox(
                                child: TextFormField(
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.end,
                                  initialValue: customer.billing.city,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(left: 10),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xff00ab55),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    focusedErrorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    suffixIcon: const Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Color(0xff00ab55),
                                    ),
                                    hintText: 'City',
                                    hintStyle: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400),
                                  ),
                                  maxLines: 1,
                                  keyboardType: TextInputType.text,
                                  onChanged: (String value) {
                                    city = value;
                                  },
                                  validator: (value) {
                                    bool valid = isAlpha(value);
                                    if (valid) {
                                      return null;
                                    } else if (value == null || value.isEmpty) {
                                      return '*Fill the Field';
                                    } else {
                                      return "Enter valid City Name";
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'State',
                              style: TextStyle(fontFamily: 'OutFit', fontSize: 15, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            IntrinsicWidth(
                              child: SizedBox(
                                child: TextFormField(
                                  readOnly: true,
                                  textAlignVertical: TextAlignVertical.center,
                                  textAlign: TextAlign.end,
                                  initialValue: "Odisha",
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.only(left: 10, right: 10),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0xff00ab55),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                    errorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    focusedErrorBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.red,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    hintText: 'State',
                                    hintStyle: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400),
                                  ),
                                  maxLines: 1,
                                  keyboardType: TextInputType.text,
                                  onChanged: (String value) {
                                    state = value;
                                    print(state);
                                  },
                                  validator: (value) {
                                    bool valid = isAlpha(value);
                                    if (valid) {
                                      return null;
                                    } else if (value == null || value.isEmpty) {
                                      return '*Fill the Field';
                                    } else {
                                      return "Enter valid name";
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Divider(
                      color: Colors.grey.shade400,
                      indent: 100,
                      endIndent: 100,
                    ),
                    const SizedBox(
                      height: 10,
                    ),

//Gift
                    const Center(
                      child: Text(
                        'Gift Corner',
                        style: TextStyle(fontFamily: 'OutFit', fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
//from
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Gift From',
                          style: TextStyle(fontFamily: 'OutFit', fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        IntrinsicWidth(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.start,
                              initialValue: giftFrom,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 10, top: 10),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff00ab55),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                border: InputBorder.none,
                                suffixIcon: const Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Color(0xff00ab55),
                                ),
                                hintText: 'Gift From',
                                hintStyle: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                              maxLines: 1,
                              keyboardType: TextInputType.text,
                              onChanged: (String value) {
                                giftFrom = value;
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return '*Fill the Field';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
//message
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Gift Message',
                          style: TextStyle(fontFamily: 'OutFit', fontSize: 15, fontWeight: FontWeight.w600),
                        ),
                        IntrinsicWidth(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: TextFormField(
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.start,
                              initialValue: giftMsg,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.only(left: 10, top: 20),
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color(0xff00ab55),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedErrorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                border: InputBorder.none,
                                suffixIcon: const Icon(
                                  Icons.edit,
                                  size: 20,
                                  color: Color(0xff00ab55),
                                ),
                                hintText: 'Gift Message',
                                hintStyle: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400),
                              ),
                              maxLines: 5,
                              maxLength: 160,
                              keyboardType: TextInputType.multiline,
                              onChanged: (String value) {
                                giftMsg = value;
                                print(giftMsg.length > 160);
                              },
                              validator: (giftVal) {
                                if (giftVal == null || giftVal.isEmpty) {
                                  return '*Fill the field';
                                } else if (giftVal.length > 160) {
                                  return "Message should be less than 160 character";
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff00ab55),
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.7,
                            child: const Center(child: Text("Update", style: TextStyle(fontSize: 18)))),
                        onPressed: () {
                          print('Apt : $apartmnt');
                          if (_formKey.currentState.validate()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VerifyAddress(
                                      shippingMode: widget.shippingFee,
                                      product: widget.product,
                                      id: widget.id,
                                      first: customer.firstName,
                                      last: customer.lastName,
                                      apartmnt: customer.billing.address1,
                                      address: customer.billing.address2,
                                      state: customer.billing.state,
                                      city: customer.billing.city,
                                      country: customer.billing.country,
                                      postcode: pinsCode,
                                      cartProducts: widget.cartProducts,
                                      mobile: customer.billing.phone,
                                      mail: customer.email,
                                      deliveryDate: datePickerController.text,
                                      deliveryTime: dropDownValue,
                                      giftFrom: giftFrom,
                                      giftMsg: giftMsg,
                                      couponSelection: widget.couponSelection,
                                    )));
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}

