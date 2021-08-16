import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormFieldWithLabel extends StatelessWidget {
  TextEditingController? controller;
  String? label;
  Color? labelTextColor;
  Color? textFieldColor;
  Color? hintTextColor;
  bool obscureText;
  TextInputType? textInputType;
  int? maxLength;
  bool showPasswordToggle;
  bool? showPassword;
  VoidCallback? onTogglePasswordVisibility;
  FormFieldValidator<String>? validator;
  List<TextInputFormatter>? inputFormatters;

  FormFieldWithLabel(
      {Key? key,
        this.label,
        this.controller,
        this.labelTextColor: Colors.black45,
        this.hintTextColor: Colors.black26,
        this.textFieldColor: Colors.black,
        this.obscureText: false,
        this.showPasswordToggle: false,
        this.textInputType: TextInputType.text,
        this.maxLength,
        this.showPassword,
        this.onTogglePasswordVisibility,
        this.validator,
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        label == null
            ? SizedBox.shrink()
            : Text(
          "$label",
          style: TextStyle(
            color: labelTextColor,
            fontSize: 13,
          ),
          textAlign: TextAlign.start,
        ),
        TextFormField(
          controller: this.controller,
          obscureText: this.obscureText == true,
          style: TextStyle(
            fontSize: 16,
            color: textFieldColor,
          ),
          decoration: InputDecoration(
              hintStyle: TextStyle(color: hintTextColor),
              border: UnderlineInputBorder(),
              counterText: "",
              suffixIcon: showPasswordToggle
                  ? IconButton(
                icon: (showPassword ?? false)
                    ? Icon(Icons.remove_red_eye_outlined)
                    : Icon(Icons.remove_red_eye),
                onPressed: () {
                  if (onTogglePasswordVisibility != null) {
                    onTogglePasswordVisibility!();
                  }
                },
              )
                  : null),
          keyboardType: textInputType,
          maxLength: maxLength,
          validator: validator,
          inputFormatters: inputFormatters,
        )
      ],
    );
  }
}