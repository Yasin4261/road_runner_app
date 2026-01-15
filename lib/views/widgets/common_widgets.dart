import 'package:flutter/material.dart';
import 'package:road_runner_app/viewmodels/base_viewmodel.dart';

/// Loading widget based on view state
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

/// Error widget with retry button
class ErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state widget
class EmptyWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyWidget({
    super.key,
    this.message = 'No data available',
    this.icon = Icons.inbox,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey,
                ),
          ),
        ],
      ),
    );
  }
}

/// State aware builder widget
class StateAwareBuilder<T extends BaseViewModel> extends StatelessWidget {
  final T viewModel;
  final Widget Function(BuildContext context, T viewModel) onSuccess;
  final Widget Function(BuildContext context, T viewModel)? onLoading;
  final Widget Function(BuildContext context, T viewModel, String error)? onError;
  final Widget Function(BuildContext context, T viewModel)? onIdle;

  const StateAwareBuilder({
    super.key,
    required this.viewModel,
    required this.onSuccess,
    this.onLoading,
    this.onError,
    this.onIdle,
  });

  @override
  Widget build(BuildContext context) {
    switch (viewModel.state) {
      case ViewState.loading:
        return onLoading?.call(context, viewModel) ?? const LoadingWidget();
      case ViewState.error:
        return onError?.call(context, viewModel, viewModel.errorMessage) ??
            ErrorWidget(message: viewModel.errorMessage);
      case ViewState.success:
        return onSuccess(context, viewModel);
      case ViewState.idle:
        return onIdle?.call(context, viewModel) ?? onSuccess(context, viewModel);
    }
  }
}
