import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class EventPage extends StatefulWidget {
  final DateTime selectedDay;

  EventPage({Key? key, required this.selectedDay}) : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late TimeOfDay _selectedStartTime;
  late TimeOfDay _selectedEndTime;
  late String _eventType;
  final _eventTypeOptions = ['Campo', 'Sala de Fitness'];
  final _database = FirebaseDatabase.instance.ref('events');
  final Map<DateTime, List<String>> _events = {};

  // Estados locais para controle de seleção dos tipos de evento
  bool isSelectedCampo = true;
  bool isSelectedSalaFitness = false;

  @override
  void initState() {
    super.initState();
    _selectedStartTime = const TimeOfDay(hour: 9, minute: 30);
    _selectedEndTime = const TimeOfDay(hour: 22, minute: 30);
    _eventType = _eventTypeOptions[0]; // Default: Campo

    // Buscar eventos do banco de dados ao iniciar o widget
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    try {
      DataSnapshot snapshot = await _database.get();
      if (snapshot.value != null) {
        Map<dynamic, dynamic>? eventsData = snapshot.value as Map<dynamic, dynamic>?;

        if (eventsData != null) {
          setState(() {
            _events.clear(); // Limpa os eventos existentes
            eventsData.forEach((key, value) {
              if (value is Map<dynamic, dynamic>) {
                DateTime startTime = DateTime.parse(value['startTime']);
                DateTime endTime = DateTime.parse(value['endTime']);
                String type = value['type'];
                DateTime date = DateTime(startTime.year, startTime.month, startTime.day);

                // Adiciona o evento à lista de eventos para o dia correto
                if (_events.containsKey(date)) {
                  _events[date]!.add(
                    '$type - Das ${DateFormat.Hm().format(startTime)} até ${DateFormat.Hm().format(endTime)}'
                  );
                } else {
                  _events[date] = [
                    '$type - Das ${DateFormat.Hm().format(startTime)} até ${DateFormat.Hm().format(endTime)}'
                  ];
                }
              }
            });
          });
        }
      }
    } catch (error) {
      print('Erro ao buscar eventos: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center( // Centralizar o conteúdo
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Alinhar no centro
            children: [
              Text(
                'Dia Selecionado: ${DateFormat('dd/MM/yyyy').format(widget.selectedDay)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 50), // Adicionado SizedBox
              Row(
                mainAxisAlignment: MainAxisAlignment.center, // Centralizar a linha
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelectedCampo = true;
                        isSelectedSalaFitness = false;
                        _eventType = _eventTypeOptions[0]; // Campo
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelectedCampo ? Colors.white : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: isSelectedCampo
                            ? [
                                const BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 3,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/icons/campo-ips.jpg', // Caminho da imagem do campo
                            width: 150,
                            height: 150,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Campo',
                            style: TextStyle(
                              color: isSelectedCampo ? const Color.fromARGB(255, 255, 130, 121) : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 40),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSelectedCampo = false;
                        isSelectedSalaFitness = true;
                        _eventType = _eventTypeOptions[1]; // Sala de Fitness
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isSelectedSalaFitness ? Colors.white : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: isSelectedSalaFitness
                            ? [
                                const BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 3,
                                  offset: Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      child: Column(
                        children: [
                          Image.asset(
                            'assets/icons/sala-fitness.jpg', // Caminho da imagem da sala de fitness
                            width: 150,
                            height: 150,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Sala de Fitness',
                            style: TextStyle(
                              color: isSelectedSalaFitness ? const Color.fromARGB(255, 255, 130, 121) : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _selectTime(context, isStartTime: true),
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        foregroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 255, 130, 121)),
                      ),
                      child: Text('Hora de Início: ${_selectedStartTime.format(context)}'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _selectTime(context, isStartTime: false),
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        foregroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 255, 130, 121)),
                      ),
                      child: Text('Hora de Término: ${_selectedEndTime.format(context)}'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon( // Botão com ícone e texto
                onPressed: () {
                  if (_isValidEvent()) {
                    _saveEvent();
                  }
                },
                style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  backgroundColor: WidgetStateProperty.all<Color>(Colors.white),
                ),
                label: const Text(
                  'Reservar',
                  style: TextStyle(color: Color.fromARGB(255, 255, 130, 121), fontSize: 20), // Texto em preto com tamanho maior
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, {required bool isStartTime}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _selectedStartTime : _selectedEndTime,
    );

    if (picked != null) {
      // Converte o horário selecionado para DateTime para validação
      final selectedDateTime = DateTime(
        widget.selectedDay.year,
        widget.selectedDay.month,
        widget.selectedDay.day,
        picked.hour,
        picked.minute,
      );

      // Verifica se o horário selecionado está dentro do intervalo permitido
      if (selectedDateTime.isBefore(DateTime(widget.selectedDay.year, widget.selectedDay.month, widget.selectedDay.day, 9, 30)) ||
          selectedDateTime.isAfter(DateTime(widget.selectedDay.year, widget.selectedDay.month, widget.selectedDay.day, 22, 30))) {
        // Horário selecionado fora do intervalo permitido
        AwesomeDialog(
          context: context,
          dialogType: DialogType.warning,
          animType: AnimType.topSlide,
          showCloseIcon: true,
          desc: 'Selecione um horário entre 9:30 e 22:30.',
          btnOkOnPress: () {},
          btnOkColor: Colors.orange,
        ).show();
      } else {
        // Horário válido, atualiza o horário selecionado
        setState(() {
          if (isStartTime) {
            _selectedStartTime = picked;
          } else {
            _selectedEndTime = picked;
          }
        });
      }
    }
  }

  bool _isValidEvent() {
    final startTime = DateTime(
      widget.selectedDay.year,
      widget.selectedDay.month,
      widget.selectedDay.day,
      _selectedStartTime.hour,
      _selectedStartTime.minute,
    );
    final endTime = DateTime(
      widget.selectedDay.year,
      widget.selectedDay.month,
      widget.selectedDay.day,
      _selectedEndTime.hour,
      _selectedEndTime.minute,
    );

    // Verificar se o evento termina antes de começar
    if (endTime.isBefore(startTime)) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        animType: AnimType.topSlide,
        showCloseIcon: true,
        desc: 'A hora de fim de evento deve ser após a hora de início.',
        btnOkOnPress: () {},
        btnOkColor: Colors.orange,
      ).show();
      return false;
    }

    // Verificar se há conflito de horário com eventos existentes
    final selectedDateEvents = _events[widget.selectedDay];
    if (selectedDateEvents != null) {
      for (String event in selectedDateEvents) {
        final startIndex = event.indexOf('Das') + 4;
        final endIndex = event.indexOf('até');
        final eventStartTimeStr = event.substring(startIndex, endIndex).trim();
        final eventEndTimeStr = event.substring(endIndex + 3).trim();

        final eventStartTime = DateFormat.Hm().parse(eventStartTimeStr);
        final eventEndTime = DateFormat.Hm().parse(eventEndTimeStr);

        // Verificar conflito de horário
        if (_eventType == event.split(' - ')[0] &&
            ((startTime.isAfter(eventStartTime) && startTime.isBefore(eventEndTime)) ||
            (endTime.isAfter(eventStartTime) && endTime.isBefore(eventEndTime)))) {
          // Existe um conflito de horário com um evento existente do mesmo tipo
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Já existe um evento do mesmo tipo agendado para este horário.'),
              duration: Duration(seconds: 2),
            ),
          );
          return false;
        }
      }
    }

    return true;
  }

  void _saveEvent() {
    final startTime = DateTime(
      widget.selectedDay.year,
      widget.selectedDay.month,
      widget.selectedDay.day,
      _selectedStartTime.hour,
      _selectedStartTime.minute,
    );
    final endTime = DateTime(
      widget.selectedDay.year,
      widget.selectedDay.month,
      widget.selectedDay.day,
      _selectedEndTime.hour,
      _selectedEndTime.minute,
    );

    final event = {
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'type': _eventType,
    };

    _database.push().set(event).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Evento salvo com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context); // Retorna para a página anterior
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao salvar o evento.'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }
}
