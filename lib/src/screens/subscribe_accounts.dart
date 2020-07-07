import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:work_witness/src/controller/controller.dart';
import 'package:work_witness/src/controller/models/subscribe_info.dart';
import 'package:work_witness/src/controller/models/subscription.dart';
import 'package:work_witness/src/controller/models/subscription_benefit.dart';
import 'package:work_witness/src/controller/models/subscription_result.dart';
import 'package:work_witness/src/screens/subscribe_benefits.dart';
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

  int idSubscription = 1;

  void readSubscriptons() {
    
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
    widget.subscribeInfo.idSubscription = idSubscription;
    widget.subscribeInfo.days = 30;

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
      idSubscription = i;
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
            Expanded(child: AccountItem(idSubscription: idSubscription, onSelectItem: onSelectItem),),
            Container(
              color: Theme.of(context).primaryColorDark,
              height: 80,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: RaisedButton(
                  color: Colors.green[800],
                  onPressed: () {
                    onSubscribe(context);
                  },
                  child: Text('subscribe it',
                      style: Theme.of(context).textTheme.bodyText1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AccountItem extends StatefulWidget {
  int idSubscription;
  final Function(int) onSelectItem;
  AccountItem({@required this.idSubscription, @required this.onSelectItem});

  @override
  _AccountItemState createState() => _AccountItemState();
}

class _AccountItemState extends State<AccountItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, left: 20, right: 20),
      child: ListView(children: <Widget>[
          InkWell(
              onTap: () {
                setState(() {
                  widget.idSubscription = 1;
                  widget.onSelectItem(widget.idSubscription);
                });
              },
              child: Card(
                color: widget.idSubscription==1? Colors.blue[100] : Colors.white,
                elevation: 5,
                child: Container(
                  height: 380,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Employee wide', style: TextStyle(color: Colors.grey[500], fontSize: 22)),
                      SizedBox(height: 20,),
                      Text('\$ 2,99 / mo', style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),),
                      SizedBox(height: 6,),
                      Text('(per employee)', style: TextStyle(color: Colors.grey[700], fontSize: 20)),
                      SizedBox(height: 20),
                      Container(decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[700])),),),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('more than 200', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                            SizedBox(height: 5,),
                            Text('pay per month per registered and active employee', style: TextStyle(color: Colors.white, fontSize: 18),),
                          ],
                        ),
                        decoration: BoxDecoration(color: Colors.blueGrey[200], borderRadius: BorderRadius.circular(10)),
                      ),
                      SizedBox(height: 30),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text('first month free', style: TextStyle(color: Colors.white, fontSize: 16),),
                        decoration: BoxDecoration(color: Colors.blue[900], borderRadius: BorderRadius.circular(2)),
                      ),
                    ],
                  ),
                ),
            ),
          ),
          InkWell(
              onTap: () {
                setState(() {
                  widget.idSubscription = 2;
                  widget.onSelectItem(widget.idSubscription);
                });
              },
              child: Card(
                color: widget.idSubscription==2? Colors.blue[100] : Colors.white,
                elevation: 5,
                child: Container(
                  height: 380,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Employee large', style: TextStyle(color: Colors.grey[500], fontSize: 22)),
                      SizedBox(height: 20,),
                      Text('\$ 5,38 / mo', style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),),
                      SizedBox(height: 6,),
                      Text('(per employee)', style: TextStyle(color: Colors.grey[700], fontSize: 20)),
                      SizedBox(height: 20),
                      Container(decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[700])),),),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('from 100 to 199', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                            SizedBox(height: 5,),
                            Text('pay per month per registered and active employee', style: TextStyle(color: Colors.white, fontSize: 18),),
                          ],
                        ),
                        decoration: BoxDecoration(color: Colors.blueGrey[200], borderRadius: BorderRadius.circular(10)),
                      ),
                      SizedBox(height: 30),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text('first month free', style: TextStyle(color: Colors.white, fontSize: 16),),
                        decoration: BoxDecoration(color: Colors.blue[900], borderRadius: BorderRadius.circular(2)),
                      ),
                    ],
                  ),
                ),
            ),
          ),
          InkWell(
              onTap: () {
                setState(() {
                  widget.idSubscription = 3;
                  widget.onSelectItem(widget.idSubscription);
                });
              },
              child: Card(
                color: widget.idSubscription==3? Colors.blue[100] : Colors.white,
                elevation: 5,
                child: Container(
                  height: 380,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Employee medium', style: TextStyle(color: Colors.grey[500], fontSize: 22)),
                      SizedBox(height: 20,),
                      Text('\$ 9,69 / mo', style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),),
                      SizedBox(height: 6,),
                      Text('(per employee)', style: TextStyle(color: Colors.grey[700], fontSize: 20)),
                      SizedBox(height: 20),
                      Container(decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[700])),),),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('from 50 to 99', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                            SizedBox(height: 5,),
                            Text('pay per month per registered and active employee', style: TextStyle(color: Colors.white, fontSize: 18),),
                          ],
                        ),
                        decoration: BoxDecoration(color: Colors.blueGrey[200], borderRadius: BorderRadius.circular(10)),
                      ),
                      SizedBox(height: 30),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text('first month free', style: TextStyle(color: Colors.white, fontSize: 16),),
                        decoration: BoxDecoration(color: Colors.blue[900], borderRadius: BorderRadius.circular(2)),
                      ),
                    ],
                  ),
                ),
              ),
          ),
          InkWell(
              onTap: () {
                setState(() {
                  widget.idSubscription = 4;
                  widget.onSelectItem(widget.idSubscription);
                });
              },
              child: Card(
                color: widget.idSubscription==4? Colors.blue[100] : Colors.white,
                elevation: 5,
                child: Container(
                  height: 380,
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('Employee small', style: TextStyle(color: Colors.grey[500], fontSize: 22)),
                      SizedBox(height: 20,),
                      Text('\$ 18,41 / mo', style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),),
                      SizedBox(height: 6,),
                      Text('(per employee)', style: TextStyle(color: Colors.grey[700], fontSize: 20)),
                      SizedBox(height: 20),
                      Container(decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[700])),),),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('from 2 to 49', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
                            SizedBox(height: 5,),
                            Text('pay per month per registered and active employee', style: TextStyle(color: Colors.white, fontSize: 18),),
                          ],
                        ),
                        decoration: BoxDecoration(color: Colors.blueGrey[200], borderRadius: BorderRadius.circular(10)),
                      ),
                      SizedBox(height: 30),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text('first month free', style: TextStyle(color: Colors.white, fontSize: 16),),
                        decoration: BoxDecoration(color: Colors.blue[900], borderRadius: BorderRadius.circular(2)),
                      ),
                    ],
                  ),
                ),
              ),
          ),
          SizedBox(height: 50,),
      ],)
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
