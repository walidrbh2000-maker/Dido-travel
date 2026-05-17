import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voyageur/core/router/app_routes.dart';
import 'package:voyageur/domain/entities/vol_entity.dart';
import 'package:voyageur/providers/auth/auth_provider.dart';
import 'package:voyageur/providers/auth/auth_state.dart';
import 'package:voyageur/screens/splash/splash_screen.dart';
import 'package:voyageur/screens/onboarding/onboarding_screen.dart';
import 'package:voyageur/screens/auth/login_screen.dart';
import 'package:voyageur/screens/auth/register_screen.dart';
import 'package:voyageur/screens/main_navigation/main_navigation_screen.dart';
import 'package:voyageur/screens/home/home_screen.dart';
import 'package:voyageur/screens/vols/vols_search_screen.dart';
import 'package:voyageur/screens/vols/vols_list_screen.dart';
import 'package:voyageur/screens/vols/vol_detail_screen.dart';
import 'package:voyageur/screens/hotels/hotels_search_screen.dart';
import 'package:voyageur/screens/hotels/hotels_list_screen.dart';
import 'package:voyageur/screens/hotels/hotel_detail_screen.dart';
import 'package:voyageur/screens/reservations/reservations_screen.dart';
import 'package:voyageur/screens/reservations/reservation_detail_screen.dart';
import 'package:voyageur/screens/reservations/create_reservation_screen.dart';
import 'package:voyageur/screens/payment/payment_screen.dart';
import 'package:voyageur/screens/payment/payment_success_screen.dart';
import 'package:voyageur/screens/destinations/destinations_screen.dart';
import 'package:voyageur/screens/destinations/destination_detail_screen.dart';
import 'package:voyageur/screens/guides/guides_screen.dart';
import 'package:voyageur/screens/guides/guide_detail_screen.dart';
import 'package:voyageur/screens/profile/profile_screen.dart';
import 'package:voyageur/screens/profile/edit_profile_screen.dart';
// ── Booking flow ──────────────────────────────────────────────────────────
import 'package:voyageur/screens/booking/trip_type_screen.dart';
import 'package:voyageur/screens/booking/booking_return_flight_screen.dart';
import 'package:voyageur/screens/booking/passenger_count_screen.dart';
import 'package:voyageur/screens/booking/passenger_details_screen.dart';
import 'package:voyageur/screens/booking/seat_selection_screen.dart';
import 'package:voyageur/screens/booking/booking_add_extras_screen.dart';
import 'package:voyageur/screens/booking/booking_summary_screen.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

/// Routes that guests (unauthenticated) are allowed to access.
const _guestAllowedRoutes = {
  AppRoutes.home,
  AppRoutes.vols,
  AppRoutes.volList,
  AppRoutes.hotels,
  AppRoutes.hotelList,
  AppRoutes.destinations,
  AppRoutes.guides,
};

bool _isGuestAllowed(String location) {
  // Exact match
  if (_guestAllowedRoutes.contains(location)) return true;
  // Prefix match for detail pages guests can browse
  if (location.startsWith('/vols/')) return true;
  if (location.startsWith('/hotels/')) return true;
  if (location.startsWith('/destinations/')) return true;
  if (location.startsWith('/guides/')) return true;
  return false;
}

GoRouter _buildRouter(Ref<GoRouter> ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      // Still initialising — don't redirect yet
      if (authState is AuthInitial || authState is AuthLoading) return null;

      final isAuthenticated = authState is AuthAuthenticated;
      final isGuest = authState is AuthGuest;
      final loc = state.matchedLocation;
      final isAuthRoute = loc.startsWith('/auth');
      final isPublicRoute =
          loc == AppRoutes.splash || loc == AppRoutes.onboarding || isAuthRoute;

      // Fully authenticated users
      if (isAuthenticated && isAuthRoute) return AppRoutes.home;

      // Guest users: allow browse-only routes
      if (isGuest) {
        if (isAuthRoute) return AppRoutes.home; // already in guest home
        if (isPublicRoute) return null;
        if (_isGuestAllowed(loc)) return null;
        // Block everything else (booking, reservations, profile, payment)
        // — the individual screens also show GuestBarrier widgets,
        // but the router adds a safety net so the URL cannot be deep-linked.
        return AppRoutes.home;
      }

      // Unauthenticated users — send to login for protected routes
      if (!isAuthenticated && !isPublicRoute) return AppRoutes.login;

      return null;
    },
    routes: [
      // ── Routes publiques ──────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),

      // ── Shell (bottom nav) ─────────────────────────────────────────────────
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => MainNavigationScreen(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomeScreen()),
          ),
          GoRoute(
            path: AppRoutes.vols,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: VolsSearchScreen()),
          ),
          GoRoute(
            path: AppRoutes.hotels,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HotelsSearchScreen()),
          ),
          GoRoute(
            path: AppRoutes.reservations,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ReservationsScreen()),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfileScreen()),
          ),
        ],
      ),

      // ── Routes de détail ──────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.destinations,
        builder: (context, state) => const DestinationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.destinationDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DestinationDetailScreen(destinationId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.volList,
        builder: (context, state) => const VolsListScreen(),
      ),
      GoRoute(
        path: AppRoutes.volDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return VolDetailScreen(volId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.hotelList,
        builder: (context, state) => const HotelsListScreen(),
      ),
      GoRoute(
        path: AppRoutes.hotelDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return HotelDetailScreen(hotelId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.createReservation,
        builder: (context, state) => const CreateReservationScreen(),
      ),
      GoRoute(
        path: AppRoutes.reservationDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ReservationDetailScreen(reservationId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.payment,
        builder: (context, state) => const PaymentScreen(),
      ),
      GoRoute(
        path: AppRoutes.paymentSuccess,
        builder: (context, state) => const PaymentSuccessScreen(),
      ),
      GoRoute(
        path: AppRoutes.guides,
        builder: (context, state) => const GuidesScreen(),
      ),
      GoRoute(
        path: AppRoutes.guideDetail,
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return GuideDetailScreen(guideId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),

      // ── Booking flow ───────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.bookingTripType,
        builder: (context, state) {
          final vol = state.extra as VolEntity;
          return TripTypeScreen(outboundFlight: vol);
        },
      ),
      GoRoute(
        path: AppRoutes.bookingReturnFlight,
        builder: (context, state) => const BookingReturnFlightScreen(),
      ),
      GoRoute(
        path: AppRoutes.bookingPassengers,
        builder: (context, state) => const PassengerCountScreen(),
      ),
      GoRoute(
        path: AppRoutes.bookingPassengerDetails,
        builder: (context, state) => const PassengerDetailsScreen(),
      ),
      GoRoute(
        path: AppRoutes.bookingSeatOutbound,
        builder: (context, state) =>
            const SeatSelectionScreen(isReturn: false),
      ),
      GoRoute(
        path: AppRoutes.bookingSeatReturn,
        builder: (context, state) =>
            const SeatSelectionScreen(isReturn: true),
      ),
      GoRoute(
        path: AppRoutes.bookingExtras,
        builder: (context, state) => const BookingAddExtrasScreen(),
      ),
      GoRoute(
        path: AppRoutes.bookingSummary,
        builder: (context, state) => const BookingSummaryScreen(),
      ),
    ],
  );
}

final routerProvider = Provider<GoRouter>(_buildRouter);
