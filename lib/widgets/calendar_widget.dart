import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CalendarWidget extends StatefulWidget {
  final List<DateTime> bookedDates;
  final Function(DateTime)? onDateSelected;
  final DateTime? selectedDate;

  const CalendarWidget({
    super.key,
    required this.bookedDates,
    this.onDateSelected,
    this.selectedDate,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _currentMonth;
  late DateTime _today;

  @override
  void initState() {
    super.initState();
    _today = DateTime.now();
    _currentMonth = DateTime(_today.year, _today.month);
    _initializeLocale();
  }

  Future<void> _initializeLocale() async {
    await initializeDateFormatting('es', null);
  }

  String _getMonthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month - 1];
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  bool _isBooked(DateTime date) {
    return widget.bookedDates.any((bookedDate) =>
        bookedDate.year == date.year &&
        bookedDate.month == date.month &&
        bookedDate.day == date.day);
  }

  bool _isToday(DateTime date) {
    return date.year == _today.year &&
        date.month == _today.month &&
        date.day == _today.day;
  }

  bool _isSelected(DateTime date) {
    if (widget.selectedDate == null) return false;
    return date.year == widget.selectedDate!.year &&
        date.month == widget.selectedDate!.month &&
        date.day == widget.selectedDate!.day;
  }

  List<DateTime> _getDaysInMonth() {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final daysInMonth = lastDay.day;
    
    List<DateTime> days = [];
    
    // Agregar días del mes anterior para completar la semana
    final firstWeekday = firstDay.weekday;
    for (int i = firstWeekday - 1; i > 0; i--) {
      days.add(firstDay.subtract(Duration(days: i)));
    }
    
    // Agregar días del mes actual
    for (int day = 1; day <= daysInMonth; day++) {
      days.add(DateTime(_currentMonth.year, _currentMonth.month, day));
    }
    
    // Agregar días del mes siguiente para completar la semana
    final remainingDays = 42 - days.length; // 6 semanas * 7 días
    for (int day = 1; day <= remainingDays; day++) {
      days.add(DateTime(_currentMonth.year, _currentMonth.month + 1, day));
    }
    
    return days;
  }

  @override
  Widget build(BuildContext context) {
    final monthName = _getMonthName(_currentMonth.month) + ' ${_currentMonth.year}';
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header del calendario
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFF1E88E5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: _previousMonth,
                  icon: const Icon(Icons.chevron_left, color: Colors.white),
                ),
                Text(
                  monthName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: _nextMonth,
                  icon: const Icon(Icons.chevron_right, color: Colors.white),
                ),
              ],
            ),
          ),
          
          // Días de la semana
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom']
                  .map((day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          
          // Calendario
          Container(
            padding: const EdgeInsets.all(8),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
              ),
              itemCount: 42, // 6 semanas * 7 días
              itemBuilder: (context, index) {
                final days = _getDaysInMonth();
                final day = days[index];
                final isCurrentMonth = day.month == _currentMonth.month;
                final isBooked = _isBooked(day);
                final isToday = _isToday(day);
                final isSelected = _isSelected(day);
                
                return GestureDetector(
                  onTap: () {
                    if (isCurrentMonth) {
                      widget.onDateSelected?.call(day);
                    }
                  },
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: _getDayColor(isBooked, isToday, isSelected, isCurrentMonth),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _getBorderColor(isBooked, isToday, isSelected),
                        width: isToday ? 2 : 1,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${day.day}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                              color: _getTextColor(isBooked, isToday, isSelected, isCurrentMonth),
                            ),
                          ),
                          if (isBooked && isCurrentMonth)
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Leyenda
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildLegendItem(Colors.red, 'Ocupado'),
                _buildLegendItem(Colors.blue, 'Hoy'),
                _buildLegendItem(Colors.green, 'Disponible'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }

  Color _getDayColor(bool isBooked, bool isToday, bool isSelected, bool isCurrentMonth) {
    if (!isCurrentMonth) {
      return Colors.grey[100]!;
    }
    
    if (isSelected) {
      return const Color(0xFF1976D2);
    }
    
    if (isBooked) {
      return Colors.red[100]!;
    }
    
    if (isToday) {
      return Colors.blue[100]!;
    }
    
    return Colors.white;
  }

  Color _getBorderColor(bool isBooked, bool isToday, bool isSelected) {
    if (isSelected) {
      return const Color(0xFF1976D2);
    }
    
    if (isToday) {
      return Colors.blue;
    }
    
    if (isBooked) {
      return Colors.red;
    }
    
    return Colors.grey[300]!;
  }

  Color _getTextColor(bool isBooked, bool isToday, bool isSelected, bool isCurrentMonth) {
    if (!isCurrentMonth) {
      return Colors.grey[400]!;
    }
    
    if (isSelected) {
      return Colors.white;
    }
    
    if (isBooked) {
      return Colors.red[700]!;
    }
    
    if (isToday) {
      return Colors.blue[700]!;
    }
    
    return Colors.black87;
  }
}
