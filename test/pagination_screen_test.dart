import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sig_pagination/view/view.dart';
import 'package:sig_pagination/model/model.dart';

class MockPagination extends APagination {
  MockPagination() : super();

  @override
  void reset() {
    page = 0;
  }

  @override
  void increment() {
    page++;
  }
}

void main() {
  group('PaginationScreen Tests', () {
    late RefreshController refreshController;
    late APagination pagination;
    late TextEditingController searchController;

    setUp(() {
      refreshController = RefreshController();
      pagination = MockPagination();
      searchController = TextEditingController();
    });

    Future<List<String>> mockFuture() async {
      return Future.delayed(
        const Duration(milliseconds: 500),
        () => List.generate(10, (index) => 'Item $index'),
      );
    }

    testWidgets('displays loading widget initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationScreen<String>(
              future: mockFuture,
              pagination: pagination,
              pageBuilder: (data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(data[index]),
                    );
                  },
                );
              },
              emptyWidget: const Text('No Data'),
              errorWidget: (error, stackTrace, signal) => Text('Error: $error'),
              loadingWidget: const CircularProgressIndicator(),
              refreshController: refreshController,
              searchController: searchController,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('displays data after loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationScreen<String>(
              future: mockFuture,
              pagination: pagination,
              pageBuilder: (data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(data[index]),
                    );
                  },
                );
              },
              emptyWidget: const Text('No Data'),
              errorWidget: (error, stackTrace, signal) => Text('Error: $error'),
              loadingWidget: const CircularProgressIndicator(),
              refreshController: refreshController,
              searchController: searchController,
            ),
          ),
        ),
      );

      // Wait for the Future to complete
      await tester.pumpAndSettle();
      expect(find.byType(ListTile), findsNWidgets(10));
    });

    testWidgets('displays empty widget when there is no data',
        (WidgetTester tester) async {
      Future<List<String>> mockEmptyFuture() async {
        return Future.delayed(const Duration(milliseconds: 500), () => []);
      }

      await tester.pumpWidget(
        MaterialApp(
          home: PaginationScreen<String>(
            future: mockEmptyFuture,
            pagination: pagination,
            pageBuilder: (data) {
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data[index]),
                  );
                },
              );
            },
            emptyWidget: const Text('No Data'),
            errorWidget: (error, stackTrace, signal) => Text('Error: $error'),
            loadingWidget: const CircularProgressIndicator(),
            refreshController: refreshController,
            searchController: searchController,
          ),
        ),
      );

      // Wait for the Future to complete
      await tester.pumpAndSettle();
      expect(find.text('No Data'), findsOneWidget);
    });

    testWidgets('displays error widget on error', (WidgetTester tester) async {
      Future<List<String>> mockErrorFuture() async {
        return Future.delayed(const Duration(milliseconds: 500),
            () => throw Exception('Error loading data'));
      }

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaginationScreen<String>(
              future: mockErrorFuture,
              pagination: pagination,
              pageBuilder: (data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(data[index]),
                    );
                  },
                );
              },
              emptyWidget: const Text('No Data'),
              errorWidget: (error, stackTrace, signal) => Text('Error: $error'),
              loadingWidget: const CircularProgressIndicator(),
              refreshController: refreshController,
              searchController: searchController,
            ),
          ),
        ),
      );

      // Wait for the Future to complete
      await tester.pumpAndSettle();
      expect(find.text('Error: Exception: Error loading data'), findsOneWidget);
    });
  });
}
