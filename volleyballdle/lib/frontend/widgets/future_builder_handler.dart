import 'package:flutter/material.dart';

class FutureBuilderHandler<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(T data) onData;
  final String loadingMessage;
  final String Function(Object? error)? onError;

  const FutureBuilderHandler({
    required this.future,
    required this.onData,
    this.loadingMessage = 'Loading...',
    this.onError,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          String errorMessage = onError?.call(snapshot.error) ?? 'Error: ${snapshot.error}';
          return Center(child: Text(errorMessage));
        } else if (snapshot.hasData) {
          return onData(snapshot.data as T);
        } else {
          return Center(child: Text('No data available.'));
        }
      },
    );
  }
}
