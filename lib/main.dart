import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/config/router/app_router.dart';
import 'package:teslo_shop/features/auth/infraestructure/infraestructure.dart';
import 'package:teslo_shop/features/auth/presentation/blocs/blocs.dart';
import 'package:teslo_shop/features/shared/infraestructure/services/key_value_storage_service_impl.dart';

import 'config/router/app_router_notifier.dart';

void main() async {
  await Environment.initEnvironment();
  runApp(const BlocWidget(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = context.watch<AppRouterCubit>().state;
    return MaterialApp.router(
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class BlocWidget extends StatelessWidget {
  final Widget child;
  const BlocWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
        lazy: false,
        create: (context) => AuthBloc(
            authRepository: AuthRepositoryImpl(),
            keyValueStorageService: KeyValueStorageServiceImpl()),
      ),
      BlocProvider(
          create: (context) =>
              AppRouterCubit(GoRouterNotifier(context.read<AuthBloc>())))
    ], child: child);
  }
}
