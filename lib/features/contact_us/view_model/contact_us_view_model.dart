part of '../contact_us_imports.dart';

class ContactUsViewModel {
  /// Services

  final GraphQLService _graphql = sl<GraphQLService>();
  final NavigationService _nav = sl<NavigationService>();

  /// Variables

  final GenericCubit<ContactUsData> _contactUsCubit =
      GenericCubit<ContactUsData>(const ContactUsData());

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _commentController;

  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _phoneFocusNode;
  late final FocusNode _commentFocusNode;

  ContactUsData get _data => _contactUsCubit.state.data;

  /// Init

  void _init() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _commentController = TextEditingController();

    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _phoneFocusNode = FocusNode();
    _commentFocusNode = FocusNode();
  }

  void _dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _commentController.dispose();

    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _phoneFocusNode.dispose();
    _commentFocusNode.dispose();

    _contactUsCubit.close();
  }

  /// Actions

  void _back() {
    _nav.pop();
  }

  void _dismissBanner() {
    _contactUsCubit.onUpdateData(
      _data.copyWith(status: ContactUsStatus.initial, clearErrorMessage: true),
    );
  }

  /// `telephone` is optional in the mutation, so it is only validated when the
  /// user actually typed something.
  bool _validate() {
    final String? nameError = Validators.validateName(_nameController.text);
    final String? emailError = Validators.validateEmail(_emailController.text);

    final String? phoneError = _phoneController.text.trim().isEmpty
        ? null
        : Validators.validatePhone(_phoneController.text);

    final String? commentError = _commentController.text.trim().isEmpty
        ? LocaleKeys.requiredField.tr()
        : null;

    _contactUsCubit.onUpdateData(
      _data.copyWith(
        clearFieldErrors: true,
        nameError: nameError,
        emailError: emailError,
        phoneError: phoneError,
        commentError: commentError,
      ),
    );

    if (nameError != null) {
      _nameFocusNode.requestFocus();
      return false;
    }

    if (emailError != null) {
      _emailFocusNode.requestFocus();
      return false;
    }

    if (phoneError != null) {
      _phoneFocusNode.requestFocus();
      return false;
    }

    if (commentError != null) {
      _commentFocusNode.requestFocus();
      return false;
    }

    return true;
  }

  Future<void> _submit() async {
    if (_data.isSubmitting) return;
    if (!_validate()) return;

    _contactUsCubit.onUpdateData(
      _data.copyWith(
        status: ContactUsStatus.submitting,
        clearErrorMessage: true,
      ),
    );

    final ContactUsRequest request = ContactUsRequest(
      name: _nameController.text,
      email: _emailController.text,
      comment: _commentController.text,
      telephone: _phoneController.text,
    );

    try {
      final Map<String, dynamic> data = await _graphql.mutate(
        GraphQLDocuments.submitContactForm,
        variables: request.toVariables(),
      );

      final bool isSent =
          (data['contactUs'] as Map<String, dynamic>?)?['status'] == true;

      if (!isSent) {
        _contactUsCubit.onUpdateData(
          _data.copyWith(
            status: ContactUsStatus.error,
            errorMessage: LocaleKeys.contactUsFailed.tr(),
          ),
        );
        return;
      }

      _clearForm();

      _contactUsCubit.onUpdateData(
        _data.copyWith(
          status: ContactUsStatus.success,
          clearErrorMessage: true,
          clearFieldErrors: true,
        ),
      );
    } catch (error) {
      _contactUsCubit.onUpdateData(
        _data.copyWith(
          status: ContactUsStatus.error,
          errorMessage: _extractGraphQLMessage(error),
        ),
      );
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _commentController.clear();
  }

  String _extractGraphQLMessage(Object error) {
    if (error is GraphQLServiceException && error.message.trim().isNotEmpty) {
      return error.message;
    }

    return LocaleKeys.contactUsFailed.tr();
  }
}
