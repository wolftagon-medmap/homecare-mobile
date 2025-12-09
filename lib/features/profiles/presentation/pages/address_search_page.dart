import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/profiles/domain/entities/place_detail.dart';
import 'package:m2health/features/profiles/domain/entities/place_suggestion.dart';
import 'package:m2health/features/profiles/presentation/bloc/address_search_cubit.dart';
import 'package:m2health/service_locator.dart';

class AddressSearchPage extends StatelessWidget {
  const AddressSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddressSearchCubit(
        searchPlaces: sl(),
        getPlaceDetails: sl(),
      ),
      child: const _AddressSearchView(),
    );
  }
}

class _AddressSearchView extends StatefulWidget {
  const _AddressSearchView();

  @override
  State<_AddressSearchView> createState() => _AddressSearchViewState();
}

class _AddressSearchViewState extends State<_AddressSearchView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Search Address",
          style: TextStyle(
              color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _SearchHeader(controller: _controller),
            Expanded(
              child: BlocConsumer<AddressSearchCubit, AddressSearchState>(
                listener: (context, state) {
                  if (state is PlaceDetailLoaded) {
                    log("Selected Place Detail: ${state.detail}",
                        name: "AddressSearchPage");
                    Navigator.pop<PlaceDetail>(context, state.detail);
                  } else if (state is AddressSearchError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AddressSearchLoading ||
                      state is PlaceDetailLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is AddressSearchLoaded) {
                    return _SearchResultList(suggestions: state.suggestions);
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchHeader extends StatelessWidget {
  final TextEditingController controller;

  const _SearchHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: controller,
          autofocus: true,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            hintText: "Search address",
            hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    icon: Icon(Icons.clear, color: Colors.grey[500]),
                    onPressed: () {
                      controller.clear();
                      context
                          .read<AddressSearchCubit>()
                          .onSearchQueryChanged('');
                    },
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          ),
          onChanged: (query) {
            context.read<AddressSearchCubit>().onSearchQueryChanged(query);
          },
        ),
      ),
    );
  }
}

class _SearchResultList extends StatelessWidget {
  final List<PlaceSuggestion> suggestions;

  const _SearchResultList({required this.suggestions});

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty) {
      return const Center(
        child: Text("No results found", style: TextStyle(color: Colors.grey)),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: suggestions.length,
      separatorBuilder: (ctx, i) => const Divider(height: 1, indent: 70),
      itemBuilder: (context, index) {
        final place = suggestions[index];
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.location_on, color: Const.aqua, size: 20),
          ),
          title: Text(
            place.mainText,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              place.secondaryText,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          onTap: () {
            context
                .read<AddressSearchCubit>()
                .selectPlace(place.placeId, placeName: place.mainText);
          },
        );
      },
    );
  }
}
