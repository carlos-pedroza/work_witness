import 'package:flutter/material.dart';
import 'package:work_witness/src/screens/subscribe_formulary_screen.dart';

class SubscribeScreen extends StatefulWidget {
  @override
  _SubscribeScreenState createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  List<String> introduction = [
    'You are an individual or professional worker, you take you a long time to collect information and photos of your work done, you can reduce time and generate your reports automatically  to inform your clients using Work-Witness.',
    'You are a company that have a lot of employees, you can generate their reports and evidence of the work is not always an easy task, especially if they do their work in the clients\' offices, the supervision on time is very important and the control of the hours worked, schedules and absenteeism it is necessary. Work-witness provides you with the essential tools to take full control of the workers who perform their work in your clients\' offices remotely.',
    'You are a cooperative, being able to manage the work of different companies and their multiple employees without losing control is a challenge, for this reason, having technological tools to support you in this essential task is very important. Try Work-Witness and get support with this great tool to control your projects easily and efficiently.'
  ];
  @override
  Widget build(BuildContext context) {
    void goNext() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SubscribeFormularyScreen(),
        ),
      );
    }

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    'Workforce Control',
                    style: Theme.of(context).textTheme.headline1,
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[100].withOpacity(0.8),
                    border: Border.all(
                      color: Colors.brown[300],
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IntroductionText(
                    icon: Icons.person,
                    caption: introduction[0],
                    onTap: () {
                      goNext();
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.cyan[100].withOpacity(0.8),
                    border: Border.all(
                      color: Colors.cyan[300],
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IntroductionText(
                    icon: Icons.people,
                    caption: introduction[1],
                    onTap: () {
                      goNext();
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.teal[100].withOpacity(0.8),
                    border: Border.all(
                      color: Colors.teal[300],
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IntroductionText(
                    icon: Icons.business,
                    caption: introduction[2],
                    onTap: () {
                      goNext();
                    },
                  ),
                ),
              ],
            )),
            Container(
              color: Theme.of(context).primaryColorDark,
              height: 80,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: RaisedButton(
                  color: Colors.green[800],
                  onPressed: goNext,
                  child: Text('continue',
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

class IntroductionText extends StatelessWidget {
  final IconData icon;
  final String caption;
  final Function onTap;

  IntroductionText({
    @required this.icon,
    @required this.caption,
    @required this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          onTap();
        },
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            icon,
            size: 80,
          ),
          Text(
            caption,
            style: Theme.of(context).textTheme.caption,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
