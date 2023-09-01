import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'constants.dart';
import 'login_state.dart';
import 'ui/create_account.dart';
import 'ui/details.dart';
import 'ui/home_screen.dart';
import 'ui/login.dart';
import 'ui/error_page.dart';
import 'ui/more_info.dart';
import 'ui/payment.dart';
import 'ui/personal_info.dart';
import 'ui/signin_info.dart';

class MyRouter {
  final LoginState loginState;
  MyRouter(this.loginState);

  late final router = GoRouter(
      initialLocation: '/login',
      errorBuilder: (context, state) {
        return ErrorPage(
          error: state.error,
        );
      },
/*      errorPageBuilder: (context, state) {
        return MaterialPage<void>(child: ErrorPage());
      },*/
      routes: [
        GoRoute(
          path: '/login',
          name: loginRouteName,
          builder: (context, state) {
            return const Login();
          },
        ),
        GoRoute(
          path: '/create-account',
          name: createAccountRouteName,
          builder: (context, state) {
            return const CreateAccount();
          },
        ),
        GoRoute(
            path: '/:tab',
            name: rootRouteName,
            builder: (context, state) {
              final tab = state.pathParameters['tab'];
              return HomeScreen(
                tab: tab ?? '',
              );
            },
            routes: [
              GoRoute(
                name: profilePersonalRouteName,
                path: 'personal-personal',
                builder: (context, state) {
                  return const PersonalInfo();
                },
              ),
              GoRoute(
                name: shopDetailsRouteName,
                path: 'details/:item',
                builder: (context, state) {
                  return Details(
                    description: state.pathParameters['item']!,
                    extra: state.extra,
                  );
                },
              ),
              GoRoute(
                name: profilePaymentRouteName,
                path: 'payment',
                builder: (context, state) {
                  return const Payment();
                },
              ),
              GoRoute(
                name: profileSigninInfoRouteName,
                path: 'signin-info',
                builder: (context, state) {
                  return const SigninInfo();
                },
              ),
              GoRoute(
                name: profileMoreInfoRouteName,
                path: 'more-info',
                builder: (context, state) {
                  return const MoreInfo();
                },
              ),
            ])
      ],
      redirect: (context, state) {
        final loggedIn = loginState.loggedIn;
        final inAuthPages = state.location.contains(loginRouteName) ||
            state.location.contains(createAccountRouteName);

        //inAuth && true => go to home
        if (inAuthPages && loggedIn) return '/shop';
        //notInAuth && false => go to loginPage
        if (!inAuthPages && !loggedIn) return '/login';
      },
      refreshListenable: loginState,
      debugLogDiagnostics: true);
}
