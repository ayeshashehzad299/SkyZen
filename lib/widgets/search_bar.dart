import 'package:flutter/material.dart';

class CustomSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSearch;

  const CustomSearchBar({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onSearch,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: 'Search city...',
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              hintStyle: TextStyle(color: Colors.white70),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            style: TextStyle(color: Colors.white),
            onSubmitted: (_) => onSearch(),
          ),
        ),
        SizedBox(width: 10),
        IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: onSearch,
        )
      ],
    );
  }
}
