import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m2health/const.dart';
import 'package:m2health/features/medical_store/domain/entity/medical_store.dart';
import 'package:m2health/features/medical_store/presentation/bloc/medical_store_cubit.dart';
import 'package:m2health/features/medical_store/presentation/bloc/medical_store_state.dart';
import 'package:m2health/service_locator.dart';

class MedicalStorePage extends StatefulWidget {
  const MedicalStorePage({super.key});

  @override
  State<MedicalStorePage> createState() => _MedicalStorePageState();
}

class _MedicalStorePageState extends State<MedicalStorePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Medical Store',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Row(
              children: [
                Icon(Icons.sort),
                SizedBox(width: 5),
                Text('Sort', style: TextStyle(fontSize: 14)),
              ],
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorColor: Const.aqua,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: Const.aqua,
          ),
          tabs: const [
            Tab(text: 'Homecare Consumable'),
            Tab(text: 'Point of Care Testing'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          MedicalStoreProductTab(
              category: MedicalStoreProductCategory.consumables),
          MedicalStoreProductTab(category: MedicalStoreProductCategory.poct),
        ],
      ),
    );
  }
}

class MedicalStoreProductTab extends StatelessWidget {
  final MedicalStoreProductCategory category;

  const MedicalStoreProductTab({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MedicalStoreCubit(dio: sl()),
      child: _MedicalStoreProductList(category: category),
    );
  }
}

class _MedicalStoreProductList extends StatefulWidget {
  final MedicalStoreProductCategory category;

  const _MedicalStoreProductList({required this.category});

  @override
  State<_MedicalStoreProductList> createState() =>
      _MedicalStoreProductListState();
}

class _MedicalStoreProductListState extends State<_MedicalStoreProductList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _getProducts(isRefresh: true);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getProducts({bool isRefresh = false}) async {
    await context
        .read<MedicalStoreCubit>()
        .getProductByCategory(widget.category, isRefresh: isRefresh);
  }

  void _onScroll() {
    if (_isBottom) {
      _getProducts();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await _getProducts(isRefresh: true);
      },
      child: BlocBuilder<MedicalStoreCubit, MedicalStoreState>(
        builder: (context, state) {
          if (state.status == MedicalStoreStatus.initial ||
              (state.status == MedicalStoreStatus.loading &&
                  state.products.isEmpty)) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == MedicalStoreStatus.failure &&
              state.products.isEmpty) {
            return Center(child: Text(state.errorMessage));
          }

          if (state.products.isEmpty) {
            return const Center(child: Text('No products available'));
          }

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(10),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return ProductCard(product: state.products[index]);
                    },
                    childCount: state.products.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 200,
                  ),
                ),
              ),
              if (!state.hasReachedMax)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 64)),
            ],
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final MedicalStoreProduct product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(
                height: 120,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: product.isLocalImage
                      ? Image.asset(
                          product.imageUrl,
                          fit: BoxFit.cover,
                        )
                      : Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[200],
                            child: const Center(
                                child: Icon(Icons.broken_image, size: 50)),
                          ),
                        ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: const Icon(
                    Icons.favorite_border,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    // Handle favorite action
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (product.price != null)
                  Text(
                    '\$${product.price}',
                    style: const TextStyle(fontSize: 12),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
