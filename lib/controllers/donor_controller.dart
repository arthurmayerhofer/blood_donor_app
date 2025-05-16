import '../services/donor_service.dart';
import '../stores/donor_store.dart';

class DonorController {
  final DonorService _service;
  final DonorStore _store;

  DonorController(this._service, this._store);

  Future<void> fetchDonorsByState() async {
    _store.setLoading(true);
    try {
      final data = await _service.getDonorCountByState();
      _store.setDonorsByState(data);
    } catch (e) {
      _store.setError(e.toString());
    } finally {
      _store.setLoading(false);
    }
  }
}
