part of '../../../../features/address_form/address_form_imports.dart';

/// The governorate list is the only thing on this form that has to be fetched,
/// so the status describes that fetch alone. The text fields need no state —
/// their controllers hold it.
enum RegionsStatus { loading, success, error }

class AddressFormData extends Equatable {
  final RegionsStatus status;
  final List<RegionModel> regions;

  /// Magento's `region_id`. Null until the user picks, which is what the
  /// dropdown's validator rejects.
  final int? selectedRegionId;

  final bool isSaving;
  final String errorMessage;

  const AddressFormData({
    this.status = RegionsStatus.loading,
    this.regions = const [],
    this.selectedRegionId,
    this.isSaving = false,
    this.errorMessage = '',
  });

  AddressFormData copyWith({
    RegionsStatus? status,
    List<RegionModel>? regions,
    int? selectedRegionId,
    bool? isSaving,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool clearSelectedRegion = false,
  }) {
    return AddressFormData(
      status: status ?? this.status,
      regions: regions ?? this.regions,
      selectedRegionId: clearSelectedRegion
          ? null
          : (selectedRegionId ?? this.selectedRegionId),
      isSaving: isSaving ?? this.isSaving,
      errorMessage: clearErrorMessage
          ? ''
          : (errorMessage ?? this.errorMessage),
    );
  }

  RegionModel? get selectedRegion {
    for (final RegionModel region in regions) {
      if (region.id == selectedRegionId) return region;
    }

    return null;
  }

  @override
  List<Object?> get props => [
    status,
    regions,
    selectedRegionId,
    isSaving,
    errorMessage,
  ];
}
