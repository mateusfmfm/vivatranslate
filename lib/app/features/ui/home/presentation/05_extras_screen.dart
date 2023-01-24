import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:vivatranslate_mateus/app/core/constants/app_assets.dart';
import 'package:vivatranslate_mateus/app/core/constants/app_strings.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/scaffolds/ui_scaffold.dart';
import 'package:vivatranslate_mateus/app/features/ui/widgets/texts/custom_text.dart';

class ExtrasScreen extends StatefulWidget {
  const ExtrasScreen({super.key});

  @override
  State<ExtrasScreen> createState() => _ExtrasScreenState();
}

class _ExtrasScreenState extends State<ExtrasScreen> {
  @override
  Widget build(BuildContext context) {
    return UIScaffold(
      title: "Extras",
      body: [
        Image.asset(AppAssets.PYTHON, height: 50),
        SizedBox(height: 16),
        TextRegular(AppStrings.LETS_RUN_PYTHON, textAlign: TextAlign.center)
      ],
    );
  }
}
