import 'package:flutter/material.dart';

class CustomTextForm extends StatelessWidget {
  // final IconData icon ;
  final Widget? icon;
  final String hinttext ;
  final TextEditingController mycontroller ;
  final Widget? suffixIcon;
  // final Widget? suffix;
  final bool obscureText ;
  final String? Function(String?)? validator;

  const CustomTextForm({super.key, required this.hinttext, required this.mycontroller, required this.validator, this.icon, required this.obscureText, this.suffixIcon, });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
            controller: mycontroller,
            obscureText: obscureText,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hinttext,
            icon: icon,
              suffixIcon: suffixIcon,
            hintStyle: TextStyle(color: Colors.grey[400],),
          ),
          validator: validator,
        );

  }
}
