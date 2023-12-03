import 'package:calendar_app/Events.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime?, List<Events>> events = {};

  TextEditingController eventNameController = TextEditingController();
  TextEditingController eventInfoController = TextEditingController();
  TextEditingController venueController = TextEditingController();

  late final ValueNotifier<List<Events>> _selectedEvents;



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDay = _focusDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    eventNameController.dispose();
    eventInfoController.dispose();
    venueController.dispose();
  }

  List<Events> _getEventsForDay(DateTime day){
    return events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusDay = focusedDay;
          _selectedEvents.value =_getEventsForDay(_selectedDay!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('Enter event details'),
                  content: Padding(
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        TextFormField(controller: eventNameController),
                        TextFormField(controller: eventInfoController),
                        TextFormField(controller: venueController),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          events.addAll({
                            _selectedDay: [
                              Events(
                                  eventName: eventNameController.text.trim(),
                                  eventInfo: eventInfoController.text.trim(),
                                  venue: venueController.text.trim())
                            ]
                          });
                          Navigator.of(context).pop();
                          _selectedEvents.value =_getEventsForDay(_selectedDay!);
                        },
                        child: const Text('Submit'))
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2023, 01, 01),
                lastDay: DateTime.utc(2100, 12, 31),
                focusedDay: _focusDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: _onDaySelected,
                eventLoader: _getEventsForDay,
              ),
              const SizedBox(height: 20,),
              Expanded(
                child: ValueListenableBuilder(valueListenable: _selectedEvents, builder: (context,value,_){
                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context,i){
                    return Container(
                      margin: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(onTap: ()=>print(""),
                      title:Text('${value[i].eventName}') ,),
                    );
              
                  });
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
