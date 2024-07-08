# sig_pagination

This Flutter package simplifies pagination by integrating the `signals` package and `pull_to_refresh_flutter3`. It provides a convenient `PaginationScreen` widget to handle paginated data fetching, displaying, and refreshing.

![Demo Video](assets/demo.gif "A sample video")

## Features

- Easy integration for paginated data fetching.
- Supports pull-to-refresh and infinite scrolling.
- Customizable UI components for loading, empty state, and error handling.
- Search functionality built-in.

## Getting Started

### Installation

Add `sig_pagination` to your `pubspec.yaml` file:

```yaml
dependencies:
  sig_pagination: any
```

Run `flutter pub get` to fetch the package.

## Usage

Here is a basic example of how to use the `PaginationScreen` widget:

```dart
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
```

## API

`PaginationScreen`
`PaginationScreen` is a stateful widget that handles paginated data fetching and display.

## Parameters:

- `future`: A function that returns a `Future<List<T>>` for fetching paginated data.
- `pagination`: An instance of APagination to handle pagination logic.
- `pageBuilder`: A widget builder function to build the UI with the fetched data.
- `emptyWidget`: A widget to display when there is no data.
- `errorWidget`: A widget to display when an error occurs.
- `loadingWidget`: A widget to display while loading data.
- `refreshController`: Optional RefreshController for handling refresh states.
- `searchController`: Optional TextEditingController for handling search input.
- Other optional parameters for customizing the behavior and appearance of the pagination screen.

## APagination

`APagination` is an abstract class that should be extended to implement custom pagination logic.

## Contributing

Contributions are what make the open-source community such an amazing place to learn, inspire, and create. Any contributions you make are greatly appreciated.

If you have a suggestion that would make this better, please fork the repository and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

## Fork the Project

Create your Feature Branch (git checkout -b feature/AmazingFeature)
Commit your Changes (git commit -m 'Add some AmazingFeature')
Push to the Branch (git push origin feature/AmazingFeature)
Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

- GabbyGreat
- TWITTER - [@iGabbyGreat](https://twitter.com/iGabbygreat)
- Email: [gabrieloranekwu@gmail.com](mailto:gabrieloranekwu@gmail.com)
