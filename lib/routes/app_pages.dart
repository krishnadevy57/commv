import 'package:commv/bindings/booking_binding.dart';
import 'package:commv/screens/landing/driver_acceptance_screen.dart';
import 'package:commv/screens/landing/package_sending_screen.dart';
import 'package:commv/screens/landing/review_booking_order_screen.dart';
import 'package:commv/screens/landing/select_vehicle_screen.dart';
import 'package:get/get.dart';
import '../bindings/initial_binding.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../screens/auth/signup_screen.dart';
import '../screens/landing/connect_to_driver_screen.dart';
import '../screens/landing/landing_screen.dart';
import '../bindings/auth_binding.dart';
import '../screens/landing/order_detail_screen.dart';
import '../screens/landing/select_address_from_map.dart';
import '../screens/landing/select_package_type.dart';
import '../screens/splash/splash_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => SplashScreen(),
      binding: InitialBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => OtpScreen(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => SignUpScreen(),
    ),
    GetPage(
      name: AppRoutes.landing,
      page: () => LandingScreen(),
      binding: BookingBinding()
    ),
    GetPage(
      name: AppRoutes.package_sending,
      page: () => PackageSendScreen(),
    ),
    GetPage(
      name: AppRoutes.select_vehicle,
      page: () => SelectVehicleScreen(),
    ),
    GetPage(
      name: AppRoutes.order_detail_screen,
      page: () => OrderDetailsScreen(),
    ),

    GetPage(
      name: AppRoutes.select_address_screen,
      page: () => AddressPickerScreen(),
    ),

    GetPage(
      name: AppRoutes.select_package_type_screen,
      page: () => SelectPackageTypeScreen(),
    ),

    GetPage(
      name: AppRoutes.review_booking_order_screen,
      page: () => ReviewBookingOrderScreen(),
    ),
    GetPage(
      name: AppRoutes.connect_to_driver_screen,
      page: () => ConnectToDriverScreen(),
    ),
    GetPage(
      name: AppRoutes.driver_acceptance_screen,
      page: () => DriverAcceptanceScreen(),
    ),
  ];
}
