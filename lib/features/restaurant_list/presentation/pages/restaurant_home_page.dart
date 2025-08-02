import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/network/dio_client.dart';
import '../../data/datasources/restaurant_remote_datasource.dart';
import '../../data/repositories/restaurant_repository_impl.dart';
import '../../domain/usecases/get_restaurants.dart';
import '../../domain/usecases/search_restaurants.dart';
import '../providers/restaurant_list_provider.dart';
import 'restaurant_list_page.dart';

class RestaurantHomePage extends StatelessWidget {
  const RestaurantHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final dioClient = DioClient();
        final remoteDataSource = RestaurantRemoteDataSourceImpl(
          dioClient: dioClient,
        );
        final repository = RestaurantRepositoryImpl(
          remoteDataSource: remoteDataSource,
        );
        final getRestaurants = GetRestaurants(repository);
        final searchRestaurants = SearchRestaurants(repository);

        return RestaurantListProvider(
          getRestaurants: getRestaurants,
          searchRestaurants: searchRestaurants,
        );
      },
      child: const RestaurantListPage(),
    );
  }
}
