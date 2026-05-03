import 'package:flutter/material.dart';
import 'package:the_lively_three/flutter_flow/flutter_flow_theme.dart';

class SelectCountryDialog extends StatefulWidget {
  final List<Map<String, String>> countries;
  final String title;

  const SelectCountryDialog({
    Key? key,
    required this.countries,
    this.title = "Select Country",
  }) : super(key: key);

  @override
  State<SelectCountryDialog> createState() => _SelectCountryDialogState();
}

class _SelectCountryDialogState extends State<SelectCountryDialog> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    final filteredCountries = widget.countries.where((country) {
      final name = country["name"]!.toLowerCase();
      return name.contains(_searchQuery.toLowerCase());
    }).toList();

    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      child: Padding(
        padding:
            EdgeInsets.only(bottom: keyboardInset), // ✅ shift above keyboard
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height:
                MediaQuery.of(context).size.height * 0.8, // 80% screen height
            decoration: const BoxDecoration(
              color: Color(0xfff8f8f8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                // Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 18),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          "Close",
                          style: TextStyle(
                            fontSize: FlutterFlowTheme.adjustScale(size: 12),
                            fontWeight: FontWeight.w500,
                            color: FlutterFlowTheme.of(context).primaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Search bar
                Container(
                  margin: const EdgeInsets.all(8),
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xffededed),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.search,
                            size: 20, color: Color(0xff393C53)),
                      ),
                      hintText: "Search",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                // Country list
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredCountries.length,
                    itemBuilder: (context, index) {
                      final country = filteredCountries[index];
                      return Column(
                        children: [
                          ListTile(
                            leading: Text(
                              country["flag"] ?? "🌍",
                              style: TextStyle(
                                  fontSize:
                                      FlutterFlowTheme.adjustScale(size: 20)),
                            ),
                            title: Text(country["name"] ?? ""),
                            onTap: () => Navigator.pop(context, country),
                          ),
                          const Divider(
                            height: 2,
                            thickness: 1,
                            color: Color(0xffe0e0e0),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
