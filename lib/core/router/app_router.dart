
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/splash_screen.dart';
import '../../features/auth/presentation/onboarding_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/auth/presentation/forgot_password_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/invoices/presentation/invoices_screen.dart';
import '../../features/invoices/presentation/add_invoice_screen.dart';
import '../../features/invoices/presentation/invoice_details_screen.dart';
import '../../features/clients/presentation/clients_screen.dart';
import '../../features/clients/presentation/add_client_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'scaffold_with_nav_bar.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      if (authState.isLoading || !authState.hasValue) return null;

      final isAuth = authState.value?.session != null;
      final isSplash = state.uri.path == '/splash';
      final isGoingToAuth = state.uri.path.startsWith('/login') || 
                            state.uri.path.startsWith('/register') || 
                            state.uri.path.startsWith('/forgot-password') ||
                            state.uri.path.startsWith('/onboarding');

      if (isSplash) return null;

      if (!isAuth && !isGoingToAuth) return '/onboarding';
      if (isAuth && isGoingToAuth) return '/dashboard';

      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPasswordScreen()),
      
      ShellRoute(
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(path: '/dashboard', builder: (context, state) => const DashboardScreen()),
          GoRoute(
            path: '/invoices',
            builder: (context, state) => const InvoicesScreen(),
            routes: [
              GoRoute(path: 'add', builder: (context, state) => const AddInvoiceScreen()),
              GoRoute(
                path: ':id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return InvoiceDetailsScreen(invoiceId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/clients',
            builder: (context, state) => const ClientsScreen(),
            routes: [
              GoRoute(path: 'add', builder: (context, state) => const AddClientScreen()),
            ],
          ),
          GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
        ],
      ),
    ],
  );
});
