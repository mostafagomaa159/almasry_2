part of '../contact_us_imports.dart';

class ContactUsViewModel {
  /// Services

  final GraphQLService _graphql = sl<GraphQLService>();
  final NavigationService _nav = sl<NavigationService>();

  /// Variables

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GenericCubit<bool> _loadingCubit = GenericCubit<bool>(false);

  final GenericCubit<SubmitContactFormResponse?> _responseCubit =
      GenericCubit<SubmitContactFormResponse?>(null);

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _commentController;

  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _phoneFocusNode;
  late final FocusNode _commentFocusNode;

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

    _loadingCubit.close();
    _responseCubit.close();
  }

  /// Actions

  void _back() {
    _nav.pop();
  }

  /// Validation

  String? _validateName(String? value) => Validators.validateName(value ?? '');

  String? _validateEmail(String? value) =>
      Validators.validateEmail(value ?? '');

  /// `telephone` is optional in the mutation, so it is only validated when the
  /// user actually typed something.
  String? _validatePhone(String? value) {
    final String phone = value ?? '';
    return phone.trim().isEmpty ? null : Validators.validatePhone(phone);
  }

  String? _validateComment(String? value) =>
      Validators.validateComment(value ?? '');

  /// Submit

  Future<void> _submit() async {
    if (_loadingCubit.state.data) return;

    /// Cleared before validating so a rejected form never re-reports the
    /// previous submit's response.
    _responseCubit.onUpdateData(null);

    if (!(_formKey.currentState?.validate() ?? false)) return;

    _loadingCubit.onUpdateData(true);

    final ContactUsRequest request = ContactUsRequest(
      name: _nameController.text,
      email: _emailController.text,
      comment: _commentController.text,
      telephone: _phoneController.text,
    );

    try {
      final Map<String, dynamic> json = await _graphql.mutate(
        GraphQLDocuments.submitContactForm,
        variables: request.toVariables(),
      );

      final SubmitContactFormResponse response =
          SubmitContactFormResponse.fromJson(json);

      if (response.status) _clearForm();

      _responseCubit.onUpdateData(response);
    } catch (_) {
      _responseCubit.onUpdateData(
        const SubmitContactFormResponse(status: false),
      );
    } finally {
      _loadingCubit.onUpdateData(false);
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _commentController.clear();

    /// Drops the error text the fields are still showing from the last
    /// `validate()` call.
    _formKey.currentState?.reset();
  }
}
