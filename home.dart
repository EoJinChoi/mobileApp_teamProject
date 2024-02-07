import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_range_picker/time_range_picker.dart';

import 'reserve_info.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

enum SingingCharacter { soccer, basketball, tennis }
enum Yes_No { Yes, No }

class _HomePageState extends State<HomePage> {
  SingingCharacter? _character = SingingCharacter.soccer;
  Yes_No? _yes_no = Yes_No.No;
  final DateTime today = DateTime.now();
  DateTime select_date = DateTime.now();
  TimeRange result_time = TimeRange(startTime: TimeOfDay.now(), endTime: TimeOfDay.now());
  TextEditingController _total_num = TextEditingController(text: '0');
  TextEditingController _want_num = TextEditingController(text: '0');
  int total_num = 0;
  int want_num = 0;
  int current_num = 0;
  bool time_check = false;
  int reserve_check = 0;

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('HGU 운동시설 예약', style: TextStyle(fontWeight: FontWeight.bold),),
        backgroundColor: const Color.fromARGB(255, 136, 192, 255),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              // SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child:
                TextButton(
                  onPressed: (){FirebaseAuth.instance.signOut();},
                  child: Text("로그아웃", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 0, 76, 190)),)),),
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(250)),
                child: Image.network(
                  "https://img.freepik.com/free-vector/hands-holding-healthy-food-and-exercise-equipment-objects-for-marathon-training-or-workout-routine-on-blue-background-flat-vector-illustration-healthy-lifestyle-fitness-health-concept-for-banner_74855-23067.jpg?w=1480&t=st=1701171396~exp=1701171996~hmac=f527f14b2a3133aa219efd147a13f5db7d886c9569e05db15566a02f3538d71f",
                  fit: BoxFit.cover,
                  width: 150,
                  height: 150,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: DefaultTabController(
                  length: 4,
                  initialIndex: 0,
                  child: Column(
                    children: [
                      TabBar(
                        labelColor: Color.fromARGB(255, 135, 0, 197),
                        unselectedLabelColor: Color.fromARGB(255, 123, 123, 124),
                        indicatorColor: Color.fromARGB(255, 217, 183, 255),
                        tabs: [
                          Tab(
                            icon: Icon(Icons.table_view_outlined),
                          ),
                          Tab(
                            icon: Icon(Icons.chat_outlined),
                          ),
                          Tab(
                            icon: Icon(Icons.person_outline),
                          ),
                          Tab(
                            icon: Icon(Icons.people_outline),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            Column(
                              children: [
                                Padding(padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                                child: 
                                  Row(children: [
                                    Icon(Icons.place, color: Color.fromARGB(255, 135, 0, 197),),
                                    Text(" 운동시설 장소 선택",
                                    style: TextStyle(fontSize: 16),
                                    ),
                                  ],),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                                  child: Row(
                                    children: [
                                      Radio<SingingCharacter>(
                                        value: SingingCharacter.soccer,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                          });
                                        },
                                        activeColor: Color.fromARGB(255, 136, 192, 255),
                                      ),
                                      Column(
                                        children: [
                                          Icon(Icons.sports_soccer, size: 30, color: Color.fromARGB(255, 0, 76, 190)),
                                          Text("soccer"),
                                        ],
                                      ),
                                      SizedBox(width: 15),
                                      Radio<SingingCharacter>(
                                        value: SingingCharacter.basketball,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                          });
                                        },
                                        activeColor: Color.fromARGB(255, 136, 192, 255),
                                      ),
                                      Column(
                                        children: [
                                          Icon(Icons.sports_basketball, size: 30, color: Color.fromARGB(255, 0, 76, 190)),
                                          Text("Basketball"),
                                        ],
                                      ),
                                      SizedBox(width: 15),
                                      Radio<SingingCharacter>(
                                        value: SingingCharacter.tennis,
                                        groupValue: _character,
                                        onChanged: (SingingCharacter? value) {
                                          setState(() {
                                            _character = value;
                                          });
                                        },
                                        activeColor: Color.fromARGB(255, 136, 192, 255),
                                      ),
                                      Column(
                                        children: [
                                          Icon(Icons.sports_tennis, size: 30, color: Color.fromARGB(255, 0, 76, 190),),
                                          Text("Tennis"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                                child: 
                                  Row(children: [
                                    Icon(Icons.calendar_month_outlined, color: Color.fromARGB(255, 135, 0, 197),),
                                    Text(" 날짜 및 시간 선택",
                                    style: TextStyle(fontSize: 16),
                                    ),
                                  ],),
                                ),
                                Padding(padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child:
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime.now(),
                                          lastDate: DateTime(DateTime.now().year, DateTime.now().month + 2),
                                          builder: (BuildContext context, Widget? child) {
                                            return Theme(
                                              data: ThemeData.light().copyWith(
                                                primaryColor: const Color.fromARGB(255, 186, 224, 255), // 선택된 날짜의 배경 색상
                                                colorScheme: ColorScheme.light(primary: Color.fromARGB(255, 79, 167, 238)), // 달력의 주 헤더 색상
                                                buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary), // 버튼 텍스트의 색상
                                              ),
                                              child: child!,
                                            );
                                          },
                                          selectableDayPredicate: (date) {
                                            return date.isBefore(today.add(Duration(days: 30)));
                                          },
                                        ).then((selectedDate) {
                                          if (selectedDate != null) {
                                            setState(() {
                                              select_date = selectedDate;
                                            });
                                            print(select_date);
                                          }
                                        });
                                      },
                                      child: Text("Date", style: TextStyle(color: Color.fromARGB(255, 135, 0, 197),)),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color.fromARGB(255, 217, 183, 255),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text('선택된 날짜: ${select_date.year}-${select_date.month}-${select_date.day}')
                                  ],
                                ),
                                ),
                                Padding(padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child:
                                Row(
                                  children: [
                                    TextButton(onPressed: ()
                                      async {
                                        // List<TimeRange> disabledTimeRanges = await getTimeList();
                                        // List<QueryDocumentSnapshot> reservationDocs = await getReservationDocuments();
                                        
                                        TimeRange result = await showTimeRangePicker(
                                          context: context,
                                          ticks: 12,
                                          ticksColor: Colors.white,
                                          labels: [
                                            "00",
                                            "02",
                                            "04",
                                            "06",
                                            "08",
                                            "10",
                                            "12",
                                            "14",
                                            "16",
                                            "18",
                                            "20",
                                            "22",
                                          ].asMap().entries.map((e) {
                                            return ClockLabel.fromIndex(
                                                idx: e.key, length: 12, text: e.value);
                                          }).toList(),
                                          labelOffset: -30,
                                          maxDuration: const Duration(hours: 2),
                                          clockRotation: 180.0,
                                        );
                                        // print("result " + result.toString());
                                        // int result_start_min = result.startTime.hour * 60 + result.startTime.minute;
                                        // int result_end_min = result.endTime.hour * 60 + result.endTime.minute;

                                        // for(TimeRange time in disabledTimeRanges)
                                        // {
                                        //   // print("time " + time.toString());
                                        //   int time_start_min = time.startTime.hour * 60 + time.startTime.minute;
                                        //   int time_end_min = time.endTime.hour * 60 + time.endTime.minute;
                                        //   if((time_start_min <= result_start_min && time_end_min >= result_start_min)
                                        //       || (time_start_min <= result_end_min && time_end_min >= result_end_min)
                                        //       || (time_start_min >= result_start_min && time_end_min <= result_end_min)
                                        //     ){
                                        //     time_check = true;
                                        //   }
                                        // }

                                        // for (var doc in reservationDocs) {
                                        //   // 각 문서에서 데이터를 가져옵니다.
                                        //   Map<String, dynamic> data = doc as Map<String, dynamic>;
                                        //   // 필요한 필드를 가져와서 원하는 작업을 수행합니다.
                                        //   var date = data['date'];
                                        //   var selectTime = data['selectTime'];
                                        //   var place = data['place'];
                                        //   // print(_character);
                                        //   print("place" + place);
                                        //   if((place == _character) && (date == select_date) && (time_check)){
                                        //     ScaffoldMessenger.of(context).showSnackBar(
                                        //       SnackBar(
                                        //         content: Text("이미 예약된 시간입니다. ${selectTime.startTime.hour}:${selectTime.startTime.minute} ~ ${selectTime.endTime.hour}:${selectTime.endTime.minute} 시간에 예약이 있습니다."),
                                        //       ),
                                        //     );
                                        //     return;
                                        //   }
                                        // }

                                        setState(() {
                                          result_time = result;
                                        });
                                      },
                                      child: Text("Time", style: TextStyle(color: Color.fromARGB(255, 135, 0, 197))),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color.fromARGB(255, 217, 183, 255),
                                      ),
                                    ),
                                    SizedBox(width: 10), 
                                    Text('선택된 시간: ${result_time.startTime.hour}:${result_time.startTime.minute} ~ ${result_time.endTime.hour}:${result_time.endTime.minute}'),
                                  ],
                                ),
                                ),
                                Padding(padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
                                child: 
                                  Row(children: [
                                    Icon(Icons.people_alt_outlined, color: Color.fromARGB(255, 135, 0, 197),),
                                    Text(" 예약 인원",
                                    style: TextStyle(fontSize: 16),
                                    ),
                                  ],),
                                ),
                                Padding(padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                child:
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10,),
                                      Text("현재 인원 : "),
                                      SizedBox(width: 8,),
                                      SizedBox(
                                        width: 55,
                                        height: 30,
                                        child: TextField(
                                          textAlignVertical: TextAlignVertical(y: -0.5),
                                          controller: _total_num,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Text("명"), 
                                    ],
                                  ),
                                ),
                                ),
                                Padding(padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                                child:
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    children: [
                                      SizedBox(width: 10,),
                                      Text("모으기 희망 인원 : "),
                                      SizedBox(width: 8,),
                                      SizedBox(
                                        width: 55,
                                        height: 30,
                                        child: TextField(
                                          textAlignVertical: TextAlignVertical(y: -0.5),
                                          controller: _want_num,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Text("명"),
                                    ],
                                  ),
                                ),
                                ),
                                Padding(padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                child:
                                Row(
                                  children: [
                                    Text("예"),
                                    Radio<Yes_No>(
                                      value: Yes_No.Yes,
                                      groupValue: _yes_no,
                                      onChanged: (Yes_No? value) {
                                        setState(() {
                                          _yes_no = value;
                                        });
                                      },
                                      activeColor: Color.fromARGB(255, 136, 192, 255),
                                    ),
                                    Text("/   아니요"),
                                    Radio<Yes_No>(
                                      value: Yes_No.No,
                                      groupValue: _yes_no,
                                      onChanged: (Yes_No? value) {
                                        setState(() {
                                          _yes_no = value;
                                        });
                                      },
                                      activeColor: Color.fromARGB(255, 136, 192, 255),
                                    ),
                                  ],
                                ),
                                ),
                                SizedBox(height: 15),
                                TextButton(
                                  onPressed: () async {
                                    List<TimeRange> disabledTimeRanges = await getTimeList();
                                    List<QueryDocumentSnapshot> reservationDocs = await getReservationDocuments();

                                    int result_start_min = result_time.startTime.hour * 60 + result_time.startTime.minute;
                                    int result_end_min = result_time.endTime.hour * 60 + result_time.endTime.minute;

                                    print(disabledTimeRanges);
                                    for(TimeRange time in disabledTimeRanges)
                                    {
                                      print("time : " + time.toString());
                                      int time_start_min = time.startTime.hour * 60 + time.startTime.minute;
                                      int time_end_min = time.endTime.hour * 60 + time.endTime.minute;
                                      if((time_start_min <= result_start_min && time_end_min >= result_start_min)
                                          || (time_start_min <= result_end_min && time_end_min >= result_end_min)
                                          || (time_start_min >= result_start_min && time_end_min <= result_end_min)
                                        ){
                                        time_check = true;
                                      }
                                    }
                                    print(reservationDocs);
                                    for (var doc in reservationDocs) {
                                      // 각 문서에서 데이터를 가져옵니다.
                                      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                                      // 필요한 필드를 가져와서 원하는 작업을 수행합니다.
                                      var date = data['date'];
                                      var selectTime = data['selectTime'];
                                      var place = data['place'];
                                      String characterString = _character.toString().split('.').last;
                                      DateTime dateFromFirebase = (data['date'] as Timestamp).toDate();
                                      // print(_character);
                                      print("place : " + place + ", characterString : " + characterString);
                                      print("date : " + dateFromFirebase.toString() + ", select_date : " + select_date.toString());
                                      print("time_check : " + time_check.toString());
                                      if((place == characterString) && (dateFromFirebase == select_date) && (time_check)){
                                        reserve_check = 1;
                                        break;
                                      }
                                      if((today.hour*60+today.minute >= result_start_min) && (today.month == select_date.month) && (today.day == select_date.day)){
                                        reserve_check = 2;
                                      }
                                    }
                                    if(reserve_check == 1){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("이미 예약된 시간입니다."),
                                        ),
                                      );
                                      return;
                                    } else if(reserve_check == 2){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("현시간보다 이전 시간은 예약이 불가능합니다."),
                                        ),
                                      );
                                      return;
                                    } else {
                                      total_num = int.parse(_total_num.text);
                                      want_num = int.parse(_want_num.text);
                                      current_num = total_num;
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            backgroundColor: Color.fromARGB(255, 210, 231, 255),
                                            title: Text('예약 확인'),
                                            content: SingleChildScrollView(child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("예약 장소: "),
                                                    Text(getReservationLocationString(_character)),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text("예약 날짜: "),
                                                    Text('${select_date.year}년 ${select_date.month}월 ${select_date.day}일'),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text("예약 시간: "),
                                                    Text('${result_time.startTime.hour}시 ${result_time.startTime.minute}분 ~ ${result_time.endTime.hour}시 ${result_time.endTime.minute}분'),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text("현재 인원: "),
                                                    Text('${total_num}명'),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Text("모으기 희망 인원: "),
                                                    Text('${want_num}명'),

                                                  ],
                                                ),
                                              ],
                                            )),
                                            actions: [
                                              TextButton(
                                                onPressed: () async {
                                                  await addReservationToFirebase(
                                                    ReserveInfo(
                                                      user!.uid ,
                                                      user!.displayName as String,
                                                      getReservationLocationString(_character),
                                                      select_date,
                                                      result_time,
                                                      total_num,
                                                      want_num,
                                                      current_num,
                                                      getReservationWantString(_yes_no),
                                                    ),
                                                  );
                                                  _total_num.clear();
                                                  _want_num.clear();
                                                  setState(() {
                                                    select_date = DateTime.now();
                                                    result_time = TimeRange(startTime: TimeOfDay.now(), endTime: TimeOfDay.now());
                                                    _character = SingingCharacter.soccer;
                                                    _yes_no = Yes_No.No;
                                                  });
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text("예약되었습니다."),
                                                      ),
                                                    );
                                                    return;
                                                },
                                                child: Text('예약', style: TextStyle(color: Color.fromARGB(255, 0, 76, 190), fontSize: 18, ),),
                                                style: TextButton.styleFrom(
                                                  minimumSize: Size(80, 30),
                                                  backgroundColor: Color.fromARGB(255, 136, 192, 255),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                      };
                                  },
                                  child: const Text("예약하기", style: TextStyle(color: Color.fromARGB(255, 0, 76, 190), fontSize: 20, fontWeight: FontWeight.bold),),
                                  style: TextButton.styleFrom(
                                    minimumSize: Size(130, 40),
                                    backgroundColor: Color.fromARGB(255, 136, 192, 255),
                                  ),
                                ),
                              ],
                            ),
                            SecondTab(userId: user!.uid),
                            ProfileTab(userId: user!.uid),
                            JoinedTab(userId: user!.uid),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<List<QueryDocumentSnapshot>> getReservationDocuments() async {
    CollectionReference reservationCollection = FirebaseFirestore.instance.collection('reservations');
    QuerySnapshot reservationSnapshot = await reservationCollection.get();
    return reservationSnapshot.docs;
  }

  String getReservationLocationString(SingingCharacter? character) {
    switch (character) {
      case SingingCharacter.soccer:
        return "soccer";
      case SingingCharacter.basketball:
        return "basketball";
      case SingingCharacter.tennis:
        return "tennis";
      default:
        return "";
    }
  }
  String getReservationWantString(Yes_No? character) {
    switch (character) {
      case Yes_No.Yes:
        return "Yes";
      case Yes_No.No:
        return "No";
      default:
        return "";
    }
  }

  Future<List<TimeRange>> getTimeList() async {
    List<TimeRange> timeList = [];

    try {
      CollectionReference reservationCollection =
      FirebaseFirestore.instance.collection('reservations');

      QuerySnapshot reservationSnapshot = await reservationCollection.get();
      for (QueryDocumentSnapshot reservationDocument
          in reservationSnapshot.docs) {
        Map<String, dynamic> reservationData = reservationDocument.data()
            as Map<String, dynamic>;
        
        TimeRange timeRange = TimeRange(
          startTime: TimeOfDay(
            hour: reservationData['selectTime']['startTime']['hour'],
            minute: reservationData['selectTime']['startTime']['minute'],
          ),
          endTime: TimeOfDay(
            hour: reservationData['selectTime']['endTime']['hour'],
            minute: reservationData['selectTime']['endTime']['minute'],
          ),
        );

        timeList.add(timeRange);
      }
    } catch (e) {
      print('Error fetching time list: $e');
    }

    return timeList;
  }

  Future<void> addReservationToFirebase(ReserveInfo reservationInfo) async {
    try {
      await FirebaseFirestore.instance.collection('reservations').add({
        'id': reservationInfo.id,
        'name': reservationInfo.name,
        'place': reservationInfo.place,
        'date': reservationInfo.date,
        'selectTime': {
          'startTime': {
            'hour': reservationInfo.selectTime.startTime.hour,
            'minute': reservationInfo.selectTime.startTime.minute,
          },
          'endTime': {
            'hour': reservationInfo.selectTime.endTime.hour,
            'minute': reservationInfo.selectTime.endTime.minute,
          },
        },
        'totalNum': reservationInfo.totalNum,
        'wantNum': reservationInfo.wantNum,
        'currentNum': reservationInfo.currentNum,
        'isWant': reservationInfo.isWant,
      });
    } catch (e) {
      print('Error adding reservation: $e');
    }
  }
}

class SecondTab extends StatelessWidget {

  final String userId;

  SecondTab({required this.userId});

  Future<DocumentSnapshot> getUserDocument() {
    return FirebaseFirestore.instance.collection('users').doc(userId).get();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('reservations').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return FutureBuilder<DocumentSnapshot>(
          future: getUserDocument(),
          builder: (context, userSnapshot) {
            if (!userSnapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            var userData = userSnapshot.data!.data() as Map<String, dynamic>;
            var joinedGames = userData['joinedGames'] as List<dynamic>;

            var reservations = snapshot.data!.docs;

        List<Widget> reservationWidgets = [];
        for (var reservation in reservations) {
          var reservationData = reservation.data() as Map<String, dynamic>;
          var id = reservationData['id'];
          var name = reservationData['name'];
          var place = reservationData['place'];
          var date = (reservationData['date'] as Timestamp).toDate();
          var startTime = reservationData['selectTime']['startTime'] as Map<String, dynamic>;
          var endTime = reservationData['selectTime']['endTime'] as Map<String, dynamic>;

          var startTimeOfDay = TimeOfDay(hour: startTime['hour'], minute: startTime['minute']);
          var endTimeOfDay = TimeOfDay(hour: endTime['hour'], minute: endTime['minute']);

          var formattedDate = "${date.year}-${date.month}-${date.day}";
          var formattedTime = "${startTimeOfDay.format(context)} - ${endTimeOfDay.format(context)}";

          var totalNum = reservationData['totalNum'];
          var wantNum = reservationData['wantNum'];
          var total = totalNum+wantNum;
          var currentNum = reservationData['currentNum'];
          var isWant = reservationData['isWant'];

          bool hasJoined = joinedGames.contains(reservation.id);

          if(isWant == "Yes" /*&& id != userId*/)
          {
            reservationWidgets.add(
              ListTile(
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('이름: $name', style: TextStyle(fontSize: 18),),
                    Text('장소: $place', style: TextStyle(fontSize: 18),),
                    Text('날짜: $formattedDate', style: TextStyle(fontSize: 18),),
                    Text('시간: $formattedTime', style: TextStyle(fontSize: 18),),
                    Text('인원: $currentNum / $total', style: TextStyle(fontSize: 18),),

                    (!hasJoined && currentNum < totalNum+wantNum && id != userId)?
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        onPressed: () async{
                          await updateCurrentNum(reservation.id, currentNum + 1);
                          FirebaseFirestore.instance.collection('users').doc(userId).update({
                            'joinedGames': FieldValue.arrayUnion([reservation.id]),
                          });
                        },
                        child: Text("같이하기", style: TextStyle(color: Color.fromARGB(255, 0, 76, 190), fontSize: 16,),),
                                  style: TextButton.styleFrom(
                                    minimumSize: Size(90, 40),
                                    backgroundColor: Color.fromARGB(255, 136, 192, 255),),
                      ),
                    )
                    :Text(""),
                    SizedBox(height: 10,),
                    Divider(thickness: 1, height: 1, color: Colors.black),
                  ],
                ),
              ),
            );
          }
        }
        return ListView(
          children: reservationWidgets,
        );
          },
        );
      },
    );
  }

  Future<void> updateCurrentNum(String id, int newCurrentNum) async {
    try {
      await FirebaseFirestore.instance.collection('reservations').doc(id).update({
        'currentNum': newCurrentNum,
      });
    } catch (e) {
      print('Error updating reservation: $e');
    }
  }

}

class ProfileTab extends StatelessWidget {

  final String userId;
  ProfileTab({required this.userId});

  Future<DocumentSnapshot> getGameDocument(String docId) {
    return FirebaseFirestore.instance.collection('reservations').doc(docId).get();
  }

  @override
  Widget build(BuildContext context) {
     User? user = FirebaseAuth.instance.currentUser;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('reservations').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

          var reservations = snapshot.data!.docs;

          List<Widget> reservationWidgets = [];
          for (var reservation in reservations) {
            var reservationData = reservation.data() as Map<String, dynamic>;
            var id = reservationData['id'];
            var name = reservationData['name'];
            var place = reservationData['place'];
            var date = (reservationData['date'] as Timestamp).toDate();
            var startTime = reservationData['selectTime']['startTime'] as Map<String, dynamic>;
            var endTime = reservationData['selectTime']['endTime'] as Map<String, dynamic>;

            var startTimeOfDay = TimeOfDay(hour: startTime['hour'], minute: startTime['minute']);
            var endTimeOfDay = TimeOfDay(hour: endTime['hour'], minute: endTime['minute']);

            var formattedDate = "${date.year}-${date.month}-${date.day}";
            var formattedTime = "${startTimeOfDay.format(context)} - ${endTimeOfDay.format(context)}";

            var totalNum = reservationData['totalNum'];
            var wantNum = reservationData['wantNum'];
            var total = totalNum+wantNum;
            var currentNum = reservationData['currentNum'];
            var isWant = reservationData['isWant'];

            if(id == user!.uid)
            {
              reservationWidgets.add(
                ListTile(
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('이름: $name',style: TextStyle(fontSize: 18),),
                      Text('장소: $place',style: TextStyle(fontSize: 18),),
                      Text('날짜: $formattedDate',style: TextStyle(fontSize: 18),),
                      Text('시간: $formattedTime',style: TextStyle(fontSize: 18),),
                      Text('인원: $currentNum / $total',style: TextStyle(fontSize: 18),),
                      Align(
                      alignment: Alignment.bottomRight,
                      child:TextButton(
                        onPressed: () async{
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                backgroundColor: Color.fromARGB(255, 210, 231, 255),
                                title: Text('취소하시겠습니까?', style: TextStyle(fontWeight: FontWeight.w500),),
                                content: SingleChildScrollView(child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                )),
                                actions: [
                                    Row(
                                      children: [
                                        SizedBox(width: 100,),
                                        TextButton(
                                          onPressed: () async {
                                            FirebaseFirestore.instance.collection('reservations').doc(reservation.id).delete();
                                            Navigator.pop(context);
                                          },
                                          child: Text('예', style: TextStyle(color: Color.fromARGB(255, 0, 76, 190), fontSize: 18, ),),
                                          style: TextButton.styleFrom(
                                            minimumSize: Size(70, 30),
                                            backgroundColor: Color.fromARGB(255, 136, 192, 255),
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                          },
                                          child: Text('아니요', style: TextStyle(color: Color.fromARGB(255, 0, 76, 190), fontSize: 18, ),),
                                          style: TextButton.styleFrom(
                                            minimumSize: Size(70, 30),
                                            backgroundColor: Color.fromARGB(255, 136, 192, 255),
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text("취소하기", style: TextStyle(color: Color.fromARGB(255, 0, 76, 190), fontSize: 16,),),
                                  style: TextButton.styleFrom(
                                    minimumSize: Size(90, 40),
                                    backgroundColor: Color.fromARGB(255, 136, 192, 255),),
                      ),
                      ),
                      SizedBox(height: 10,),
                      Divider(thickness: 1, height: 1, color: Colors.black),
                    ],
                  ),
                ),
              );
            }
          }

        return ListView(
          children: reservationWidgets,
        );
      },
    );
  }
}

class JoinedTab extends StatelessWidget {
  final String userId;

  JoinedTab({required this.userId});

  Future<DocumentSnapshot> getUserDocument() {
    return FirebaseFirestore.instance.collection('users').doc(userId).get();
  }

  Future<DocumentSnapshot> getReservationDocument(String docId) {
    return FirebaseFirestore.instance.collection('reservations').doc(docId).get();
  }

  Future<List<Widget>> fetchData(List<dynamic> joinedGames, BuildContext context) async {
    List<Widget> reservationWidgets = [];

    for (var join in joinedGames) {
      var reservationDoc = await getReservationDocument(join);
      if (reservationDoc.exists) {
        var reservationData = reservationDoc.data() as Map<String, dynamic>;
        var name = reservationData['name'];
        var place = reservationData['place'];
        var date = (reservationData['date'] as Timestamp).toDate();
        var startTime = reservationData['selectTime']['startTime'] as Map<String, dynamic>;
        var endTime = reservationData['selectTime']['endTime'] as Map<String, dynamic>;

        var startTimeOfDay = TimeOfDay(hour: startTime['hour'], minute: startTime['minute']);
        var endTimeOfDay = TimeOfDay(hour: endTime['hour'], minute: endTime['minute']);

        var formattedDate = "${date.year}-${date.month}-${date.day}";
        var formattedTime = "${startTimeOfDay.format(context)} - ${endTimeOfDay.format(context)}";

        var totalNum = reservationData['totalNum'];
        var wantNum = reservationData['wantNum'];
        var total = totalNum + wantNum;
        var currentNum = reservationData['currentNum'];

        reservationWidgets.add(
          ListTile(
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('이름: $name', style: TextStyle(fontSize: 18),),
                Text('장소: $place', style: TextStyle(fontSize: 18),),
                Text('날짜: $formattedDate', style: TextStyle(fontSize: 18),),
                Text('시간: $formattedTime', style: TextStyle(fontSize: 18),),
                Text('인원: $currentNum / $total', style: TextStyle(fontSize: 18),),
              ],
            ),
          ),
        );
      }
    }

    return reservationWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: getUserDocument(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        var userData = userSnapshot.data!.data() as Map<String, dynamic>;
        var joinedGames = userData['joinedGames'] as List<dynamic>;

        return FutureBuilder<List<Widget>>(
          future: fetchData(joinedGames, context),
          builder: (context, dataSnapshot) {
            if (!dataSnapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            var reservationWidgets = dataSnapshot.data!;

            return ListView(
              children: reservationWidgets,
            );
          },
        );
      },
    );
  }
}

