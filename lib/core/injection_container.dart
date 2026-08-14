import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/datasources/product_local_datasource.dart';
import '../data/datasources/product_local_datasource_impl.dart';
import '../data/datasources/product_remote_datasource.dart';
import '../data/datasources/product_remote_datasource_impl.dart';
import '../data/repositories/product_repository_impl.dart';
import '../domain/repositories/product_repository.dart';
import '../domain/usecases/create_product.dart';
import '../domain/usecases/delete_product.dart';
import '../domain/usecases/update_product.dart';
import '../domain/usecases/view_all_products.dart';
import '../domain/usecases/view_product.dart';
import '../presentation/bloc/product/product_bloc.dart';
import 'network/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============================================================
  // BLoC
  // ============================================================

  sl.registerFactory<ProductBloc>(
    () => ProductBloc(
      productRepository: sl(),
    ),
  );

  // ============================================================
  // USE CASES
  // ============================================================

  sl.registerLazySingleton<ViewAllProducts>(
    () => ViewAllProducts(sl()),
  );

  sl.registerLazySingleton<ViewProduct>(
    () => ViewProduct(sl()),
  );

  sl.registerLazySingleton<CreateProduct>(
    () => CreateProduct(sl()),
  );

  sl.registerLazySingleton<UpdateProduct>(
    () => UpdateProduct(sl()),
  );

  sl.registerLazySingleton<DeleteProduct>(
    () => DeleteProduct(sl()),
  );

  // ============================================================
  // REPOSITORY
  // ============================================================

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // ============================================================
  // DATA SOURCES
  // ============================================================

  sl.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSourceImpl(
      sharedPreferences: sl(),
    ),
  );

  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(
      dio: sl(),
    ),
  );

  // ============================================================
  // CORE
  // ============================================================

  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(sl()),
  );

  // ============================================================
  // EXTERNAL
  // ============================================================

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<InternetConnection>(() => InternetConnection());
}