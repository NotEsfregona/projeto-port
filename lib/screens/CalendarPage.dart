import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:firebase_database/firebase_database.dart';
import 'EventPage.dart'; // Importa a classe EventPage

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late DateTime _today;
  Map<DateTime, List<String>> _events = {};

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _today = DateTime.now();
    _focusedDay = _today;
    _selectedDay = _today;

    // Busca os eventos ao iniciar a página
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    DatabaseReference eventsRef = FirebaseDatabase.instance.ref('events');

    try {
      var snapshot = await eventsRef.get();
      if (snapshot.value != null && snapshot.value is Map<dynamic, dynamic>) {
        Map<dynamic, dynamic> values = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          _events.clear(); // Limpa os eventos existentes
          values.forEach((key, value) {
            if (value is Map<dynamic, dynamic>) {
              DateTime startTime = DateTime.parse(value['startTime']);
              DateTime endTime = DateTime.parse(value['endTime']);
              String type = value['type'];
              DateTime date =
                  DateTime(startTime.year, startTime.month, startTime.day);

              // Adiciona o evento à lista de eventos para o dia correto
              if (_events.containsKey(date)) {
                _events[date]!.add(
                    '$type - Das ${DateFormat.Hm().format(startTime)} até ${DateFormat.Hm().format(endTime)}');
              } else {
                _events[date] = [
                  '$type - Das ${DateFormat.Hm().format(startTime)} até ${DateFormat.Hm().format(endTime)}'
                ];
              }
            }
          });
        });
      }
    } catch (error) {
      print('Erro ao buscar eventos: $error');
    }
  }

  bool _isWeekday(DateTime day) {
    // Verifica se o dia é segunda a sexta-feira (1 a 5 correspondem aos dias da semana)
    return day.weekday >= 1 && day.weekday <= 5;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Colors.grey.shade400,
                  width: 2.0,
                ),
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              headerStyle: const HeaderStyle(
                titleCentered: true,
                formatButtonVisible: false,
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                weekendTextStyle: const TextStyle(color: Colors.grey),
                selectedDecoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color.fromARGB(255, 255, 130, 121),
                ),
                selectedTextStyle: const TextStyle(color: Colors.white),
                todayTextStyle: const TextStyle(
                    color: Color.fromARGB(255, 255, 130, 121),
                    fontWeight: FontWeight.w600),
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(color: Colors.transparent, width: 2),
                ),
              ),
              selectedDayPredicate: (day) {
                return isSameDay(day, _selectedDay);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (_isWeekday(selectedDay)) {
                  setState(() {
                    _selectedDay = DateTime(
                        selectedDay.year, selectedDay.month, selectedDay.day);
                  });
                } else {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.info,
                    animType: AnimType.topSlide,
                    showCloseIcon: true,
                    desc: 'Selecione apenas dias da semana (segunda a sexta-feira).',
                    btnOkOnPress: () {},
                    btnOkColor: Colors.blue,
                  ).show();
                }
              },
              availableCalendarFormats: const {
                CalendarFormat.month: 'Mês',
                CalendarFormat.week: 'Semana',
              },
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Eventos de ${DateFormat('dd/MM/yyyy').format(_selectedDay)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _events[_selectedDay]?.isNotEmpty == true
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: _events[_selectedDay]!
                                .map((event) => Container(
                                      margin: const EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.3),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ListTile(
                                        title: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Text(
                                            event,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          )
                        : const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 20),
                              Center(
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.event_busy_rounded,
                                      size: 140,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Não há eventos para este dia',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90.0), 
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventPage(
                  selectedDay: _selectedDay,
                ),
              ),
            ).then((value) {
              // Após adicionar o evento, atualize a lista de eventos
              _fetchEvents();
            });
          },
          backgroundColor: const Color.fromARGB(255, 255, 130, 121),
          child: const Icon(Icons.my_library_add_outlined, color: Colors.white),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
