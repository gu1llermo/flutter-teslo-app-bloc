import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/presentation/blocs/blocs.dart';
import 'package:teslo_shop/features/products/infraestructure/infraestructure.dart';
import 'package:teslo_shop/features/products/infraestructure/repositories/products_repository_impl.dart';
import 'package:teslo_shop/features/products/presentation/blocs/products_bloc/products_bloc.dart';
import 'package:teslo_shop/features/products/presentation/widgets/product_card.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accessToken = context.watch<AuthBloc>().state.user?.token ?? '';
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: BlocProvider(
        create: (_) => ProductsBloc(
            productsRepository: ProductsRepositoryImpl(
                ProductsDatasourceImpl(accessToken: accessToken))),
        child: const _ProductsView(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text('Nuevo producto'),
        icon: const Icon(Icons.add),
        onPressed: () {},
      ),
    );
  }
}

class _ProductsView extends StatefulWidget {
  const _ProductsView();

  @override
  State<_ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<_ProductsView> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels + 400 >=
          scrollController.position.maxScrollExtent) {
        context.read<ProductsBloc>().loadNextPage();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productState = context.watch<ProductsBloc>().state;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: MasonryGridView.count(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        mainAxisSpacing: 20,
        crossAxisCount: 2,
        crossAxisSpacing: 30,
        itemCount: productState.products.length,
        itemBuilder: (context, index) {
          final product = productState.products[index];
          return GestureDetector(
            onTap: () => context.push('/product/${product.id}'),
            child: ProductCard(product: product),
          );
        },
      ),
    );
  }
}
