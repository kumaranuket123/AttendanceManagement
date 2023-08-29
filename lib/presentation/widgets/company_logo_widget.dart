import 'package:attendence_management/constant/constants.dart';
import 'package:flutter/material.dart';

import '../../constant/assets.dart';

class CompanyLogoWidget extends StatelessWidget {
  const CompanyLogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          appLogo,
          height: MediaQuery.sizeOf(context).height * 0.1,
        ),
        Text(
          appName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    ));
  }
}
