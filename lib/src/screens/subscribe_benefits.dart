import 'package:flutter/material.dart';
import 'package:work_witness/src/controller/controller.dart';
import 'package:work_witness/src/controller/models/subscription.dart';
import 'package:work_witness/src/controller/models/subscription_benefit.dart';
import 'package:work_witness/src/widgets/loading_Indicator.dart';

class SubscribeBenefits extends StatefulWidget {
  final Subscription subscription;

  SubscribeBenefits({@required this.subscription});

  @override
  _SubscribeBenefitsState createState() => _SubscribeBenefitsState();
}

class _SubscribeBenefitsState extends State<SubscribeBenefits> {
  List<SubscriptionBenefit> benefits;
  bool loading = false;

  ListView _benefitsList() {
    return ListView.builder(
      itemCount: benefits.length,
      itemBuilder: (BuildContext context, int index) {
        var item = Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(benefits[index].name,
                  style: Theme.of(context).textTheme.bodyText1),
              SizedBox(height: 20,),
              Container(
                color: Colors.amber[50],
                padding: EdgeInsets.all(10),
                child: benefits[index].cover == 0
                    ? Text(
                        'no limits',
                        style: Theme.of(context).textTheme.caption,
                      )
                    : Text('Cover: ' + benefits[index].cover.toString(),
                        style: Theme.of(context).textTheme.caption),
              ),
            ],
          ),
        );
        if ((index + 1) == benefits.length) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              item,
              SizedBox(height: 20,),
              Center(
                child: RaisedButton(
                  color: Theme.of(context).primaryColorDark,
                  padding: EdgeInsets.only(top: 16, left: 40, bottom: 16, right: 40),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('back', style: Theme.of(context).textTheme.bodyText1),
                ),
              ),
            ],
          );
        } else {
          return item;
        }
      },
    );
  }

  @override
  void initState() {
    loading = true;
    benefits = [];
    Controller.listSubscriptionBenefits(widget.subscription.id)
        .then((List<SubscriptionBenefit> _benefits) {
      setState(() {
        benefits = _benefits;
        loading = false;
      });
    });
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
        padding: EdgeInsets.all(20),
        color: Theme.of(context).primaryColor,
        height: MediaQuery.of(context).size.height,
        child: !loading
            ? _benefitsList()
            : LoadingIndicator(
                size: 40,
              ),
      ),
    );
  }
}
