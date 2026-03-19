import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ribhi/features/reports/domain/repo/reportsRepo.dart';
import 'package:ribhi/features/reports/presentation/manager/cubit/reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final ReportsRepository repository;
  ReportsCubit({required this.repository}) : super(ReportsInitial());

  Future<void> loadDaily() async {
    emit(ReportsLoading());
    try {
      final report = await repository.getDailyReport(DateTime.now());
      emit(DailyReportLoaded(report));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }

  Future<void> loadMonthly() async {
    emit(ReportsLoading());
    try {
      final report = await repository.getMonthlyReport(DateTime.now());
      emit(MonthlyReportLoaded(report));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }

  Future<void> loadInventory() async {
    emit(ReportsLoading());
    try {
      final report = await repository.getInventoryReport();
      emit(InventoryReportLoaded(report));
    } catch (e) {
      emit(ReportsError(e.toString()));
    }
  }
}