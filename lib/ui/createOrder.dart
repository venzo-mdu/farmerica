import 'package:Farmerica/ui/verifyAddress.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:Farmerica/models/CartRequest.dart';
import 'package:Farmerica/models/Customers.dart';
import 'package:Farmerica/networks/ApiServices.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
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
  // String first, last, city, state = 'Odisha', postcode, apartmnt, flat, address, country = 'India', mobile, mail, giftFrom, giftMsg;
  int selected = 2;
  String title = "Create Order";
  String dropDownValue;
  String defaultInitialTime;
  // BasePage basePage = BasePage();
  DateTime intialdate = DateTime.now();
  DateTime selectedDate;
  bool isCurrentDaySelected = false;
  OtpFieldController otpController = OtpFieldController();
  String otpValue = '';
  var customerId;
  String firstName;
  String lastName;
  String emailId;
  String phoneNumber;
  String address1;
  String address2;
  String townCity;
  String pinsCode;
  String giftFrom;
  String giftMsg;
  String country;
  bool showOTPField = false;
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
    print('customerId order page: ${fetchedCustomer.id}');
    customerId = fetchedCustomer.id;
    firstName = fetchedCustomer.firstName;
    lastName = fetchedCustomer.lastName;
    emailId = fetchedCustomer.email;
    phoneNumber = fetchedCustomer.billing.phone;
    address1 = fetchedCustomer.billing.address1;
    address2 = fetchedCustomer.billing.address2;
    townCity = fetchedCustomer.billing.city;
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
    print('id: ${widget.id}');
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
      body: customer == null
          ? const Center(child: CircularProgressIndicator(color: Color(0xff00ab55)))
          : SingleChildScrollView(
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
                                          defaultInitialTime = '11:00 PM to 12:00 AM';

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
                                            builder: (context, child) => Theme(
                                              data: ThemeData().copyWith(
                                                  colorScheme: const ColorScheme.light(
                                                    primary: Color(0xff00ab55),
                                                    onPrimary: Colors.white,
                                                    surface: Color(0xff00ab55),
                                                    onSurface: Color(0xff00ab55),

                                                  )
                                              ),
                                              child: child,
                                            ));

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
                                      } else
                                        if (widget.shippingFee == 75) {
                                        final earlyTime = DateTime(now.year, now.month, now.day, 06, 30);
                                        final currentDateTime = DateTime.now();
                                        bool changeDate = true;
                                        defaultInitialTime = '06:30 AM to 07:00 AM';
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
                                                      colorScheme: const ColorScheme.light(
                                                    primary: Color(0xff00ab55),
                                                    onPrimary: Colors.white,
                                                    surface: Color(0xff00ab55),
                                                    onSurface: Color(0xff00ab55),

                                                  )
                                                  ),
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
                                      } else
                                        if (widget.shippingFee == 0) {
                                        final freeTime = DateTime(now.year, now.month, now.day, 24, 00);
                                        print('Freetime: $freeTime');
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
                                            builder: (context, child) => Theme(
                                              data: ThemeData().copyWith(
                                                  colorScheme: const ColorScheme.light(
                                                    primary: Color(0xff00ab55),
                                                    onPrimary: Colors.white,
                                                    surface: Color(0xff00ab55),
                                                    onSurface: Color(0xff00ab55),

                                                  )
                                              ),
                                              child: child,
                                            ));
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
                                          setState(() {
                                          });
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
                          widget.shippingFee == 0 &&
                              datePickerController.text.isNotEmpty
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
                                                      style: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400),
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

                          (widget.shippingFee == 75 || widget.shippingFee == 200) &&
                              datePickerController.text.isNotEmpty ?
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Time',
                                    style: TextStyle(fontFamily: 'OutFit', fontSize: 15, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width / 1.7,
                                    child: TextFormField(
                                      readOnly: true,
                                      textAlignVertical: TextAlignVertical.center,
                                      textAlign: TextAlign.start,
                                      initialValue: defaultInitialTime,
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
                                          Icons.timer,
                                          size: 20,
                                          color: Color(0xff00ab55),
                                        ),
                                        hintText: defaultInitialTime,
                                        hintStyle: const TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w400),
                                      ),
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ) : Container(),

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
                                  initialValue: firstName,
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
                                  initialValue: lastName,
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
                                  initialValue: emailId,
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
                                    emailId = value;
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
                                  initialValue: phoneNumber,
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
                                    phoneNumber = value;
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
                                    initialValue: address1,
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
                                      address1 = value;
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
                                    initialValue: address2,
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
                                      address2 = value;
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
                                          pinsCode = value;
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
                                        initialValue: townCity,
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
                                          townCity = value;
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
                                        // onChanged: (String value) {
                                        //   state = value;
                                        //   print(state);
                                        // },
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
                                if (_formKey.currentState.validate()) {
                                  // if (customer.billing.phone.isEmpty || customer.billing.phone != phoneNumber) {
                                  //   {
                                  //     showDialog(
                                  //       context: context,
                                  //       builder: (BuildContext context) {
                                  //         return StatefulBuilder(builder: (context, setState) {
                                  //           return AlertDialog(
                                  //             title: const Text('Mobile Number Verification'),
                                  //             content: Column(
                                  //               mainAxisSize: MainAxisSize.min,
                                  //               children: [
                                  //                 if (!showOTPField)
                                  //                   const Text(
                                  //                       'You have changed the Mobile Number. Please click verify button to verify the mobile number.'),
                                  //                 if (showOTPField)
                                  //                   Column(
                                  //                     children: [
                                  //                       const SizedBox(height: 16),
                                  //                       const Text('Please enter the OTP sent to your mobile number'),
                                  //                       OTPTextField(
                                  //                         controller: otpController,
                                  //                         otpFieldStyle: OtpFieldStyle(
                                  //                             borderColor: const Color(0xffB0B0B0), focusBorderColor: const Color(0xff00ab55)),
                                  //                         length: 4,
                                  //                         width: MediaQuery.of(context).size.width,
                                  //                         fieldWidth: MediaQuery.of(context).size.width * 0.1,
                                  //                         style: const TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.w500),
                                  //                         textFieldAlignment: MainAxisAlignment.spaceAround,
                                  //                         fieldStyle: FieldStyle.underline,
                                  //                         keyboardType: TextInputType.number,
                                  //                         onChanged: (pin) {
                                  //                           print("CHanged: " + pin);
                                  //                         },
                                  //                         onCompleted: (pin) {
                                  //                           setState(() {
                                  //                             otpValue = pin;
                                  //                           });
                                  //                           print("Completed: " + pin);
                                  //                         },
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //               ],
                                  //             ),
                                  //             actions: [
                                  //               if (!showOTPField)
                                  //                 TextButton(
                                  //                   onPressed: () {
                                  //                     setState(() {
                                  //                       showOTPField = true;
                                  //                     });
                                  //                   },
                                  //                   child: Text('Sent OTP'),
                                  //                 ),
                                  //               if (showOTPField)
                                  //                 TextButton(
                                  //                   onPressed: () {
                                  //                     // Perform OTP verification here
                                  //                     Navigator.of(context).pop();
                                  //                   },
                                  //                   child: Text('Verify OTP'),
                                  //                 ),
                                  //               if (showOTPField)
                                  //                 TextButton(
                                  //                   onPressed: () {
                                  //                     // Navigator.of(context).pop();
                                  //                     // setState(() {
                                  //                     //   showOTPField = false;
                                  //                     // });
                                  //                   },
                                  //                   child: Text('Resent OTP'),
                                  //                 ),
                                  //               TextButton(
                                  //                 onPressed: () {
                                  //                   Navigator.of(context).pop();
                                  //                   setState(() {
                                  //                     showOTPField = false;
                                  //                   });
                                  //                 },
                                  //                 child: Text('Cancel'),
                                  //               ),
                                  //             ],
                                  //           );
                                  //         });
                                  //       },
                                  //     );
                                  //   }
                                  // } else {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => VerifyAddress(
                                                customerId: customerId,
                                                shippingMode: widget.shippingFee,
                                                product: widget.product,
                                                id: widget.id,
                                                first: firstName,
                                                last: lastName,
                                                apartmnt: address1,
                                                address: address2,
                                                state: customer.billing.state,
                                                city: townCity,
                                                country: customer.billing.country,
                                                postcode: pinsCode,
                                                cartProducts: widget.cartProducts,
                                                mobile: phoneNumber,
                                                mail: emailId,
                                                deliveryDate: datePickerController.text,
                                                deliveryTime: dropDownValue ?? defaultInitialTime,
                                                giftFrom: giftFrom,
                                                giftMsg: giftMsg,
                                                couponSelection: widget.couponSelection,
                                              )));
                                  // }
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
