part of '../contact_us_imports.dart';

/// Drives the contact form: field controllers, validation, and the submit
/// mutation whose result is reported through [AlertService].
class ContactUsViewModel {
  final GraphQLService _graphql = sl<GraphQLService>();
  final NavigationService _nav = sl<NavigationService>();
  final AlertService _alert = sl<AlertService>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GenericCubit<bool> _loadingCubit = GenericCubit<bool>(false);

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _commentController;

  late final FocusNode _nameFocusNode;
  late final FocusNode _emailFocusNode;
  late final FocusNode _phoneFocusNode;
  late final FocusNode _commentFocusNode;

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
  }

  void _back() {
    _nav.pop();
  }

  String? _validateName(String? value) => Validators.validateName(value ?? '');

  String? _validateEmail(String? value) =>
      Validators.validateEmail(value ?? '');

  String? _validatePhone(String? value) {
    final String phone = value ?? '';
    return phone.trim().isEmpty ? null : Validators.validatePhone(phone);
  }

  String? _validateComment(String? value) =>
      Validators.validateComment(value ?? '');

  Future<void> _submit() async {
    if (_loadingCubit.state.data) return;

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

      if (!response.status) {
        _alert.showError(LocaleKeys.contactUsFailed.tr());

        return;
      }

      _clearForm();

      _alert.showSuccess(LocaleKeys.contactUsSuccess.tr());
    } catch (_) {
      _alert.showError(LocaleKeys.contactUsFailed.tr());
    } finally {
      _loadingCubit.onUpdateData(false);
    }
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _commentController.clear();

    _formKey.currentState?.reset();
  }
}
