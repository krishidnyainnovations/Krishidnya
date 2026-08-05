import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:krishidnya/core/config/providers.dart';
import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/errors/failures.dart';
import 'package:krishidnya/core/services/location_service.dart';
import 'package:krishidnya/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:krishidnya/features/auth/domain/entities/location_data.dart';
import 'package:krishidnya/features/auth/domain/entities/user.dart';

/// Registration form state held during the multi-step journey.
class RegistrationState extends Equatable {
  const RegistrationState({
    this.fullName = '',
    this.email = '',
    this.mobile = '',
    this.password = '',
    this.confirmPassword = '',
    this.location,
    this.step = RegistrationStep.createAccount,
    this.isLoading = false,
    this.error,
  });

  final String fullName;
  final String email;
  final String mobile;
  final String password;
  final String confirmPassword;
  final LocationData? location;
  final RegistrationStep step;
  final bool isLoading;
  final Failure? error;

  RegistrationState copyWith({
    String? fullName,
    String? email,
    String? mobile,
    String? password,
    String? confirmPassword,
    LocationData? location,
    RegistrationStep? step,
    bool? isLoading,
    Failure? error,
    bool clearError = false,
  }) =>
      RegistrationState(
        fullName: fullName ?? this.fullName,
        email: email ?? this.email,
        mobile: mobile ?? this.mobile,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        location: location ?? this.location,
        step: step ?? this.step,
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : (error ?? this.error),
      );

  bool get isFormValid =>
      fullName.trim().isNotEmpty &&
      email.trim().isNotEmpty &&
      mobile.trim().length >= 10 &&
      password.length >= 6 &&
      password == confirmPassword;

  @override
  List<Object?> get props => [
        fullName,
        email,
        mobile,
        password,
        confirmPassword,
        location,
        step,
        isLoading,
        error,
      ];
}

enum RegistrationStep {
  createAccount,
  locationPermission,
  locationLoading,
  locationFound,
  almostReady,
  success,
}

/// Controls the registration journey state machine.
class RegistrationController extends StateNotifier<RegistrationState> {
  RegistrationController({
    required AuthRepositoryImpl repository,
    required LocationService locationService,
  })  : _repository = repository,
        _locationService = locationService,
        super(const RegistrationState());

  final AuthRepositoryImpl _repository;
  final LocationService _locationService;

  void updateForm({
    String? fullName,
    String? email,
    String? mobile,
    String? password,
    String? confirmPassword,
  }) {
    state = state.copyWith(
      fullName: fullName,
      email: email,
      mobile: mobile,
      password: password,
      confirmPassword: confirmPassword,
      clearError: true,
    );
  }

  void goToLocationPermission() {
    if (!state.isFormValid) return;
    state = state.copyWith(step: RegistrationStep.locationPermission);
  }

  Future<void> requestLocation() async {
    state = state.copyWith(
      step: RegistrationStep.locationLoading,
      isLoading: true,
      clearError: true,
    );

    final granted = await _locationService.requestPermission();
    if (!granted) {
      state = state.copyWith(
        step: RegistrationStep.almostReady,
        isLoading: false,
      );
      await _completeRegistration();
      return;
    }

    final result = await _locationService.getCurrentLocation();
    switch (result) {
      case Success(:final data):
        state = state.copyWith(
          location: data,
          step: RegistrationStep.locationFound,
          isLoading: false,
        );
      case ErrorResult(:final failure):
        state = state.copyWith(
          step: RegistrationStep.almostReady,
          isLoading: false,
          error: failure,
        );
        await _completeRegistration();
    }
  }

  Future<void> confirmLocation() async {
    state = state.copyWith(step: RegistrationStep.almostReady);
    await _completeRegistration();
  }

  Future<void> skipLocation() async {
    state = state.copyWith(step: RegistrationStep.almostReady);
    await _completeRegistration();
  }

  Future<void> _completeRegistration() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.register(
      email: state.email.trim(),
      password: state.password,
      mobile: state.mobile.trim(),
      fullName: state.fullName.trim(),
      location: state.location,
    );

    switch (result) {
      case Success():
        if (state.location != null) {
          await _repository.updateLocation(
            latitude: state.location!.latitude,
            longitude: state.location!.longitude,
            location: state.location!.displayLocation,
            city: state.location!.city,
            state: state.location!.state,
          );
        }
        state = state.copyWith(
          step: RegistrationStep.success,
          isLoading: false,
        );
      case ErrorResult(:final failure):
        state = state.copyWith(
          isLoading: false,
          error: failure,
          step: RegistrationStep.createAccount,
        );
    }
  }

  void reset() => state = const RegistrationState();
}

final registrationControllerProvider =
    StateNotifierProvider<RegistrationController, RegistrationState>((ref) {
  return RegistrationController(
    repository: ref.watch(authRepositoryProvider),
    locationService: ref.watch(locationServiceProvider),
  );
});

/// Login form state.
class LoginState extends Equatable {
  const LoginState({
    this.mobile = '',
    this.password = '',
    this.isLoading = false,
    this.error,
    this.isSuccess = false,
  });

  final String mobile;
  final String password;
  final bool isLoading;
  final Failure? error;
  final bool isSuccess;

  bool get isValid => mobile.trim().length >= 10 && password.isNotEmpty;

  LoginState copyWith({
    String? mobile,
    String? password,
    bool? isLoading,
    Failure? error,
    bool? isSuccess,
    bool clearError = false,
  }) =>
      LoginState(
        mobile: mobile ?? this.mobile,
        password: password ?? this.password,
        isLoading: isLoading ?? this.isLoading,
        error: clearError ? null : (error ?? this.error),
        isSuccess: isSuccess ?? this.isSuccess,
      );

  @override
  List<Object?> get props => [mobile, password, isLoading, error, isSuccess];
}

class LoginController extends StateNotifier<LoginState> {
  LoginController({required AuthRepositoryImpl repository})
      : _repository = repository,
        super(const LoginState());

  final AuthRepositoryImpl _repository;

  void updateMobile(String value) =>
      state = state.copyWith(mobile: value, clearError: true);

  void updatePassword(String value) =>
      state = state.copyWith(password: value, clearError: true);

  Future<void> login() async {
    if (!state.isValid) return;

    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _repository.login(
      mobile: state.mobile.trim(),
      password: state.password,
    );

    switch (result) {
      case Success():
        state = state.copyWith(isLoading: false, isSuccess: true);
      case ErrorResult(:final failure):
        state = state.copyWith(isLoading: false, error: failure);
    }
  }
}

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
  return LoginController(repository: ref.watch(authRepositoryProvider));
});

/// Current authenticated user.
final currentUserProvider = FutureProvider<User?>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  final result = await repository.getCurrentUser();
  return switch (result) {
    Success(:final data) => data,
    ErrorResult() => null,
  };
});

/// Auth status check for routing.
final authStatusProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(authRepositoryProvider);
  return repository.isAuthenticated();
});

/// Refreshes cached auth state after login or registration.
Future<void> refreshAuthSession(WidgetRef ref) async {
  ref.invalidate(currentUserProvider);
  await ref.refresh(authStatusProvider.future);
}
