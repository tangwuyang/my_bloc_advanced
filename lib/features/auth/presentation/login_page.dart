import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,duration: const Duration(milliseconds: 6000));
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
                  child: Column(children: [_brandIcon(),
                  Text("test")]),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Icon(Icons.bolt_rounded,size: 24,color: cs.onSurface,),
    );
  }
}
