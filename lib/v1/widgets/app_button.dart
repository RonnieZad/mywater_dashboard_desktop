import 'package:fluent_ui/fluent_ui.dart';
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
        height: 45,
        child: FilledButton(
            onPressed: action,
            child: Center(
                child: AppTypography.bodyMedium(
              text: buttonLabel,
              color: Colors.white,
            ))));
  }
}
