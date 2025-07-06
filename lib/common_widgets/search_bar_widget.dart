import 'package:drip_store/styles_manager/font_manager.dart';
import 'package:drip_store/styles_manager/values_manager.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Function(String)? onChanged;
  final VoidCallback? onClear;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onClear,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppPadding.p15),
      margin: const EdgeInsets.symmetric(vertical: AppMargin.m8),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        style: TextStyle(fontSize: FontSizeManager.f14),
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s12)),
          ),
          suffixIcon:
              widget.controller!.text.isNotEmpty
                  ? IconButton(
                    onPressed: widget.onClear,
                    icon: Icon(
                      Icons.clear,
                      color: Colors.grey[500],
                      size: AppSize.s20,
                    ),
                  )
                  : null,
          prefixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
