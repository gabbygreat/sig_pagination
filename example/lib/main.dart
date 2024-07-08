import 'package:example/model/model.dart';
import 'package:example/request/network.dart';
import 'package:example/widget/empty.dart';
import 'package:example/widget/error.dart';
import 'package:flutter/material.dart';
import 'package:sig_pagination/sig_pagination.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Pagination pagination = Pagination();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: false,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('EXAMPLE')),
        body: PaginationScreen(
          pagination: pagination,
          future: () => PlaneRequest.instance.fetchPlanes(
            pagination: pagination,
          ),
          emptyWidget: const EmptyScreen(),
          loadingWidget: const CircularProgressIndicator(),
          errorWidget: (error, trace, signal) {
            return ErrorScreen(
              error: error,
              signal: signal,
              trace: trace,
            );
          },
          pageBuilder: (data) {
            return ListView.separated(
              padding: const EdgeInsets.only(top: 20),
              separatorBuilder: (context, index) => const Divider(),
              itemCount: data.length,
              itemBuilder: (context, index) {
                var item = data[index];
                return ListTile(
                  title: Text(item.name),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
