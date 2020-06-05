import 'package:flutter/material.dart';
import 'package:work_witness/src/controller/controller.dart';
import 'package:work_witness/src/controller/models/subscribe_info.dart';
import 'package:work_witness/src/controller/models/subscription.dart';
import 'package:work_witness/src/controller/models/subscription_benefit.dart';
import 'package:work_witness/src/controller/models/subscription_result.dart';
import 'package:work_witness/src/screens/subscription_success.dart';
import 'package:work_witness/src/widgets/loading_Indicator.dart';

class SubscribeAccountScreen extends StatefulWidget {
  final SubscribeInfo subscribeInfo;

  SubscribeAccountScreen({@required this.subscribeInfo});

  @override
  _SubscribeAccountScreenState createState() => _SubscribeAccountScreenState();
}

class _SubscribeAccountScreenState extends State<SubscribeAccountScreen> {
  List<Subscription> subscriptions;
  List<bool> subscriptionSelects;
  List<IconData> icons = [
    Icons.person,
    Icons.person,
    Icons.people,
    Icons.business
  ];
  bool loading = false;

  void readSubscriptons() {
    setState(() {
      loading = true;
    });
    Controller.listSubscriptions().then((List<Subscription> _subscriptions) {
      setState(() {
        subscriptions = _subscriptions;
        if (_subscriptions.length > 0) {
          subscriptionSelects = List<bool>.filled(_subscriptions.length, false);
          subscriptionSelects[1] = true;
        }
        loading = false;
      });
    });
  }

  int getSubscribeSelect() {
    for (var c = 0; c < subscriptionSelects.length; c++) {
      if (subscriptionSelects[c]) {
        return c;
      }
    }
    return 0;
  }

  void subscribeProblem(BuildContext context, String msg) {
    showDialog(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Warning!'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(msg),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void onSubscribe(BuildContext context) {
    setState(() {
      loading = true;
    });
    int i = getSubscribeSelect();
    widget.subscribeInfo.idSubscription = subscriptions[i].id;
    widget.subscribeInfo.days = subscriptions[i].pricePerMonth > 0 ? 15 : 0;

    Controller.insertSubscription(widget.subscribeInfo)
        .then((SubscriptionResult subscriptionResult) {
      setState(() {
        loading = false;
      });
      if (subscriptionResult.success == true &&
          subscriptionResult.exists == false) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SubscriptionSuccess(),
          ),
        );
      } else if (subscriptionResult.exists == true) {
        subscribeProblem(context, 'This email already exists!');
      } else {
        subscribeProblem(context, 'An error occured!');
      }
    });
  }

  void onSelectItem(int i) {
    setState(() {
      for (var c = 0; c < subscriptionSelects.length; c++) {
        if (c != i) {
          subscriptionSelects[c] = false;
        }
      }
      subscriptionSelects[i] = true;
    });
  }

  @override
  void initState() {
    readSubscriptons();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColorDark.withOpacity(0.6),
        title: Text('Work Witness',
            style: TextStyle(color: Colors.white, fontSize: 22)),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.navigate_before,
              color: Colors.white,
              size: 28,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          image: DecorationImage(
            image: AssetImage("assets/images/logo_t.png"),
            fit: BoxFit.none,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 90),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'Please select the type of subscribe',
                style: Theme.of(context).textTheme.headline1,
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
              child: !loading
                  ? ListView.builder(
                      padding: EdgeInsets.only(top: 0),
                      itemCount: subscriptions.length,
                      itemBuilder: (context, i) => AccountItem(
                        index: i,
                        icon: icons[i],
                        subscription: subscriptions[i],
                        selected: subscriptionSelects[i],
                        onSelectItem: onSelectItem,
                      ),
                    )
                  : LoadingIndicator(),
            ),
            Container(
              color: Colors.green[800],
              height: 60,
              width: MediaQuery.of(context).size.width,
              child: FlatButton(
                onPressed: () {
                  onSubscribe(context);
                },
                child: Text('subscribe it',
                    style: Theme.of(context).textTheme.bodyText1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountItem extends StatefulWidget {
  final int index;
  final IconData icon;
  final Subscription subscription;
  final bool selected;
  final Function(int) onSelectItem;

  AccountItem({
    @required this.index,
    @required this.icon,
    @required this.subscription,
    @required this.selected,
    @required this.onSelectItem,
  });

  @override
  _AccountItemState createState() => _AccountItemState();
}

class _AccountItemState extends State<AccountItem> {
  List<SubscriptionBenefit> benefits;
  bool loading = false;

  @override
  void initState() {
    benefits = [];
    loading = true;
    Controller.listSubscriptionBenefits(widget.subscription.id)
        .then((List<SubscriptionBenefit> _benefits) {
      setState(() {
        loading = false;
        benefits = _benefits;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog(String name) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(name + ' Benefits'),
            content: ListView.builder(
              itemCount: benefits.length,
              itemBuilder: (context, i) => Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(benefits[i].name,
                        style: Theme.of(context).textTheme.caption),
                    Container(
                      color: Colors.amber[50],
                      padding: EdgeInsets.all(10),
                      child: benefits[i].cover == 0
                          ? Text(
                              'no limits',
                              style: Theme.of(context).textTheme.caption,
                            )
                          : Text('Cover: ' + benefits[i].cover.toString(),
                              style: Theme.of(context).textTheme.caption),
                    ),
                  ],
                ),
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return InkWell(
      onTap: () {
        widget.onSelectItem(widget.index);
      },
      child: Card(
        color: Colors.white,
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(7),
          child: Stack(children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Stack(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Container(
                                child: IconButton(
                                    icon: Icon(
                                      widget.selected
                                          ? Icons.check_circle
                                          : Icons.radio_button_unchecked,
                                      size: 36,
                                      color: widget.selected
                                          ? Colors.green
                                          : Colors.black87,
                                    ),
                                    onPressed: () {
                                      widget.onSelectItem(widget.index);
                                    }),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 20),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      widget.subscription.name,
                                      style:
                                          Theme.of(context).textTheme.subtitle2,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      widget.subscription.offer,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ],
                                ),
                              ),
                              Spacer(),
                              FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  _showMyDialog(widget.subscription.name);
                                },
                                child: Text(
                                  'benefits',
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Icon(widget.icon),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          ),
                          Container(
                            padding:
                                EdgeInsets.only(top: 20, left: 20, bottom: 20),
                            child: Row(
                              children: <Widget>[
                                SubscribePrice(
                                  price: widget.subscription.pricePerMonth,
                                  annual: widget.subscription.annual,
                                )
                              ],
                            ),
                          )
                        ],
                      ))
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class SubscribePrice extends StatelessWidget {
  final double price;
  final bool annual;
  SubscribePrice({
    @required this.price,
    @required this.annual,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.amber[50],
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Text('Price:', style: Theme.of(context).textTheme.headline5),
          SizedBox(width: 10),
          price > 0
              ? Row(
                  children: <Widget>[
                    Text(price.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.headline5),
                    Text('/Mo', style: Theme.of(context).textTheme.headline5),
                  ],
                )
              : Text('free', style: Theme.of(context).textTheme.headline5),
          SizedBox(width: 6),
          annual
              ? Text('(paid annually)',
                  style: TextStyle(
                      color: Theme.of(context).primaryColorDark, fontSize: 16))
              : Container(),
        ],
      ),
    );
  }
}
