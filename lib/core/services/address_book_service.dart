import 'package:almasry_2/core/base/bloc/generic_cubit.dart';
import 'package:almasry_2/core/base/locator/locator.dart';
import 'package:almasry_2/core/constants/pref_keys.dart';
import 'package:almasry_2/core/models/response/checkout/address_model.dart';
import 'package:almasry_2/core/services/cache_manager_service.dart';

class AddressBookService {
  final GenericCubit<List<AddressModel>> addressesCubit =
      GenericCubit<List<AddressModel>>(const []);

  CacheManagerService get _cache => sl<CacheManagerService>();

  List<AddressModel> get addresses => addressesCubit.state.data;

  AddressModel? get defaultAddress {
    final List<AddressModel> current = addresses;

    if (current.isEmpty) return null;

    for (final AddressModel address in current) {
      if (address.isDefault) return address;
    }

    return current.first;
  }

  Future<void> load() async {
    final List<AddressModel> stored = await _cache.getCachedData<AddressModel>(
      key: PrefKeys.savedAddresses,
      fromJson: AddressModel.fromJson,
    );

    addressesCubit.onUpdateData(stored);
  }

  Future<void> save(AddressModel address) async {
    final List<AddressModel> next = List<AddressModel>.from(addresses);

    final int index = next.indexWhere(
      (AddressModel item) => item.id == address.id,
    );

    final AddressModel resolved = next.isEmpty
        ? AddressModel.flagged(address, isDefault: true)
        : address;

    if (index == -1) {
      next.add(resolved);
    } else {
      next[index] = resolved;
    }

    await _commit(resolved.isDefault ? _withDefault(next, resolved.id) : next);
  }

  Future<void> remove(String id) async {
    final List<AddressModel> next = addresses
        .where((AddressModel address) => address.id != id)
        .toList();

    final bool needsDefault =
        next.isNotEmpty &&
        !next.any((AddressModel address) => address.isDefault);

    await _commit(needsDefault ? _withDefault(next, next.first.id) : next);
  }

  Future<void> setDefault(String id) => _commit(_withDefault(addresses, id));

  void dispose() {
    addressesCubit.close();
  }

  List<AddressModel> _withDefault(List<AddressModel> source, String id) {
    return source
        .map(
          (AddressModel address) =>
              AddressModel.flagged(address, isDefault: address.id == id),
        )
        .toList();
  }

  Future<void> _commit(List<AddressModel> next) async {
    addressesCubit.onUpdateData(next);

    await _cache.cacheData<AddressModel>(
      data: next,
      key: PrefKeys.savedAddresses,
      toJson: (AddressModel address) => address.toJson(),
    );
  }
}
