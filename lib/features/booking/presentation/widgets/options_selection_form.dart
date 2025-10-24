import 'package:flutter/material.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';

/// 옵션 선택 폼 위젯
/// 추가 옵션들을 선택할 수 있는 폼
class OptionsSelectionForm extends StatefulWidget {
  final VoidCallback? onOptionsChanged;
  final VoidCallback? onNext;

  const OptionsSelectionForm({
    super.key,
    this.onOptionsChanged,
    this.onNext,
  });

  @override
  State<OptionsSelectionForm> createState() => _OptionsSelectionFormState();
}

class _OptionsSelectionFormState extends State<OptionsSelectionForm> {
  String _selectedRoomType = '2인실';
  bool _pickupService = false;
  bool _insurance = false;
  String _selectedDietary = '일반식';

  final List<String> _roomTypes = ['2인실', '3인실', '4인실'];
  final List<String> _dietaryOptions = ['일반식', '할랄식', '채식', '기타'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // 숙박 타입 선택
          _buildSectionTitle('숙박 타입'),
          const SizedBox(height: 1),
          Row(
            children: _roomTypes.map((roomType) {
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRoomType = roomType;
                    });
                    widget.onOptionsChanged?.call();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _selectedRoomType == roomType 
                            ? AppColors.primaryBlue500 
                            : Colors.grey[400]!,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: _selectedRoomType == roomType 
                          ? AppColors.primaryBlue500.withOpacity(0.1)
                          : Colors.grey[50],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedRoomType == roomType 
                                  ? AppColors.primaryBlue500 
                                  : Colors.grey[400]!,
                              width: 2,
                            ),
                            color: _selectedRoomType == roomType 
                                ? AppColors.primaryBlue500 
                                : Colors.transparent,
                          ),
                          child: _selectedRoomType == roomType
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          roomType,
                          style: TextStyle(
                            color: _selectedRoomType == roomType ? AppColors.primaryBlue500 : Colors.grey[700],
                            fontSize: 16,
                            fontWeight: _selectedRoomType == roomType 
                                ? FontWeight.bold 
                                : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          
          // 픽업 서비스
          _buildToggleOption(
            '공항 픽업 서비스',
            '공항에서 캠프장까지 픽업 서비스를 제공합니다',
            '+₩100,000',
            _pickupService,
            (value) {
              setState(() {
                _pickupService = value;
              });
              widget.onOptionsChanged?.call();
            },
          ),
          const SizedBox(height: 16),
          
          // 보험
          _buildToggleOption(
            '여행자 보험',
            '캠프 기간 중 보험을 제공합니다',
            '+₩50,000',
            _insurance,
            (value) {
              setState(() {
                _insurance = value;
              });
              widget.onOptionsChanged?.call();
            },
          ),
          const SizedBox(height: 20),
          
          // 식이 옵션
          _buildSectionTitle('식이 옵션'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedDietary,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            dropdownColor: Colors.white,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.borderLight),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.primaryBlue500),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            ),
            items: _dietaryOptions.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(
                  option,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedDietary = value ?? '일반식';
              });
              widget.onOptionsChanged?.call();
            },
          ),
          const SizedBox(height: 20),
          
          // 다음 단계 버튼
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // 다음 단계로 진행
                widget.onNext?.call();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue500,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '다음 단계',
                style: AppTextTheme.bodyLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTextTheme.bodyMedium.copyWith(
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildToggleOption(
    String title,
    String description,
    String price,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: value ? AppColors.primaryBlue50 : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: value ? AppColors.primaryBlue500 : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: (bool? newValue) => onChanged(newValue ?? false),
            activeColor: AppColors.primaryBlue500,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: TextStyle(
              color: AppColors.primaryBlue500,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
