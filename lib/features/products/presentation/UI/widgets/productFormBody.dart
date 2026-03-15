import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ProductNameField(
              isEdit: isEdit,
              ),
              Gap(10),
            PriceFields(isEdit: isEdit),
            Gap(10),
            QuantityAlarmFields(isEdit: isEdit),
            Gap(10),
            CategorySelector(),
            Gap(10),
            ProductFormSubmitButton(isEdit: isEdit),
          ],
        ),
      ),
    );
  }
}
