import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:scheduled_notifications/scheduled_notifications.dart';

// import 'package:google_fonts/google_fonts.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstPage(),
      theme: ThemeData(
        primaryColor: Colors.red,
        fontFamily: 'McLaren',
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class FirstPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FirstPageState();
  }
}

class _FirstPageState extends State<FirstPage> {
  String text;
  Future<SharedPreferences> prefs =  SharedPreferences.getInstance();
  List<String> list = <String>[];
  // List<TimeOfDay> timelist = new List<TimeOfDay>();
  List<String> timelistString = <String>[];
  FlutterLocalNotificationsPlugin localNotificationsPlugin = FlutterLocalNotificationsPlugin();

   initializeNotifications() async {
    var initializeAndroid = AndroidInitializationSettings('app_icon');
    var initializeIOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(initializeAndroid, initializeIOS);
    await localNotificationsPlugin.initialize(initSettings);
  }

  @override
  void initState() {
    super.initState();
    initializeNotifications();
  }

  Future singleNotification(
      DateTime datetime, String message, String subtext, int hashcode,
      {String sound}) async {
    var androidChannel = AndroidNotificationDetails(
      'channel-id',
      'channel-name',
      'channel-description',
      importance: Importance.Max,
      priority: Priority.Max,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    localNotificationsPlugin.schedule(
        hashcode, message, subtext, datetime, platformChannel,
        payload: hashcode.toString());
  }

  TextEditingController _textFieldController = TextEditingController();
  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay picked;
  // SharedPreferences prefs;

  // void _saveList() async {
  //   await prefs.setStringList("list", list);
  // }

  // Future<List<String>> _getListTime() async{
  //   await prefs.getStringList("timelist");
  // }

  // void _saveListTime() async {
  //  await prefs.setStringList("timelist", timelistString);
  // }

  // Future<List<String>> _getList() async{
  //   await  prefs.getStringList("list");
  // }

  // _getMethod() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if(prefs.containsKey('list'))
  //     list = prefs.getStringList('list');
  //   else
  //     list = new List<String>();
  //   if(prefs.containsKey('timelist'))
  //     timelistString = prefs.getStringList('timelist');
  //   else
  //     timelistString = new List<String>();
  // }

  // _setMethod() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setStringList('list', list);
  //   prefs.setStringList('timelist', timelistString);
  // }

  _sharedprefs(String actiponType) async {
    SharedPreferences _prefs = await prefs;
    if(actiponType == "GET"){
      list = _prefs.getStringList('list')??<String>[];
      timelistString = _prefs.getStringList('timelist')??<String>[]; 
    }
    else if(actiponType == "SAVE")
    {
      _prefs.setStringList('list', list);
      _prefs.setStringList('timelist', timelistString);
      // ignore: deprecated_member_use
      _prefs.commit();
    }
    print(_prefs.getKeys());
  }



  Future<Null> selectTime(BuildContext context, int index) async {
      picked = await showTimePicker(
      context: context,
      initialTime: _time,
      
    );
    setState(() {
      _time = picked;
      print(_time);
      // timelist.insert(index, _time);
      var time = _time.toString().substring(10,15);
      timelistString.insert(index, time);
      _sharedprefs("SAVE");
      // _scheduleNotification();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    // list = _getList();
    // timelistString = _getListTime();
  //  _getMethod();
  _sharedprefs("GET");
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("DOiNG")),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: TextField(
                keyboardType: TextInputType.text,
                controller: _textFieldController,
                // cursorColor: Colors.red,
                // cursorRadius: Radius.circular(16.0),
                // cursorWidth: 16.0,
                textCapitalization: TextCapitalization.sentences,
                maxLength: 27,

                decoration: InputDecoration(
                  // border: InputBorder.none,
                  fillColor: Colors.grey[200],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                  labelText: "Enter your tasks",
                  suffix: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          if (list.length < 6 &&
                              _textFieldController.text.length > 0) {
                            list.add(_textFieldController.text);
                            // timelist.add(TimeOfDay(hour: -1, minute: -1));                      
                            timelistString.add(TimeOfDay(hour: -1, minute: -1).toString().substring(10, 15));
                            _textFieldController.text = "";
                            _sharedprefs("SAVE");
                            FocusScope.of(context).unfocus();
//                           _textFieldController.text=null;
                          } else if (list.length >= 6) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  title: new Text("OOPS :("),
                                  content: new Text("Too many tasks scheduled"),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    new FlatButton(
                                      child: new Text("CLOSE"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                // return object of type Dialog
                                return AlertDialog(
                                  title: new Text("OOPS :("),
                                  content: new Text(
                                      "Nothing is impossible - to be a task also"),
                                  actions: <Widget>[
                                    // usually buttons at the bottom of the dialog
                                    new FlatButton(
                                      child: new Text("CLOSE"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          // text="";
                        });
                      }),
                ),
              ),
            ),
        //     Container(
        //       child: RaisedButton(          
        //   child: new Text('Click me'), onPressed: ()  async {
        //   DateTime now = DateTime.now().toUtc().add(
        //         Duration(seconds: 3),
        //       );
        //   await singleNotification(
        //     now,
        //     "DOiNG",
        //     "Good morning",
        //     98123871,
        //   );
        // },
        // )
        //     ),
            new Container(
              child:  (list.length == 0)
                  ? new Container(
                      height: MediaQuery.of(context).size.height / 1.5,
                      child: Center(
                        child: Text("All caught up :)".toUpperCase()),
                      ))
                  : 
                  new Container(
                      // color: const Color(0xFF00FF00),
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            final item = list[index];
                            return Dismissible(
                                key: Key(item),
                                onDismissed: (direction) {
                                  // Remove the item from the data source.
                                  setState(()  {                                    
                                    localNotificationsPlugin.cancel(index);
                                    list.removeAt(index);
                                    // timelist.removeAt(index);
                                    timelistString.remove(index);  
                                    _sharedprefs("SAVE");                            
                                  });

                                  // Then show a snackbar.
                                  Scaffold.of(context).showSnackBar(SnackBar(
//                             margin: new EdgeInsets.only(
//                         left: 20.0, right: 20.0, top: 8.0, bottom: 5.0),
                                      duration: const Duration(seconds:1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20),
                                        ),
                                      ),
                                      content:
                                          Text("$item - task is dismissed")));
                                },
                                child: new Card(
                                  margin: new EdgeInsets.only(
                                      left: 20.0,
                                      right: 20.0,
                                      top: 8.0,
                                      bottom: 5.0),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  elevation: 4.0,
                                  color: Colors.yellow[300],
//                           margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                           elevation: 1,
                                  child: ListTile(
                                    title: Text(list[index].toUpperCase()),
                                    // subtitle: Text(timelist[index]
                                    //     .toString()
                                    //     .substring(10, 15)),
                                    subtitle: timelistString[index][0] == '-'
                                    ?
                                    new Text("Unscheduled")
                                    :
                                    Text(timelistString[index]),
                                    dense: true,
                                    trailing: IconButton(
                                      icon: Icon(Icons.notifications),
                                      onPressed: () async {
                                        selectTime(context, index);
//                                 timelist.insert(index,_time);
                                        print(_time);
                                        // var temp = timelist[index].toString()
                                        // .substring(10, 15);
                                        // timelistString.add(temp);
//                                 timelist.insert(index,_time);
//                                 list.removeAt(index);
                                    var hh = _time.hour;
                                    var mm = _time.minute;                                    
                                    DateTime now = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hh, mm);
                                              await singleNotification(
                                                now,
                                                "You have a task",
                                                (list[index]),
                                                // int.parse(index.toString()),
                                                // 98123871,
                                                index,
                                                // int.parse(s),
                                              );
                                      },
                                    ),
                                  ),
                                ));
                          }),
                    ),
              
            ),          
          ],
        ),
      )),
    );
  }
}
//end of code