import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_responsive.dart';

class CustomWaterInputSection extends StatefulWidget {
  const CustomWaterInputSection({super.key, required this.onAddWater});

  final ValueChanged<int> onAddWater;

  @override
  State<CustomWaterInputSection> createState() =>
      _CustomWaterInputSectionState();
}

class _CustomWaterInputSectionState extends State<CustomWaterInputSection> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    final amount = int.tryParse(text);
    if (amount != null && amount > 0) {
      widget.onAddWater(amount);
      _controller.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add your own amount',
          style: TextStyle(
            color: AppColors.darkGreen,
            fontSize: AppResponsive.font(context, 16),
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: AppResponsive.value(context, 10)),
        Container(
          padding: EdgeInsets.all(AppResponsive.value(context, 16)),
          decoration: BoxDecoration(
            color: AppColors.softGreen,
            borderRadius: BorderRadius.circular(
              AppResponsive.value(context, 24),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: AppResponsive.value(context, 54),
                child: TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submit(),
                  cursorColor: AppColors.green,
                  style: TextStyle(
                    color: AppColors.darkGreen,
                    fontSize: AppResponsive.font(context, 15),
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter amount',
                    hintStyle: TextStyle(
                      color: AppColors.mutedGreen,
                      fontSize: AppResponsive.font(context, 14),
                    ),
                    suffixIcon: Padding(
                      padding: EdgeInsets.only(
                        right: AppResponsive.value(context, 16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'ml',
                            style: TextStyle(
                              color: AppColors.darkGreen,
                              fontSize: AppResponsive.font(context, 14),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF4F6EE),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.value(context, 16),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppResponsive.value(context, 16),
                      ),
                      borderSide: const BorderSide(
                        color: AppColors.borderGreen,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppResponsive.value(context, 16),
                      ),
                      borderSide: const BorderSide(
                        color: AppColors.borderGreen,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppResponsive.value(context, 16),
                      ),
                      borderSide: const BorderSide(color: AppColors.green),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppResponsive.value(context, 12)),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _submit,
                  borderRadius: BorderRadius.circular(100),
                  child: Ink(
                    height: AppResponsive.value(context, 52),
                    padding: EdgeInsets.symmetric(
                      horizontal: AppResponsive.value(context, 18),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.darkGreen,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Add water',
                          style: TextStyle(
                            color: AppColors.lime,
                            fontSize: AppResponsive.font(context, 15),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Container(
                          width: AppResponsive.value(context, 34),
                          height: AppResponsive.value(context, 34),
                          decoration: const BoxDecoration(
                            color: AppColors.lime,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.add,
                            color: AppColors.darkGreen,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
