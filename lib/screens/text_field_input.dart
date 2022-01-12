import 'package:flutter/material.dart';

class TextInputField extends StatefulWidget {
  const TextInputField({
    Key? key,
    required this.icon,
    required this.hint,
    required this.controller,
    required this.msg,
  }) : super(key: key);

  final IconData icon;
  final String msg;
  final TextEditingController controller;
  final String hint;

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  TextStyle kBodyText = const TextStyle(
    fontSize: 14,
    color: Colors.white,
    // height: 1.5,
  );

  Color kWhite = Colors.white;

  Color kBlue = const Color(0xff5663ff);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: SizedBox(
        height: size.height * 0.1,
        width: size.width * 0.8,
        // decoration: BoxDecoration(
        //   color: Colors.grey[500].withOpacity(0.5),
        //   borderRadius: BorderRadius.circular(16),
        // ),
        child: TextFormField(
          validator: (val) {
            if (val!.isEmpty) {
              return (widget.msg);
            }
          },
          controller: widget.controller,
          decoration: InputDecoration(
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.white70.withOpacity(.2), width: 1.0),
            ),
            prefixIcon: Icon(
              widget.icon,
              size: 24,
              color: kWhite,
            ),

            labelText: widget.hint,

            labelStyle: kBodyText,
            // hintText: hint,
            hintStyle: kBodyText,
          ),
          style: kBodyText,
        ),
      ),
    );
  }
}
