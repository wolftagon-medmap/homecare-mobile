import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:m2health/core/config/feature_flags.dart';
import 'package:m2health/features/guided_booking/data/datasources/guided_booking_datasource.dart';
import 'package:m2health/features/guided_booking/data/datasources/guided_booking_local_datasource.dart';
import 'package:m2health/features/guided_booking/data/datasources/guided_booking_remote_datasource.dart';
import 'package:m2health/features/guided_booking/data/repositories/guided_booking_repository_impl.dart';
import 'package:m2health/features/guided_booking/domain/repositories/guided_booking_repository.dart';
import 'package:m2health/features/guided_booking/domain/usecases/guided_booking_usecases.dart';
import 'package:m2health/features/guided_booking/guided_booking_routes.dart';
import 'package:m2health/features/guided_booking/presentation/bloc/guided_booking_cubit.dart';

void initGuidedBookingModule(GetIt sl) {
  sl.registerLazySingleton<IssueCatalogueDataSource>(
    () => AppFlags.remote(Feature.issueCatalogue)
        ? IssueCatalogueRemoteDataSource(sl<Dio>())
        : IssueCatalogueLocalDataSource(),
  );

  sl.registerLazySingleton<BookingProfessionalDataSource>(
    () => AppFlags.remote(Feature.bookingProfessionals)
        ? BookingProfessionalRemoteDataSource(sl<Dio>())
        : BookingProfessionalLocalDataSource(),
  );

  sl.registerLazySingleton<BookingSubmissionDataSource>(
    () => AppFlags.remote(Feature.bookingSubmit)
        ? BookingSubmissionRemoteDataSource(sl<Dio>())
        : BookingSubmissionLocalDataSource(),
  );

  sl.registerLazySingleton<BookingAddressDataSource>(
    () => AppFlags.remote(Feature.bookingAddresses)
        ? BookingAddressRemoteDataSource(sl<Dio>())
        : BookingAddressLocalDataSource(),
  );

  sl.registerLazySingleton<BookingDraftDataSource>(
    () => AppFlags.remote(Feature.bookingDraft)
        ? BookingDraftRemoteDataSource(sl<Dio>())
        : BookingDraftLocalDataSource(sl<SharedPreferences>()),
  );

  sl.registerLazySingleton<IssueCatalogueRepository>(
    () => IssueCatalogueRepositoryImpl(sl<IssueCatalogueDataSource>()),
  );
  sl.registerLazySingleton<BookingProfessionalRepository>(
    () =>
        BookingProfessionalRepositoryImpl(sl<BookingProfessionalDataSource>()),
  );
  sl.registerLazySingleton<BookingAddressRepository>(
    () => BookingAddressRepositoryImpl(sl<BookingAddressDataSource>()),
  );
  sl.registerLazySingleton<BookingSubmissionRepository>(
    () => BookingSubmissionRepositoryImpl(sl<BookingSubmissionDataSource>()),
  );
  sl.registerLazySingleton<BookingDraftRepository>(
    () => BookingDraftRepositoryImpl(sl<BookingDraftDataSource>()),
  );

  sl.registerLazySingleton(
    () => GetIssueCatalogue(sl<IssueCatalogueRepository>()),
  );
  sl.registerLazySingleton(
    () => GetBookingProfessionals(sl<BookingProfessionalRepository>()),
  );
  sl.registerLazySingleton(
    () => GetBookingAvailability(sl<BookingProfessionalRepository>()),
  );
  sl.registerLazySingleton(
    () => GetVisitAddresses(sl<BookingAddressRepository>()),
  );
  sl.registerLazySingleton(
    () => SubmitBookingRequest(sl<BookingSubmissionRepository>()),
  );
  sl.registerLazySingleton(
    () => GetBookingRequest(sl<BookingSubmissionRepository>()),
  );
  sl.registerLazySingleton(
      () => LoadBookingDraft(sl<BookingDraftRepository>()));
  sl.registerLazySingleton(
      () => SaveBookingDraft(sl<BookingDraftRepository>()));
  sl.registerLazySingleton(
    () => ClearBookingDraft(sl<BookingDraftRepository>()),
  );

  sl.registerFactoryParam<GuidedBookingCubit, GuidedBookingArgs, void>(
    (args, _) => GuidedBookingCubit(
      category: args.category,
      subCategory: args.subCategory,
      getIssueCatalogue: sl<GetIssueCatalogue>(),
      getProfessionals: sl<GetBookingProfessionals>(),
      getAvailability: sl<GetBookingAvailability>(),
      getVisitAddresses: sl<GetVisitAddresses>(),
      submitRequest: sl<SubmitBookingRequest>(),
      loadDraft: sl<LoadBookingDraft>(),
      saveDraft: sl<SaveBookingDraft>(),
      clearDraft: sl<ClearBookingDraft>(),
    ),
  );
}
