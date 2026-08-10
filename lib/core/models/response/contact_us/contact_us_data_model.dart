part of '../../../../features/contact_us/contact_us_imports.dart';

enum ContactUsStatus { initial, submitting, success, error }

class ContactUsData extends Equatable {
  final ContactUsStatus status;
  final String errorMessage;
  final String? nameError;
  final String? emailError;
  final String? phoneError;
  final String? commentError;

  const ContactUsData({
    this.status = ContactUsStatus.initial,
    this.errorMessage = '',
    this.nameError,
    this.emailError,
    this.phoneError,
    this.commentError,
  });

  bool get isSubmitting => status == ContactUsStatus.submitting;

  ContactUsData copyWith({
    ContactUsStatus? status,
    String? errorMessage,
    String? nameError,
    String? emailError,
    String? phoneError,
    String? commentError,
    bool clearErrorMessage = false,
    bool clearFieldErrors = false,
  }) {
    return ContactUsData(
      status: status ?? this.status,
      errorMessage: clearErrorMessage
          ? ''
          : (errorMessage ?? this.errorMessage),
      nameError: clearFieldErrors ? null : (nameError ?? this.nameError),
      emailError: clearFieldErrors ? null : (emailError ?? this.emailError),
      phoneError: clearFieldErrors ? null : (phoneError ?? this.phoneError),
      commentError: clearFieldErrors
          ? null
          : (commentError ?? this.commentError),
    );
  }

  @override
  List<Object?> get props => [
    status,
    errorMessage,
    nameError,
    emailError,
    phoneError,
    commentError,
  ];
}
