import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../controllers/at_data_controller.dart';
import '../controllers/filter_form_controller.dart';

class DateRangeCategoryWidget extends ConsumerStatefulWidget {
  const DateRangeCategoryWidget({
    Key? key,
    required this.labelText,
    required this.index,
    // required this.validator,
    // required this.onSaved,
    // required this.initialValue,
    this.width = 250,
  }) : super(key: key);

  final String labelText;
  final int index;
  // final String? Function(String? value) validator;
  // final void Function(DateTime? value) onSaved;
  // final String? initialValue;
  final double width;

  @override
  _DateRangeCategoryWidgetState createState() => _DateRangeCategoryWidgetState();
}

class _DateRangeCategoryWidgetState extends ConsumerState<DateRangeCategoryWidget> {
  late TextEditingController dateController;
  @override
  void initState() {
    super.initState();
    dateController = TextEditingController(
        text: '${DateFormat.yMMMd().format(DateTime.now())} - ${DateFormat().format(DateTime.now())}');
  }

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
  }

  DateTimeRange? _date;
  void _showDatePicker() {
    showDateRangePicker(
      context: context,
      initialDateRange: _date ?? DateTimeRange(start: DateTime.now(), end: DateTime.now()),
      firstDate: DateTime(1920),
      lastDate: DateTime(3000),
      // currentDate: _date,
    ).then(
      (value) {
        if (value != null) {
          setState(() {
            dateController.text =
                '${DateFormat.yMMMd().format(value.start)} - ${DateFormat('dd MMM yy').format(value.end)}';

            _date = value;
          });

          setState(() {
            ref.watch(searchFormProvider).searchRequest[widget.index] = value.toString();
          });
          ref.watch(atDataControllerProvider.notifier).getFilteredAtData();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Material(
        elevation: 12,
        borderRadius: const BorderRadius.all(Radius.circular(18)),
        child: TextFormField(
          style: const TextStyle(fontSize: 16),
          readOnly: true,
          // focusNode: widget.state.dateOfBirthFocusNode,
          controller: dateController,
          // validator: widget.validator,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {},
          decoration: const InputDecoration(
            suffixIcon: Icon(Icons.calendar_today_outlined),
          ),
          onTap: _showDatePicker,
        ),
      ),
    );
  }
}
