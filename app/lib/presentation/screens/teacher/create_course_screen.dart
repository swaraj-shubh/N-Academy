// presentation/screens/teacher/create_course_screen.dart
import 'package:flutter/material.dart';
import '../../../data/repositories/teacher_repository.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/text_styles.dart';

class CreateCourseForm extends StatefulWidget {
  final VoidCallback? onCourseCreated;
  
  const CreateCourseForm({super.key, this.onCourseCreated});

  @override
  State<CreateCourseForm> createState() => _CreateCourseFormState();
}

class _CreateCourseFormState extends State<CreateCourseForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  
  final TeacherRepository _teacherRepository = TeacherRepository();
  
  bool _isSubmitting = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _createCourse() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
      _successMessage = null;
    });

    FocusScope.of(context).unfocus();

    try {
      final price = double.tryParse(_priceController.text.trim());
      if (price == null) {
        throw Exception('Invalid price format');
      }

      final result = await _teacherRepository.createCourse(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        price: price,
        currency: 'INR',
      );

      if (result['success'] == true) {
        setState(() {
          _successMessage = result['message'] ?? 'Course created successfully!';
        });
        
        // Clear form
        _titleController.clear();
        _descriptionController.clear();
        _priceController.clear();
        _formKey.currentState?.reset();
        
        // Show success snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_successMessage!),
            backgroundColor: Colors.green,
          ),
        );
        
        // Refresh dashboard if callback provided
        if (widget.onCourseCreated != null) {
          widget.onCourseCreated!();
        }
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Failed to create course';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Create New Course',
              style: AppTextStyles.heading2,
            ),
            const SizedBox(height: 8),
            Text(
              'Fill in the details to create a new course',
              style: AppTextStyles.bodyMedium,
            ),
            
            const SizedBox(height: 32),
            
            // Error Message
            if (_errorMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.danger.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.danger),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.danger,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            // Success Message
            if (_successMessage != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.secondary),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _successMessage!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.secondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            
            if (_errorMessage != null || _successMessage != null)
              const SizedBox(height: 16),
            
            // Course Title
            TextFormField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Course Title',
                hintText: 'e.g., Flutter Development Basics',
                prefixIcon: const Icon(Icons.title_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter course title';
                }
                if (value.length < 3) {
                  return 'Title must be at least 3 characters';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 20),
            
            // Course Description
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Describe what students will learn...',
                prefixIcon: const Icon(Icons.description_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter course description';
                }
                if (value.length < 10) {
                  return 'Description must be at least 10 characters';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 20),
            
            // Course Price
            TextFormField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price (INR)',
                hintText: 'e.g., 2999',
                prefixIcon: const Icon(Icons.currency_rupee_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter course price';
                }
                final price = double.tryParse(value);
                if (price == null) {
                  return 'Please enter a valid number';
                }
                if (price <= 0) {
                  return 'Price must be greater than 0';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 20),
            
            // Currency (Fixed to INR for now)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.currency_exchange_outlined, color: AppColors.darkGrey),
                  const SizedBox(width: 12),
                  Text(
                    'Currency: INR',
                    style: AppTextStyles.bodyLarge,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _createCourse,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add_circle_outline, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Create Course',
                            style: AppTextStyles.button,
                          ),
                        ],
                      ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Note:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '• Course will be published immediately\n'
                    '• Students can enroll in your course\n'
                    '• You can manage your courses from the dashboard',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}