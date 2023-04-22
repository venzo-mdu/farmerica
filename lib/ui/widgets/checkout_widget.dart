import 'package:flutter/material.dart';
import 'package:farmerica/models/Order.dart';
import 'package:farmerica/models/Products.dart';
import 'package:farmerica/ui/checkoutPage.dart';
import 'package:farmerica/ui/productDetails.dart';

enum CardType { MasterCard, Visa }

class OpenFlutterBlockSubtitle extends StatelessWidget {
  final double width;
  final String title;
  final String linkText;
  final Function onLinkTap;

  const OpenFlutterBlockSubtitle({
    Key key,
    this.width,
    @required this.title,
    this.linkText,
    this.onLinkTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    const rightLinkWidth = 100.0;
    return Container(
      padding: EdgeInsets.only(
          top: AppSizes.sidePadding, left: AppSizes.sidePadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                    child: Text(
                  title,
                  // style: _theme.textTheme.display1.copyWith(
                  //     fontWeight: FontWeight.bold,
                  //     color: _theme.primaryColor),
                )),
                linkText != null
                    ? InkWell(
                        onTap: (() => {onLinkTap()}),
                        child: Container(
                          width: rightLinkWidth,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              linkText,
                              // style: _theme.textTheme.display1
                              //     .copyWith(color: _theme.accentColor),
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class OpenFlutterInputField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final FormFieldValidator validator;
  final TextInputType keyboard;
  final FocusNode focusNode;
  final VoidCallback onFinished;
  final bool isPassword;
  final double horizontalPadding;
  final Function onValueChanged;
  final String error;

  const OpenFlutterInputField(
      {Key key,
      @required this.controller,
      this.hint,
      this.validator,
      this.keyboard = TextInputType.text,
      this.focusNode,
      this.onFinished,
      this.isPassword = false,
      this.horizontalPadding = 16.0,
      this.onValueChanged,
      this.error})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OpenFlutterInputFieldState();
  }
}

class OpenFlutterInputFieldState extends State<OpenFlutterInputField> {
  String error;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    error = widget.error;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.horizontalPadding),
      child: Column(
        children: <Widget>[
          Card(
            elevation: 3,
            shape: error != null
                ? RoundedRectangleBorder(
                    side: BorderSide(color: Colors.red, width: 1.0),
                    borderRadius:
                        BorderRadius.circular(AppSizes.textFieldRadius),
                  )
                : RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white, width: 1.0),
                    borderRadius:
                        BorderRadius.circular(AppSizes.textFieldRadius),
                  ),
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: TextField(
                onChanged: (value) => widget.onValueChanged(value),
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                    fontSize: 16),
                controller: widget.controller,
                focusNode: widget.focusNode,
                keyboardType: widget.keyboard,
                obscureText: widget.isPassword,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    labelText: widget.hint,
                    hintText: widget.hint,
                    suffixIcon: error != null
                        ? Icon(
                            Icons.close,
                            color: Colors.red,
                          )
                        : isChecked
                            ? Icon(Icons.done)
                            : null,
                    hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                        fontWeight: FontWeight.w300)),
              ),
            ),
          ),
          error == null
              ? Container()
              : Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                )
        ],
      ),
    );
  }

  String validate() {
    setState(() {
      error = widget.validator(widget.controller.text);
    });
    return error;
  }
}

class OpenFlutterButton extends StatelessWidget {
  final double width;
  final double height;
  final Function onPressed;
  final String title;
  final IconData icon;
  final double iconSize;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;

  OpenFlutterButton({
    Key key,
    this.width,
    this.height,
    @required this.title,
    @required this.onPressed,
    this.icon,
    this.backgroundColor = Colors.red,
    this.textColor = Colors.white,
    this.borderColor = Colors.red,
    this.iconSize = 18.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    EdgeInsetsGeometry edgeInsets = EdgeInsets.all(0);
    if (width == null || height == null) {
      edgeInsets = EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0);
    }
    return Padding(
      padding: edgeInsets,
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: width,
          height: height,
          padding: edgeInsets,
          decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(AppSizes.buttonRadius),
              boxShadow: [
                BoxShadow(
                    color: backgroundColor.withOpacity(0.3),
                    blurRadius: 4.0,
                    offset: Offset(0.0, 5.0)),
              ]),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildIcon(_theme),
                _buildTitle(_theme),
              ],
            ),
          ),
        ),
      ),
    );
    /*RaisedButton(
      onPressed: onPressed,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(
          AppSizes.buttonRadius
        )
      ),
      child: Container(
        alignment: Alignment.center,
        width: width,
        height: height,
        child: Text(title,
          style: _theme.textTheme.button.copyWith(
            backgroundColor: _theme.textTheme.button.backgroundColor,
            color: _theme.textTheme.button.color
          )
        )
      )
    );*/
  }

  Widget _buildTitle(ThemeData _theme) {
    return Text(
      title,
      style: _theme.textTheme.button.copyWith(
        backgroundColor: _theme.textTheme.button.backgroundColor,
        color: textColor,
      ),
    );
  }

  Widget _buildIcon(ThemeData theme) {
    if (icon != null) {
      return Padding(
        padding: const EdgeInsets.only(
          right: 8.0,
        ),
        child: Icon(
          icon,
          size: iconSize,
          color: theme.textTheme.button.color,
        ),
      );
    }

    return SizedBox();
  }
}

class OpenFlutterBottomPopup extends StatelessWidget {
  final Widget child;
  final String title;

  const OpenFlutterBottomPopup(
      {Key key, @required this.child, @required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var fullWidth = MediaQuery.of(context).size.width;
    return Positioned(
        bottom: 0,
        left: 0,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: _theme.dialogBackgroundColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSizes.widgetBorderRadius),
                topRight: Radius.circular(AppSizes.widgetBorderRadius),
              )),
          width: fullWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(AppSizes.sidePadding),
                child: Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(AppSizes.imageRadius),
                  ),
                ),
              ),
              title != ''
                  ? Text(title) // ,style: _theme.textTheme.display1
                  : Container(),
              Padding(
                padding: EdgeInsets.only(bottom: AppSizes.sidePadding),
              ),
              child
            ],
          ),
        ));
  }
}

class OpenFlutterCheckbox extends StatelessWidget {
  final double width;
  final String title;
  final bool checked;
  final Function(bool) onTap;

  final mainAxisAlignment;

  const OpenFlutterCheckbox({
    Key key,
    this.width,
    @required this.title,
    this.checked,
    this.onTap,
    this.mainAxisAlignment = MainAxisAlignment.start,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var rightLinkWidth = 100.0;
    return Container(
        child: InkWell(
            onTap: (() => {onTap(!checked)}),
            child: Row(
              mainAxisAlignment: mainAxisAlignment,
              children: <Widget>[
                Checkbox(
                    activeColor: _theme.primaryColor,
                    checkColor: _theme.backgroundColor,
                    value: checked,
                    onChanged: ((bool newValue) => {onTap(newValue)})),
                Container(
                  width: width - rightLinkWidth,
                  child: Text(
                    title,
                    // style: _theme.textTheme.display1.copyWith(
                    //     fontWeight: FontWeight.bold,
                    //     color: _theme.primaryColor),
                  ),
                ),
              ],
            )));
  }
}

class OpenFlutterPaymentCardPreview extends StatelessWidget {
  final double width;
  final String cardNumber;
  final String cardHolderName;
  final int expirationMonth;
  final int expirationYear;
  final CardType cardType;

  const OpenFlutterPaymentCardPreview(
      {Key key,
      @required this.width,
      @required this.cardNumber,
      @required this.cardHolderName,
      @required this.expirationMonth,
      @required this.expirationYear,
      this.cardType = CardType.MasterCard})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var asset = 'assets/images/checkout/dark_card.png';
    if (cardType == CardType.Visa) {
      asset = 'assets/images/checkout/light_card.png';
    }
    return Container(
        padding: EdgeInsets.all(AppSizes.sidePadding),
        child: Container(
            width: width,
            height: width * 0.63,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.imageRadius),
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(asset),
              ),
            ),
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: 100,
                  left: 24,
                  width: width - AppSizes.sidePadding,
                  height: 38,
                  child: Text(
                    cardNumber,
                    // style: _theme.textTheme.title.copyWith(
                    //     fontSize: 24, color: Colors.white, letterSpacing: 6),
                  ),
                ),
                Positioned(
                  top: 210,
                  left: 24,
                  width: width - AppSizes.sidePadding,
                  height: 38,
                  child: Text(
                    cardHolderName,
                    // style: _theme.textTheme.display3.copyWith(
                    //     //fontSize: 34,
                    //     color: Colors.white),
                  ),
                ),
                Positioned(
                  top: 210,
                  left: 185,
                  width: width - AppSizes.sidePadding,
                  height: 38,
                  child: Text(
                    expirationMonth.toString().padLeft(2, '0') +
                        '/' +
                        expirationYear.toString().padLeft(2, '0'),
                    // style: _theme.textTheme.display3.copyWith(
                    //     //fontSize: 34,
                    //     color: Colors.white),
                  ),
                ),
              ],
            )));
  }
}

class OpenFlutterSummaryLine extends StatelessWidget {
  final String title;
  final String summary;

  const OpenFlutterSummaryLine({Key key, this.title, this.summary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width - AppSizes.sidePadding * 2;
    var _theme = Theme.of(context);
    return Container(
        padding: EdgeInsets.symmetric(
            horizontal: AppSizes.sidePadding, vertical: AppSizes.linePadding),
        child: Row(
          children: <Widget>[
            Container(
                width: width / 2,
                child: Text(title)), // , style: _theme.textTheme.display3
            Container(
                alignment: Alignment.centerRight,
                width: width / 2,
                child: Text(
                  summary,
                  // style: _theme.textTheme.display3.copyWith(
                  //     fontWeight: FontWeight.bold,
                  //     color: _theme.primaryColor),
                )),
          ],
        ));
  }
}

class OpenFlutterActionCard extends StatelessWidget {
  final String title;
  final String linkText;
  final Function onLinkTap;
  final Widget child;

  const OpenFlutterActionCard(
      {Key key,
      @required this.title,
      this.linkText,
      this.child,
      this.onLinkTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width - AppSizes.sidePadding * 4;
    return Padding(
        padding: EdgeInsets.all(AppSizes.sidePadding),
        child: Container(
          padding: EdgeInsets.all(AppSizes.sidePadding),
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(AppSizes.imageRadius)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: AppSizes.imageRadius,
                    offset: Offset(0.0, AppSizes.imageRadius))
              ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  child: Text(title,
                      style: _theme.textTheme.headline4
                          .copyWith(color: _theme.primaryColor))),
              Container(
                  padding:
                      EdgeInsets.symmetric(vertical: AppSizes.linePadding * 2),
                  child: child),
              linkText != null
                  ? Container(
                      alignment: Alignment.centerRight,
                      width: width / 4,
                      child: InkWell(
                        onTap: (() => {onLinkTap()}),
                        child: Text(
                          linkText,
                          // style: _theme.textTheme.display3.copyWith(color: _theme.accentColor)
                        ),
                      ))
                  : Container()
            ],
          ),
        ));
  }
}

class OpenFlutterDeliveryMethod extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _theme = Theme.of(context);
    var width = MediaQuery.of(context).size.width;
    var widgetWidth = (width) / 3;
    var height = 90.0;
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.only(
          left: AppSizes.sidePadding, top: AppSizes.sidePadding),
      child: Row(
        children: <Widget>[
          buildElement('assets/images/checkout/fedex.png', '2-3 days', _theme,
              widgetWidth, height),
          buildElement('assets/images/checkout/usps.png', '2-3 days', _theme,
              widgetWidth, height),
          buildElement('assets/images/checkout/dhl.png', '2-3 days', _theme,
              widgetWidth, height),
        ],
      ),
    );
  }

  Widget buildElement(String assetImage, String title, ThemeData _theme,
      double width, double height) {
    return Padding(
        padding: EdgeInsets.only(right: AppSizes.sidePadding),
        child: Container(
          width: width - AppSizes.linePadding * 2 - AppSizes.sidePadding,
          height: height,
          padding: EdgeInsets.all(AppSizes.linePadding),
          decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.all(Radius.circular(AppSizes.imageRadius)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: AppSizes.imageRadius,
                    offset: Offset(0.0, AppSizes.imageRadius))
              ]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(AppSizes.sidePadding),
                child: Image.asset(
                  assetImage,
                  width: 61,
                ),
              ),
              Text(
                title,
                // style: _theme.textTheme.body2.copyWith(color: _theme.primaryColorLight),
              )
            ],
          ),
        ));
  }
}

enum ViewChangeType { Start, Forward, Backward, Exact }

class OpenFlutterWrapperState<T> extends State {
  PageController _viewController;

  PageView getPageView(List<Widget> widgets) {
    return PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _viewController,
        children: widgets);
  }

  void changePage({@required ViewChangeType changeType, int index}) {
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
    _viewController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _viewController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    throw Exception('Build method should be implemented in child class');
  }
}

class CartCard extends StatefulWidget {
  const CartCard({
    Key key,
    @required this.product,
    @required this.cart,
  }) : super(key: key);
  final List<LineItems> product;
  final Product cart;

  @override
  _CartCardState createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  int addtoCart = 1;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    // p.Product product;
    // print("pri");
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            width: 77,
            child: AspectRatio(
              aspectRatio: 0.88,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Image.network(widget.cart.images[0].src),
              ),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.cart.name,
                style: TextStyle(color: Colors.black, fontSize: 16),
                maxLines: 2,
              ),
              SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  text: "\$${widget.cart.price}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600, color: Color(0xFFFF7643)),
                  children: [
                    TextSpan(
                        text: " x2",
                        style: Theme.of(context).textTheme.bodyText1),
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
              widget.product[0].quantity.toString(),
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
                      product: widget.cart,
                    )));
      },
    );
  }
}

class AppConsts {
  static const page_size = 20;
}

// Ref: Font Weights: https://api.flutter.dev/flutter/dart-ui/FontWeight-class.html
// Ref: Font Weights for TextTheme: https://api.flutter.dev/flutter/material/TextTheme-class.html
class OpenFlutterEcommerceTheme {
  static ThemeData of(context) {
    var theme = Theme.of(context);
    return theme.copyWith(
      primaryColor: AppColors.black,
      primaryColorLight: AppColors.lightGray,
      accentColor: AppColors.red,
      bottomAppBarColor: AppColors.lightGray,
      backgroundColor: AppColors.background,
      dialogBackgroundColor: AppColors.backgroundLight,
      errorColor: AppColors.red,
      dividerColor: Colors.transparent,
      appBarTheme: theme.appBarTheme.copyWith(
          color: AppColors.white,
          iconTheme: IconThemeData(color: AppColors.black),
          textTheme: theme.textTheme.copyWith(
              caption: TextStyle(
                  color: AppColors.black,
                  fontSize: 18,
                  fontFamily: 'Metropolis',
                  fontWeight: FontWeight.w400))),
      textTheme: theme.textTheme
          // .copyWith(
          //   //over image white text
          //   headline: theme.textTheme.headline.copyWith(
          //       fontSize: 48,
          //       color: AppColors.white,
          //       fontFamily: 'Metropolis',
          //       fontWeight: FontWeight.w900),
          //   title: theme.textTheme.title.copyWith(
          //       fontSize: 24,
          //       color: AppColors.black,
          //       fontWeight: FontWeight.w900,
          //       fontFamily: 'Metropolis'), //
          //
          //   //product title
          //   display1: theme.textTheme.display1.copyWith(
          //       color: AppColors.black,
          //       fontSize: 16,
          //       fontWeight: FontWeight.w400,
          //       fontFamily: 'Metropolis'),
          //
          //   display2: theme.textTheme.display2.copyWith(
          //       fontFamily: 'Metropolis', fontWeight: FontWeight.w400),
          //   //product price
          //   display3: theme.textTheme.display3.copyWith(
          //       color: AppColors.lightGray,
          //       fontSize: 14,
          //       fontFamily: 'Metropolis',
          //       fontWeight: FontWeight.w400),
          //   display4: theme.textTheme.display4.copyWith(
          //       fontFamily: 'Metropolis', fontWeight: FontWeight.w500),
          //
          //   subtitle: theme.textTheme.headline.copyWith(
          //       fontSize: 18,
          //       color: AppColors.black,
          //       fontFamily: 'Metropolis',
          //       fontWeight: FontWeight.w400),
          //   subhead: theme.textTheme.headline.copyWith(
          //       fontSize: 24,
          //       color: AppColors.darkGray,
          //       fontFamily: 'Metropolis',
          //       fontWeight: FontWeight.w500),
          //   //red button with white text
          //   button: theme.textTheme.button.copyWith(
          //       fontSize: 14,
          //       color: AppColors.white,
          //       fontFamily: 'Metropolis',
          //       fontWeight: FontWeight.w500),
          //   //black caption title
          //   caption: theme.textTheme.caption.copyWith(
          //       fontSize: 34,
          //       color: AppColors.black,
          //       fontFamily: 'Metropolis',
          //       fontWeight: FontWeight.w700),
          //   //light gray small text
          //   body1: theme.textTheme.body1.copyWith(
          //       color: AppColors.lightGray,
          //       fontSize: 11,
          //       fontFamily: 'Metropolis',
          //       fontWeight: FontWeight.w400),
          //   //view all link
          //   body2: theme.textTheme.body2.copyWith(
          //       color: AppColors.black,
          //       fontSize: 11,
          //       fontFamily: 'Metropolis',
          //       fontWeight: FontWeight.w400),
          // )
          .apply(fontFamily: 'Metropolis'),
      buttonTheme: theme.buttonTheme.copyWith(
        minWidth: 50,
        buttonColor: AppColors.red,
      ),
    );
  }
}

class AppColors {
  static const red = Color(0xFFDB3022);
  static const black = Color(0xFF222222);
  static const lightGray = Color(0xFF9B9B9B);
  static const darkGray = Color(0xFF979797);
  static const white = Color(0xFFFFFFFF);
  static const orange = Color(0xFFFFBA49);
  static const background = Color(0xFFE5E5E5);
  static const backgroundLight = Color(0xFFF9F9F9);
  static const transparent = Color(0x00000000);
  static const success = Color(0xFF2AA952);
  static const green = Color(0xFF2AA952);
}
