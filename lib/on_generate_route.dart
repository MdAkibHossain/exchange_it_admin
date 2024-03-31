import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'core/model/page_arguments_model.dart';
import 'features/active_account/presentation/view/active_account.dart';
import 'features/order_details/presentation/view/order_details.dart';
import 'features/revenue/presentation/view/revenue_screen.dart';
import 'features/dollar_rate/presentation/view/dollar_rate_screen.dart';
import 'features/history/presentation/view/order_history.dart';
import 'features/home/presentation/view/home_screen.dart';
import 'features/splash/presentation/view/splash_screen.dart';
import 'route_name.dart';

class AppRouter {
  Route? onGeneratedRoute(RouteSettings? route) {
    switch (route!.name) {
      case RouteName.root:
        var arg = route.arguments as PageRouteArguments;
        return PageTransition(
          child: HomeScreen(
            arguments: arg,
          ),
          type: PageTransitionType.fade,
        );
      case RouteName.home:
        var arg = route.arguments as PageRouteArguments;
        return PageTransition(
          child: HomeScreen(
            arguments: arg,
          ),
          type: PageTransitionType.fade,
        );

      case RouteName.splashScreen:
        var arg = route.arguments as PageRouteArguments;
        return PageTransition(
          child: SplashScreen(
            arguments: arg,
          ),
          type: PageTransitionType.fade,
        );
      case RouteName.dollarRateInputScreen:
        var arg = route.arguments as PageRouteArguments;
        return PageTransition(
          child: DollarRateScreen(
            arguments: arg,
          ),
          type: PageTransitionType.fade,
        );
      case RouteName.orderDetailsScreen:
        var arg = route.arguments as PageRouteArguments;
        return PageTransition(
          child: OrderDetailsScreen(
            arguments: arg,
          ),
          type: PageTransitionType.fade,
        );
      case RouteName.revenueScreen:
        var arg = route.arguments as PageRouteArguments;
        return PageTransition(
          child: RevenueScreen(
            arguments: arg,
          ),
          type: PageTransitionType.fade,
        );
      case RouteName.orderHistoryScreen:
        //var arg = route.arguments as PageRouteArguments;
        return PageTransition(
          child: const OrderHistoryScreen(),
          type: PageTransitionType.fade,
        );
      case RouteName.activeAccount:
        //var arg = route.arguments as PageRouteArguments;
        return PageTransition(
          child: ActiveAccount(),
          type: PageTransitionType.fade,
        );

      default:
        return _errorRoute();
    }
  }

  // AppRouter._(); CheckOutScreen
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: const Text("ERROR"),
          centerTitle: true,
        ),
        body: const Center(
          child: Text("Page not found!"),
        ),
      ),
    );
  }
}
