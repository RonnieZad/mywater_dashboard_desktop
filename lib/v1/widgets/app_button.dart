import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mywater_dashboard_revamp/v1/utils/typography.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.action,
    required this.buttonLabel,
  });
  final String buttonLabel;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 45.h,
        child: FilledButton(
            onPressed: action,
            child: Center(
                child: label(
              text: buttonLabel,
              color: Colors.white,
              fontSize: 10.sp,
            ))));
  }
}
