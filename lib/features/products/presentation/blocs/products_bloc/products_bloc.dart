// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:teslo_shop/features/products/domain/domain.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository productsRepository;
  ProductsBloc({required this.productsRepository})
      : super(const ProductsState()) {
    on<SetLoadingEvent>(_loadingEventHandler);
    on<SetProductEvent>(_productEventHandler);
    loadNextPage();
  }

  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;
    add(SetLoadingEvent(isLoading: true));
    final products = await productsRepository.getProductsByPage(
        limit: state.limit, offset: state.offset);
    if (products.isEmpty) {
      add(SetLoadingEvent(isLoading: false, isLastPage: true));
      return;
    }
    add(SetProductEvent(products: products));
  }

  _loadingEventHandler(SetLoadingEvent event, Emitter<ProductsState> emit) {
    emit(state.copyWith(
        isLoading: event.isLoading, isLastPage: event.isLastPage ?? false));
  }

  _productEventHandler(SetProductEvent event, Emitter<ProductsState> emit) {
    emit(state.copyWith(
        isLastPage: false,
        isLoading: false,
        offset: state.offset + 10,
        products: [...state.products, ...event.products]));
  }
}
