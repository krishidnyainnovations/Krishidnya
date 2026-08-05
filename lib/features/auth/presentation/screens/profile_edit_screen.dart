import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:krishidnya/core/config/providers.dart';
import 'package:krishidnya/core/errors/exception_mapper.dart';
import 'package:krishidnya/core/services/location_service.dart';
import 'package:krishidnya/core/theme/app_spacing.dart';
import 'package:krishidnya/features/auth/presentation/controllers/auth_controller.dart';
import 'package:krishidnya/features/home/presentation/controllers/home_providers.dart';
import 'package:krishidnya/widgets/buttons/primary_button.dart';
import 'package:krishidnya/widgets/feedback/app_snackbar.dart';
import 'package:krishidnya/widgets/inputs/app_text_field.dart';

/// Edit profile name, email, and location.
class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _locationCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _stateCtrl = TextEditingController();
  var _loading = false;
  var _updatingLocation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUser());
  }

  void _loadUser() {
    final user = ref.read(currentUserProvider).valueOrNull;
    if (user == null) return;
    _nameCtrl.text = user.fullName ?? '';
    _emailCtrl.text = user.email;
    _locationCtrl.text = user.location ?? '';
    _cityCtrl.text = user.city ?? '';
    _stateCtrl.text = user.state ?? '';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _locationCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _loading = true);
    final result = await ref.read(authRepositoryProvider).updateProfile(
          fullName: _nameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          location: _locationCtrl.text.trim(),
          city: _cityCtrl.text.trim(),
          state: _stateCtrl.text.trim(),
        );
    if (!mounted) return;
    setState(() => _loading = false);
    switch (result) {
      case Success():
        ref.invalidate(currentUserProvider);
        ref.invalidate(homeWeatherProvider);
        AppSnackBar.success(context, 'Profile updated');
        context.pop();
      case ErrorResult(:final failure):
        AppSnackBar.error(context, failure.message);
    }
  }

  Future<void> _updateGpsLocation() async {
    setState(() => _updatingLocation = true);
    final locationService = ref.read(locationServiceProvider);
    final granted = await locationService.requestPermission();
    if (!granted) {
      if (mounted) {
        setState(() => _updatingLocation = false);
        AppSnackBar.error(context, 'Location permission denied');
      }
      return;
    }

    final locResult = await locationService.getCurrentLocation();
    if (!mounted) return;

    switch (locResult) {
      case Success(:final data):
        final updateResult =
            await ref.read(authRepositoryProvider).updateLocation(
                  latitude: data.latitude,
                  longitude: data.longitude,
                  location: data.displayLocation,
                  city: data.city,
                  state: data.state,
                );
        if (!mounted) return;
        setState(() => _updatingLocation = false);
        switch (updateResult) {
          case Success(:final data):
            _locationCtrl.text = data.location ?? '';
            _cityCtrl.text = data.city ?? '';
            _stateCtrl.text = data.state ?? '';
            ref.invalidate(currentUserProvider);
            ref.invalidate(homeWeatherProvider);
            AppSnackBar.success(context, 'Location updated from GPS');
          case ErrorResult(:final failure):
            AppSnackBar.error(context, failure.message);
        }
      case ErrorResult(:final failure):
        setState(() => _updatingLocation = false);
        AppSnackBar.error(context, failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          AppTextField(label: 'Full Name', controller: _nameCtrl),
          const SizedBox(height: AppSpacing.md),
          AppTextField(label: 'Email', controller: _emailCtrl),
          const SizedBox(height: AppSpacing.md),
          AppTextField(label: 'Location', controller: _locationCtrl),
          const SizedBox(height: AppSpacing.md),
          AppTextField(label: 'City', controller: _cityCtrl),
          const SizedBox(height: AppSpacing.md),
          AppTextField(label: 'State', controller: _stateCtrl),
          const SizedBox(height: AppSpacing.lg),
          OutlinedButton.icon(
            onPressed: _updatingLocation ? null : _updateGpsLocation,
            icon: _updatingLocation
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.my_location),
            label: const Text('Update from GPS'),
          ),
          const SizedBox(height: AppSpacing.xl),
          PrimaryButton(
            label: 'Save Changes',
            isLoading: _loading,
            onPressed: _save,
          ),
        ],
      ),
    );
  }
}
