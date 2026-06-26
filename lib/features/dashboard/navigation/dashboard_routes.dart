
import 'package:go_router/go_router.dart';
import '../../../app/router/app_routes_constants.dart';
import '../../../shared/design_system/components/app_page_transition.dart';
import '../presentation/pages/dashboard_home_page.dart';

class DashboardFeatureRoutes {
  static final List<GoRoute> routes = [
    GoRoute(
      name: 'home',
      path: ApplicationRoutesConstants.home,
      pageBuilder: (context, state) =>
          appTransitionPage(state: state, type: AppPageTransitionType.fade, child: const DashboardHomePage()),
    ),
  ];
}
