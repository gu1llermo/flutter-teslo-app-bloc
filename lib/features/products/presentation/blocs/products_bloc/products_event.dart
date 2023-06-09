// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'products_bloc.dart';

abstract class ProductsEvent {
  const ProductsEvent();
}

class SetLoadingEvent extends ProductsEvent {
  final bool isLoading;
  final bool? isLastPage;
  SetLoadingEvent({
    required this.isLoading,
    this.isLastPage,
  });
}

class SetProductEvent extends ProductsEvent {
  List<Product> products;
  SetProductEvent({
    required this.products,
  });
}
