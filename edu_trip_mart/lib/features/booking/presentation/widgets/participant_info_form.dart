import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_text_theme.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../providers/booking_provider.dart';

/// 참가자 정보 입력 폼 위젯
/// 참가자의 기본 정보를 입력받는 폼
class ParticipantInfoForm extends StatefulWidget {
  const ParticipantInfoForm({
    super.key,
  });

  @override
  State<ParticipantInfoForm> createState() => _ParticipantInfoFormState();
}

class _ParticipantInfoFormState extends State<ParticipantInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _passportController = TextEditingController();
  final _phoneController = TextEditingController();
  
  String _selectedGender = '';

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_saveParticipantInfo);
    _birthDateController.addListener(_saveParticipantInfo);
    _passportController.addListener(_saveParticipantInfo);
    _phoneController.addListener(_saveParticipantInfo);
  }

  @override
  void dispose() {
    _nameController.removeListener(_saveParticipantInfo);
    _birthDateController.removeListener(_saveParticipantInfo);
    _passportController.removeListener(_saveParticipantInfo);
    _phoneController.removeListener(_saveParticipantInfo);
    _nameController.dispose();
    _birthDateController.dispose();
    _passportController.dispose();
    _phoneController.dispose();
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
              '참가자 정보',
              style: AppTextTheme.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            
            // 이름 입력
          CustomTextField(
            controller: _nameController,
            labelText: '이름',
            hintText: '이름을 입력해주세요',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '이름을 입력해주세요';
              }
              return null;
            },
          ),
            const SizedBox(height: 16),
            
            // 생년월일 입력
            CustomTextField(
              controller: _birthDateController,
              labelText: '생년월일',
              hintText: 'YYYY-MM-DD',
              readOnly: true,
              onTap: () => _selectBirthDate(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '생년월일을 선택해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // 성별 선택
            Text(
              '성별',
              style: AppTextTheme.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedGender = 'male';
                      });
                      _saveParticipantInfo();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedGender == 'male' 
                              ? AppColors.primaryBlue500 
                              : Colors.grey[400]!,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: _selectedGender == 'male' 
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
                                color: _selectedGender == 'male' 
                                    ? AppColors.primaryBlue500 
                                    : Colors.grey[400]!,
                                width: 2,
                              ),
                              color: _selectedGender == 'male' 
                                  ? AppColors.primaryBlue500 
                                  : Colors.transparent,
                            ),
                            child: _selectedGender == 'male'
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '남',
                            style: TextStyle(
                              color: _selectedGender == 'male' ? AppColors.primaryBlue500 : Colors.grey[700],
                              fontSize: 16,
                              fontWeight: _selectedGender == 'male' 
                                  ? FontWeight.bold 
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedGender = 'female';
                      });
                      _saveParticipantInfo();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _selectedGender == 'female' 
                              ? AppColors.primaryBlue500 
                              : Colors.grey[400]!,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: _selectedGender == 'female' 
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
                                color: _selectedGender == 'female' 
                                    ? AppColors.primaryBlue500 
                                    : Colors.grey[400]!,
                                width: 2,
                              ),
                              color: _selectedGender == 'female' 
                                  ? AppColors.primaryBlue500 
                                  : Colors.transparent,
                            ),
                            child: _selectedGender == 'female'
                                ? const Icon(
                                    Icons.check,
                                    size: 14,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '여',
                            style: TextStyle(
                              color: _selectedGender == 'female' ? AppColors.primaryBlue500 : Colors.grey[700],
                              fontSize: 16,
                              fontWeight: _selectedGender == 'female' 
                                  ? FontWeight.bold 
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // 여권번호 입력
            CustomTextField(
              controller: _passportController,
              labelText: '여권번호',
              hintText: '여권번호를 입력해주세요',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '여권번호를 입력해주세요';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // 연락처 입력
            CustomTextField(
              controller: _phoneController,
              labelText: '연락처',
              hintText: '010-1234-5678',
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '연락처를 입력해주세요';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  void _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        _birthDateController.text = '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  void _saveParticipantInfo() {
    // Provider에 참가자 정보 저장
    context.read<BookingProvider>().setParticipantInfo(
      name: _nameController.text,
      age: _calculateAge(_birthDateController.text),
      phone: _phoneController.text,
      email: '', // 이메일은 보호자 정보에서 입력
      passportNumber: _passportController.text,
      emergencyContact: '', // 비상연락처는 보호자 정보에서 입력
      specialRequests: '',
    );
  }

  int _calculateAge(String birthDate) {
    try {
      final birth = DateTime.parse(birthDate);
      final now = DateTime.now();
      int age = now.year - birth.year;
      if (now.month < birth.month || (now.month == birth.month && now.day < birth.day)) {
        age--;
      }
      return age;
    } catch (e) {
      return 0;
    }
  }
}
