import 'package:at_data_browser/widgets/search_field_container.dart';
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
    dateController = TextEditingController();
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
            dateController.text = '${DateFormat.yMMMd().format(value.start)} - ${DateFormat.yMMMd().format(value.end)}';

            _date = value;
          });

          setState(() {
            ref.watch(searchFormProvider).searchRequest[widget.index] = value.toString();
          });
          ref.watch(filterControllerProvider.notifier).getFilteredAtData();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SearchFieldContainer(
      child: TextFormField(
        style: Theme.of(context).textTheme.bodyMedium!.copyWith(),
        readOnly: true,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.top,
        // focusNode: widget.state.dateOfBirthFocusNode,
        controller: dateController,
        // validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {},
        decoration: const InputDecoration(
          border: InputBorder.none,
          // suffixIcon: Icon(
          //   Icons.calendar_month_outlined,
          //   size: 14,
          // ),
          contentPadding: EdgeInsets.only(bottom: 14),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        onTap: _showDatePicker,
      ),
    );
  }
}
