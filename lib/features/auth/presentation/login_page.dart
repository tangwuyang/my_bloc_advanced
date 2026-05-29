import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:my_bloc_advanced/l10n/app_localizations.dart';

import '../../../core/testing/app_key_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final GlobalKey<FormBuilderState> _loginFormKey = GlobalKey<FormBuilderState>(
    debugLabel: '__loginFormKey__',
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(
    debugLabel: '__loginScaffoldKey__',
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6000),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 675;
            print(constraints.maxWidth);
            print('m ${MediaQuery.of(context).size.width}');
            return isDesktop ? _desktopLayout(context) : _mobileLayout(context);
          },
        ),
      ),
    );
  }

  _desktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 55, child: Text("introduction")),
        Expanded(flex: 45, child: _formPanel()),
      ],
    );
  }

  _mobileLayout(BuildContext context) {
    return Text("mobile");
  }

  Widget _formPanel() {
    return Container(
      child: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400),
                child: FadeTransition(
                  opacity: _controller,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _brandIcon(),
                      const SizedBox(height: 32),
                      _formHeading(context),
                      const SizedBox(height: 32),
                      _formBody(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _brandIcon() {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Icon(Icons.bolt_rounded, size: 24, color: cs.onSurface),
    );
  }

  _formHeading(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          "Welcome back",
          style: tt.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
            color: cs.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your credentials to access your account',
          style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
        ),
      ],
    );
  }

  _formBody(BuildContext context) {
    return FormBuilder(
      key: _loginFormKey,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          _fieldLabel(context, AppLocalizations.of(context)!.login_user_name),
          const SizedBox(height: 8),
          _usernameField(context),
          const SizedBox(height: 20),
          _fieldLabel(context, AppLocalizations.of(context)!.login_password),
          _passwordField(context),
          const SizedBox(height: 8),
          SizedBox(width: double.infinity, child: _submitButton(context)),
        ],
      ),
    );
  }

  Widget _fieldLabel(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
    );
  }

  Widget _usernameField(BuildContext context) {
    return FormBuilderTextField(
      key: loginTextFieldUsernameKey,
      name: 'username',
      decoration: const InputDecoration(hintText: 'm@example.com'),
      textInputAction: TextInputAction.next,
      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "Required Field"),
        FormBuilderValidators.minLength(
          4,
          errorText: "Field must be at least 4 characters long",
        ),
        FormBuilderValidators.maxLength(
          20,
          errorText: "Field cannot be more than 20 characters long",
        ),
      ]),
    );
  }

  Widget? _submitButton(BuildContext context) {
    return FilledButton(
      onPressed: () {
        _trySubmit(context);
      },
      child: Text(AppLocalizations.of(context)!.login_button),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.black),
      ),
    );
  }

  void _trySubmit(BuildContext context) {
    if (_loginFormKey.currentState?.saveAndValidate() ?? false) {
      final username = _loginFormKey.currentState?.value['username'];
      final password = _loginFormKey.currentState?.value['password'];
    }
  }

  _passwordField(BuildContext context) {
    return FormBuilderTextField(
      key: loginTextFieldPasswordKey,
      name: 'password',
      decoration: InputDecoration(
        hintText: '********',

      ),
      textInputAction: TextInputAction.done,
      onSubmitted: (_) => _trySubmit(context),

      validator: FormBuilderValidators.compose([
        FormBuilderValidators.required(errorText: "required_field"),
        FormBuilderValidators.minLength(4, errorText: "password_min_length"),
        FormBuilderValidators.maxLength(20, errorText: "password_max_length"),
      ]),
    );
  }
}
