import 'package:flutter/material.dart';
import 'package:farmerica/models/Order.dart' as o;
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/ui/BasePage.dart';
import 'package:farmerica/ui/SuccessSplash.dart';
import 'package:farmerica/ui/dashboard.dart';
import 'package:farmerica/ui/homepage.dart';
import 'package:farmerica/ui/productDetails.dart';

import 'package:farmerica/ui/widgets/checkout_widget.dart';

class CheckoutScreen extends BasePage {
  o.Orders state;
  List<Product> product;
  CheckoutScreen({this.state, this.product});
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends BasePageState<CheckoutScreen> {
  @override
  Widget body(BuildContext context) {
    // print(widget.product);
    return MaterialApp(
        theme: OpenFlutterEcommerceTheme.of(context),
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: Scaffold(
              // background: null,
              // title: 'Checkout',
              body: CheckoutWrapper(
            state: widget.state,
            product: widget.product,
          )),
        ));
  }
}

class CheckoutWrapper extends BasePage {
  o.Orders state;
  List product = [];
  CheckoutWrapper({this.state, this.product});
  @override
  _CheckoutWrapperState createState() => _CheckoutWrapperState();
}

class _CheckoutWrapperState extends BasePageState<CheckoutWrapper> {
  // BasePage basePage = BasePage();
  PageView getPageView(List widgets) {
    return PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _viewController,
        children: widgets);
  }

  //State createState() => OpenFlutterWrapperState();
  PageController _viewController;
  void changePage({ViewChangeType changeType, int index}) {
    switch (changeType) {
      case ViewChangeType.Forward:
        _viewController.nextPage(
            duration: Duration(milliseconds: 300), curve: Curves.elasticIn);
        break;
      case ViewChangeType.Backward:
        _viewController.previousPage(
            duration: Duration(milliseconds: 300), curve: Curves.elasticIn);
        break;
      case ViewChangeType.Start:
        _viewController.jumpToPage(0);
        break;
      case ViewChangeType.Exact:
        _viewController.jumpToPage(index);
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    print('Wrapper: ${widget.product}');


  }

  int selected = 2;
  String title = "Order ";
  @override
  Widget body(BuildContext context) {
    print("as+${widget.product}");
    return SafeArea(
        child: Scaffold(
            // background: null,
            // title: 'Checkout',
            body: getPageView(<Widget>[
              CartView(
                  changeView: changePage, state: widget.state, product: widget.product),
              PaymentMethodView(changeView: changePage, state: widget.state),
              ShippingAddressView(changeView: changePage),
              AddShippingAddressView(changeView: changePage),
              Success1View(changeView: changePage, state: widget.state),
              Success2View(changeView: changePage, state: widget.state),
            ])));
  }
}

class PaymentMethodView extends StatefulWidget {
  final Function changeView;
  final o.Orders state;

  const PaymentMethodView({Key key, this.changeView, this.state})
      : super(key: key);

  @override
  _PaymentMethodViewState createState() => _PaymentMethodViewState();
}

class _PaymentMethodViewState extends State<PaymentMethodView> {
  int paymentCardIndex = 0;

  TextEditingController _nameOnCardController;
  TextEditingController _cardNumberController;
  TextEditingController _expirationDateController;
  TextEditingController _cvvController;

  @override
  void initState() {
    _nameOnCardController = TextEditingController();
    _cardNumberController = TextEditingController();
    _expirationDateController = TextEditingController();
    _cvvController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _nameOnCardController?.dispose();
    _cardNumberController?.dispose();
    _expirationDateController?.dispose();
    _cvvController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
        child: Stack(children: <Widget>[
      Container(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.sidePadding),
          child: Column(children: <Widget>[
            OpenFlutterBlockSubtitle(width: width, title: 'Your payment cards'),
            OpenFlutterPaymentCardPreview(
              width: width,
              cardNumber: '**** **** **** 3947',
              cardHolderName: 'Jennyfer Doe',
              expirationMonth: 5,
              expirationYear: 23,
            ),
            OpenFlutterCheckbox(
                width: width,
                title: 'Use as default payment method',
                checked: true,
                onTap: ((bool newValue) => {
                      //_changeDefaultPaymentCard(bloc, 1)
                    })),
            OpenFlutterPaymentCardPreview(
                width: width,
                cardNumber: '**** **** **** 4546',
                cardHolderName: 'Jennyfer Doe',
                expirationMonth: 11,
                expirationYear: 22,
                cardType: CardType.Visa),
            OpenFlutterCheckbox(
              width: width,
              title: 'Use as default payment method',
              checked: false,
              onTap: (bol) {},
              //  {_changeDefaultPaymentCard(bloc, 2)}
            ),
            Positioned(
              bottom: AppSizes.sidePadding,
              right: AppSizes.sidePadding,
              child: FloatingActionButton(
                  mini: true,
                  backgroundColor: _theme.primaryColor,
                  onPressed: () {},
                  child: Icon(Icons.add, size: 36)),
            ),
            OpenFlutterBottomPopup(
              title: 'Add new card',
              //height: 550,
              child: Column(
                children: <Widget>[
                  OpenFlutterInputField(
                    controller: _nameOnCardController,
                    hint: 'Name on card',
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
                  ),
                  OpenFlutterInputField(
                    controller: _cardNumberController,
                    hint: 'Card number',
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
                  ),
                  OpenFlutterInputField(
                    controller: _expirationDateController,
                    hint: 'Expiration Date',
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
                  ),
                  OpenFlutterInputField(
                    controller: _cvvController,
                    hint: 'CVV',
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
                  ),
                  OpenFlutterCheckbox(
                      width: width,
                      title: 'Use as default payment method',
                      checked: false,
                      onTap: ((bool newValue) => {
                            //_changeDefaultPaymentCard(bloc, 3)
                          })),
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
                  ),
                  OpenFlutterButton(
                    title: 'ADD CARD',
                    onPressed: (() => {}),
                  )
                ],
              ),
            )
          ]))
    ]));
  }
}

class Success2View extends StatefulWidget {
  final Function changeView;
  final o.Orders state;

  const Success2View({Key key, this.changeView, this.state}) : super(key: key);

  @override
  _Success2ViewState createState() => _Success2ViewState();
}

class _Success2ViewState extends State<Success2View> {
  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    return Container(
        padding: EdgeInsets.symmetric(horizontal: AppSizes.sidePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: AppSizes.sidePadding * 5),
                child: Image.asset('assets/images/checkout/bags.png')),
            Padding(
              padding: EdgeInsets.only(
                top: AppSizes.sidePadding * 3,
                left: AppSizes.sidePadding * 2,
                right: AppSizes.sidePadding * 2,
              ),
              child: Text('Success!', style: _theme.textTheme.caption),
            ),
            Padding(
                padding: EdgeInsets.all(AppSizes.sidePadding * 2),
                child: Text(
                  'Your order will be delivered soon. Thank you for choosing our app!',
                  // style: _theme.textTheme.display1,
                )),
            OpenFlutterButton(
              title: 'CONTINUE SHOPPING',
              onPressed: (() => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()))
                  }),
            ),
          ],
        ));
  }
}

class Success1View extends StatefulWidget {
  final Function changeView;
  final o.Orders state;

  const Success1View({Key key, this.changeView, this.state}) : super(key: key);

  @override
  _Success1ViewState createState() => _Success1ViewState();
}

class _Success1ViewState extends State<Success1View> {
  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);

    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.imageRadius),
            image: DecorationImage(
                fit: BoxFit.fitHeight,
                image: AssetImage('assets/images/checkout/success.png'))),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSizes.sidePadding * 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: AppSizes.sidePadding * 3),
                  child: Text('Success!', style: _theme.textTheme.caption),
                ),
                Padding(
                    padding: EdgeInsets.all(AppSizes.sidePadding),
                    child: Text(
                      'Your order will be delivered soon. Thank you for choosing our app!',
                      // style: _theme.textTheme.display1,
                    )),
                OpenFlutterButton(
                  title: 'Continue shopping',
                  onPressed: (() => {
                        // widget.changeView(changeType: ViewChangeType.Forward)
                      }),
                ),
              ],
            )));
  }
}

class CartView extends StatefulWidget {
  final Function changeView;
  final o.Orders state;
  final List product;
  CartView({Key key, this.changeView, this.state, this.product})
      : super(key: key);

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List demoCarts;
  @override
  void initState() {
    demoCarts = widget.product;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List cart = [];
    var _theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width - AppSizes.sidePadding * 2;
     dynamic state = widget.state; //o.Orders
    // print("am+${widget.product}");
    // print("am+${state.lineItems}");
    print("am+${widget.state.lineItems}");
    print("am+${state.toString()}");
    ////
    for (var i = 0; i < demoCarts.length; i++) {
      var item = demoCarts[i];
      for (var j = 0; j < widget.state.lineItems.length; j++) {
        var it = widget.state.lineItems[j];
        if (it.productId == item.id) {
          cart.add(item);
        }
      }
    }

    // for (var item in demoCarts) {
    //   for (var it in state.lineItems) {
    //     print('CheckoutDate: $it => ${state.lineItems}');
    //
    //     if (it.productId == item.id) {
    //       print(item);
    //       cart.add(item);
    //     }
    //   }
    // }
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Container(
            height: 200,
            child: ListView.builder(
              itemBuilder: (BuildContext context, inx) {
                return GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 77,
                        child: AspectRatio(
                          aspectRatio: 0.9,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F6F9),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Image.network(cart[inx].images[0].src),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cart[inx].name,
                            style: TextStyle(color: Colors.black, fontSize: 16),
                            maxLines: 2,
                          ),
                          SizedBox(height: 10),
                          Text.rich(
                            TextSpan(
                              text: "\$${cart[inx].price}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFFFF7643)),
                              children: [
                                TextSpan(
                                    text: " x2",
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: width * 0.10,
                        child: new Text(
                          state.lineItems[inx].quantity.toString(),
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductDetail(
                                  product: cart[inx],
                                )));
                  },
                );
              },
              itemCount: cart.length,
            )),
        OpenFlutterBlockSubtitle(title: 'Shipping Address', width: width),
        OpenFlutterActionCard(
            title: "Name",
            linkText: 'Change',
            onLinkTap: (() => {
                  // widget.changeView(
                  //     changeType: ViewChangeType.Exact, index: 2)
                }),
            child: RichText(
              text: TextSpan(
                text: state.billing.firstName + " - " + state.billing.lastName,
                // style: _theme.textTheme.display3.copyWith(color: _theme.primaryColor),
              ),
              maxLines: 2,
            )),
        OpenFlutterActionCard(
            title: "Apartment ",
            linkText: 'Change',
            onLinkTap: (() => {
                  // widget.changeView(
                  //     changeType: ViewChangeType.Exact, index: 2)
                }),
            child: RichText(
              text: TextSpan(
                text: state.billing.address1,
                // style: _theme.textTheme.display3.copyWith(color: _theme.primaryColor),
              ),
              maxLines: 2,
            )),
        OpenFlutterActionCard(
            title: "Address",
            linkText: 'Change',
            onLinkTap: (() => {
                  // widget.changeView(
                  //     changeType: ViewChangeType.Exact, index: 2)
                }),
            child: RichText(
              text: TextSpan(
                text: state.billing.city +
                    ", " +
                    state.billing.state +
                    " ," +
                    state.billing.country,
                // style: _theme.textTheme.display3.copyWith(color: _theme.primaryColor)
              ),
              maxLines: 2,
            )),
        OpenFlutterBlockSubtitle(
          title: 'Payment',
          width: width,
          linkText: 'Change',
          onLinkTap: (() => {}),
        ),
        OpenFlutterPaymentCard(
          cardNumber: state.paymentMethod,
        ),
        Padding(padding: EdgeInsets.only(top: AppSizes.sidePadding * 3)),
        OpenFlutterSummaryLine(
            title: 'Order', summary: '\$' + state.shippingTax),
        Padding(padding: EdgeInsets.only(top: AppSizes.sidePadding)),
        OpenFlutterSummaryLine(
            title: 'Discount Total', summary: '\$' + state.discountTotal),
        Padding(padding: EdgeInsets.only(top: AppSizes.sidePadding)),
        OpenFlutterSummaryLine(title: 'Summary', summary: '\$' + state.total),
        Padding(padding: EdgeInsets.only(top: AppSizes.sidePadding)),
        OpenFlutterButton(
            title: "Submit Order",
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SuccessScreen(
                            text: "Order Succeess",
                            press: () {},
                          )));
            })
      ],
    ));
  }
}

class AppSizes {
  static const int splashScreenTitleFontSize = 48;
  static const int titleFontSize = 34;
  static const double sidePadding = 15;
  static const double widgetSidePadding = 20;
  static const double buttonRadius = 25;
  static const double imageRadius = 8;
  static const double linePadding = 4;
  static const double widgetBorderRadius = 34;
  static const double textFieldRadius = 4.0;
  static const EdgeInsets bottomSheetPadding =
      EdgeInsets.symmetric(horizontal: 16, vertical: 10);
  static const app_bar_size = 56.0;
  static const app_bar_expanded_size = 180.0;
  static const tile_width = 148.0;
  static const tile_height = 276.0;
}

class ShippingAddressView extends StatefulWidget {
  final Function changeView;

  const ShippingAddressView({Key key, this.changeView}) : super(key: key);

  @override
  _ShippingAddressViewState createState() => _ShippingAddressViewState();
}

class _ShippingAddressViewState extends State<ShippingAddressView> {
  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width - AppSizes.sidePadding * 2;

    return SingleChildScrollView(
        child: Stack(children: <Widget>[
      Column(
        children: <Widget>[
          _buildShippingAddress(_theme, width, true),
          _buildShippingAddress(_theme, width, false),
          _buildShippingAddress(_theme, width, false),
        ],
      ),
      Positioned(
        bottom: AppSizes.sidePadding,
        right: AppSizes.sidePadding,
        child: FloatingActionButton(
            mini: true,
            backgroundColor: _theme.primaryColor,
            onPressed: (() => {
                  // widget.changeView(
                  //     changeType: ViewChangeType.Forward)
                }),
            child: Icon(Icons.add, size: 36)),
      ),
    ]));
  }
}

Widget _buildShippingAddress(ThemeData _theme, double width, bool checked) {
  return OpenFlutterActionCard(
      title: 'Jane Doe',
      linkText: 'Edit',
      onLinkTap: () {},
      // {widget.changeView(changeType: ViewChangeType.Forward)}),
      child: Column(children: <Widget>[
        RichText(
          text: TextSpan(
            text: '3 Newbridge Court Chino Hills, CA 91709, United States',
            // style: _theme.textTheme.display3.copyWith(color: _theme.primaryColor)
          ),
          maxLines: 2,
        ),
        Container(
            width: width,
            alignment: Alignment.centerRight,
            child: OpenFlutterCheckbox(
                width: width,
                title: 'Use as the shipping address',
                checked: checked,
                onTap: ((bool newValue) => {
                      //_changeDefaultShippingAddress(bloc, 3)
                    }))),
      ]));
}

class AddShippingAddressView extends StatefulWidget {
  final Function changeView;

  const AddShippingAddressView({Key key, this.changeView}) : super(key: key);

  @override
  _AddShippingAddressViewState createState() => _AddShippingAddressViewState();
}

class _AddShippingAddressViewState extends State<AddShippingAddressView> {
  int paymentCardIndex = 0;

  TextEditingController _fullNameController;
  TextEditingController _addressController;
  TextEditingController _cityController;
  TextEditingController _stateController;
  TextEditingController _postalController;
  TextEditingController _countryController;

  @override
  void initState() {
    _fullNameController = TextEditingController();
    _addressController = TextEditingController();
    _cityController = TextEditingController();
    _stateController = TextEditingController();
    _postalController = TextEditingController();
    _countryController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _fullNameController?.dispose();
    _addressController?.dispose();
    _cityController?.dispose();
    _stateController?.dispose();
    _postalController?.dispose();
    _countryController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
          ),
          OpenFlutterInputField(
            controller: _fullNameController,
            hint: 'Full name',
          ),
          Padding(
            padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
          ),
          OpenFlutterInputField(
            controller: _addressController,
            hint: 'Address',
          ),
          Padding(
            padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
          ),
          OpenFlutterInputField(
            controller: _cityController,
            hint: 'City',
          ),
          Padding(
            padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
          ),
          OpenFlutterInputField(
            controller: _stateController,
            hint: 'State/Province/Region',
          ),
          Padding(
            padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
          ),
          OpenFlutterInputField(
            controller: _postalController,
            hint: 'Zip Code (Postal Code)',
          ),
          Padding(
            padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
          ),
          OpenFlutterInputField(
            controller: _countryController,
            hint: 'Country',
          ),
          Padding(
            padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
          ),
          OpenFlutterButton(
            title: 'SAVE ADDRESS',
            onPressed: (() => {}),
          )
        ],
      ),
    );
  }
}

class OpenFlutterPaymentCard extends StatelessWidget {
  final String cardNumber;

  const OpenFlutterPaymentCard({Key key, @required this.cardNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    return Container(
        padding: EdgeInsets.all(AppSizes.sidePadding),
        child: Row(
          children: <Widget>[
            Container(
              width: 64,
              height: 38,
              color: Colors.white,
              //child: Image.asset('assets/images/checkout/mastercard.png',
              // height: 38
              // ),
            ),
            Container(
              padding: EdgeInsets.only(left: AppSizes.sidePadding),
              child: Text(
                cardNumber,
                // style: _theme.textTheme.display3.copyWith(color: _theme.primaryColor)
              ),
            )
          ],
        ));
  }
}
