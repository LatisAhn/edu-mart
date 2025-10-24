import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../providers/booking_provider.dart';

/// 보호자 정보 입력 폼 위젯
/// 보호자의 연락처 정보를 입력받는 폼
class GuardianInfoForm extends StatefulWidget {
  const GuardianInfoForm({super.key});

  @override
  State<GuardianInfoForm> createState() => _GuardianInfoFormState();
}

class _GuardianInfoFormState extends State<GuardianInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _relationshipController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  
  bool _isSameAsParticipant = false;
  String _selectedRelationship = '부모';

  final List<String> _relationships = [
    '부모',
    '조부모',
    '형제자매',
    '기타',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _relationshipController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 섹션 제목
            Text(
              '보호자 정보',
              style: AppTextTheme.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // 신청자 본인이 보호자인지 체크
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isSameAsParticipant ? AppColors.primaryBlue500 : AppColors.borderLight,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
                color: _isSameAsParticipant 
                    ? AppColors.primaryBlue500.withOpacity(0.1)
                    : AppColors.backgroundWhite,
              ),
              child: CheckboxListTile(
                title: Text(
                  '신청자 본인이 보호자입니다',
                  style: TextStyle(
                    color: _isSameAsParticipant ? AppColors.primaryBlue500 : Colors.black,
                    fontSize: 16,
                    fontWeight: _isSameAsParticipant ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
                value: _isSameAsParticipant,
                activeColor: AppColors.primaryBlue500,
                checkColor: Colors.white,
                side: BorderSide(
                  color: _isSameAsParticipant ? AppColors.primaryBlue500 : Colors.grey[400]!,
                  width: 2,
                ),
                onChanged: (value) {
                  setState(() {
                    _isSameAsParticipant = value ?? false;
                    if (_isSameAsParticipant) {
                      _nameController.text = context.read<BookingProvider>().participantInfo?.name ?? '';
                      _phoneController.text = context.read<BookingProvider>().participantInfo?.phone ?? '';
                    } else {
                      _nameController.clear();
                      _phoneController.clear();
                    }
                  });
                },
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ),
            const SizedBox(height: 16),
            
            // 보호자 이름
            CustomTextField(
              controller: _nameController,
              labelText: '보호자 이름',
              hintText: '이름을 입력해주세요',
              enabled: !_isSameAsParticipant,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '보호자 이름을 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // 관계 선택
            Text(
              '관계',
              style: AppTextTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: _selectedRelationship.isNotEmpty ? _selectedRelationship : null,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              dropdownColor: Colors.white,
              decoration: InputDecoration(
                hintText: '관계를 선택해주세요',
                hintStyle: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
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
              items: _relationships.map((relationship) {
                return DropdownMenuItem<String>(
                  value: relationship,
                  child: Text(
                    relationship,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRelationship = value ?? '';
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '관계를 선택해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // 연락처
            CustomTextField(
              controller: _phoneController,
              labelText: '연락처',
              hintText: '010-1234-5678',
              keyboardType: TextInputType.phone,
              enabled: !_isSameAsParticipant,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '연락처를 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // 이메일
            CustomTextField(
              controller: _emailController,
              labelText: '이메일 주소',
              hintText: 'example@email.com',
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '이메일을 입력해주세요';
                }
                if (!value.contains('@')) {
                  return '올바른 이메일 형식을 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // 정보 저장 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveGuardianInfo,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue500,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  '보호자 정보 저장',
                  style: AppTextTheme.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveGuardianInfo() {
    if (_formKey.currentState!.validate()) {
      // Provider에 보호자 정보 저장
      context.read<BookingProvider>().setGuardianInfo(
        name: _nameController.text,
        relationship: _selectedRelationship,
        phone: _phoneController.text,
        email: _emailController.text,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('보호자 정보가 저장되었습니다')),
      );
    }
  }
}
