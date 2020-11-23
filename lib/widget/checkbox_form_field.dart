import 'package:flutter/material.dart';

class CheckboxFormField extends FormField<bool> {
  CheckboxFormField(
      {Widget title,
      FormFieldSetter<bool> onSaved,
      FormFieldValidator<bool> validator,
        Function(bool val) onChanged,
      bool initialValue = false,
      AutovalidateMode autovalidate = AutovalidateMode.onUserInteraction})
      : super(
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: autovalidate,
            builder: (FormFieldState<bool> state) {
              return CheckboxListTile(
                dense: state.hasError,
                contentPadding: EdgeInsets.symmetric(vertical: 6),
                title: title,
                value: state.value,
                onChanged: (v){
                  if(onChanged != null){
                    onChanged(v);
                  }
                  state.didChange(v);
                },
                subtitle: state.hasError
                    ? Builder(
                        builder: (BuildContext context) => Text(
                          state.errorText,
                          style: TextStyle(color: Theme.of(context).errorColor),
                        ),
                      )
                    : null,
                controlAffinity: ListTileControlAffinity.trailing,
              );
            });
}
