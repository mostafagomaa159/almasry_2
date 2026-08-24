part of '../address_form_imports.dart';

class AddressFormView extends StatefulWidget {
  final AddressFormArgs? args;

  const AddressFormView({super.key, this.args});

  @override
  State<AddressFormView> createState() => _AddressFormViewState();
}

class _AddressFormViewState extends State<AddressFormView> {
  final AddressFormViewModel vm = AddressFormViewModel();

  @override
  void initState() {
    super.initState();
    vm._init(args: widget.args);
  }

  /// The governorate list is fetched here rather than in [initState]: choosing
  /// the store view means reading the locale, and that needs a settled
  /// `BuildContext`. The ViewModel guards against the repeat calls this gets.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vm._loadRegions(context);
  }

  @override
  void dispose() {
    vm._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: <Widget>[
          CustomAppBar(title: vm._title(), onBack: vm._back),
          Expanded(child: AddressFormBody(vm: vm)),
        ],
      ),
    );
  }
}
