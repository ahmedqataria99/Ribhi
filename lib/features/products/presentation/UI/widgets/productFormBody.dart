import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ribhi/core/theme/app_responsive.dart';
import 'package:ribhi/features/products/presentation/UI/widgets/AddproductBottom.dart';
import 'package:ribhi/features/products/presentation/UI/widgets/PriceField.dart';
import 'package:ribhi/features/products/presentation/UI/widgets/QuantityFeild.dart';
import 'package:ribhi/features/products/presentation/UI/widgets/categoryChoose.dart';
import 'package:ribhi/features/products/presentation/UI/widgets/productNameField.dart';

class Productformbody extends StatelessWidget {
  final bool isEdit;
  Productformbody({required this.isEdit});
  @override
  Widget build(BuildContext context) {
    final s = AppSizes.s;
    return Padding(
      padding: EdgeInsets.all(s(context, 16.0)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ProductNameField(isEdit: isEdit),
            Gap(s(context, 10)),
            PriceFields(isEdit: isEdit),
            Gap(s(context, 10)),
            QuantityAlarmFields(isEdit: isEdit),
            Gap(s(context, 10)),
            CategorySelector(),
            Gap(s(context, 10)),
            ProductFormSubmitButton(isEdit: isEdit),
          ],
        ),
      ),
    );
  }
}
