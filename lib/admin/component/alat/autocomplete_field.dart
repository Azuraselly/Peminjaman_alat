import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AutocompleteField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final Future<List<Map<String, dynamic>>> Function(String) onSearch;
  final Function(Map<String, dynamic>) onSelected;
  final String displayKey;
  final String? subtitleKey;

  const AutocompleteField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.onSearch,
    required this.onSelected,
    required this.displayKey,
    this.subtitleKey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Colors.grey[600],
            ),
          ),
        ),
        Autocomplete<Map<String, dynamic>>(
          optionsBuilder: (TextEditingValue textEditingValue) async {
            if (textEditingValue.text.isEmpty) {
              return const Iterable<Map<String, dynamic>>.empty();
            }
            return await onSearch(textEditingValue.text);
          },
          displayStringForOption: (Map<String, dynamic> option) =>
              option[displayKey]?.toString() ?? '',
          onSelected: onSelected,
          fieldViewBuilder: (
            context,
            textEditingController,
            focusNode,
            onFieldSubmitted,
          ) {
            // Sync with external controller
            textEditingController.text = controller.text;
            textEditingController.addListener(() {
              controller.text = textEditingController.text;
            });

            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              decoration: InputDecoration(
                hintText: hint,
                filled: true,
                fillColor: const Color(0xFFF1F1F1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: const Icon(Icons.search, size: 18),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: MediaQuery.of(context).size.width - 48,
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: options.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        title: Text(
                          option[displayKey]?.toString() ?? '',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: subtitleKey != null && option[subtitleKey] != null
                            ? Text(
                                option[subtitleKey]?.toString() ?? '',
                                style: GoogleFonts.poppins(fontSize: 12),
                              )
                            : null,
                        onTap: () => onSelected(option),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}