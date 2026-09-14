abstract interface class DeviceIdentityProvider {
  Future<String> getDeviceId();
}

final class StaticDeviceIdentityProvider implements DeviceIdentityProvider {
  final String deviceId;
  const StaticDeviceIdentityProvider({required this.deviceId});

  @override
  Future<String> getDeviceId() async => deviceId;
}
