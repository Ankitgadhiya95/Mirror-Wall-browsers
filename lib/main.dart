import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mirrorwall/mirrorwallprovider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MirrorWallProvider())
      ],
      child: Consumer<MirrorWallProvider>(builder: (context, provider, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MyHomePage(title: 'My Browser'),
        );
      }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum Status { Google, Yahoo, Bing, DuckGo }

class _MyHomePageState extends State<MyHomePage> {
  final scaffoldkey = GlobalKey<ScaffoldState>();
  late PersistentBottomSheetController controller;

  @override
  void initState() {
    final provider = Provider.of<MirrorWallProvider>(context, listen: false);
    // TODO: implement initState
    provider.pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(color: Colors.red),
      onRefresh: () {
        provider.webViewController!.reload();
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MirrorWallProvider>(context, listen: true);
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton(
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      onTap: () async {
                        controller = await scaffoldkey.currentState!
                            .showBottomSheet((context) {
                          return SizedBox(
                            height: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  height: 80,
                                  width: double.infinity,
                                  color: Color(0XFFF8F1F9),
                                  child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          Navigator.of(context).pop();
                                        });
                                      },
                                      child: const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.close,
                                            color: Color(0XFF6955AA),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "DISMISS",
                                            style: TextStyle(
                                                color: Color(0XFF6955AA)),
                                          )
                                        ],
                                      )),
                                ),
                                Container(
                                  height: 200,
                                  child: provider.bookmark.length == 0
                                      ? Text("NO Bookmark")
                                      : ListView.builder(
                                          itemCount: provider.bookmark.length,
                                          prototypeItem: ListTile(
                                            title:
                                                Text(provider.bookmark.first),
                                          ),
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              onTap: () {
                                                var url = WebUri(
                                                    provider.bookmark[index]);
                                                print(url);
                                                if (url.scheme.isEmpty) {
                                                  if (provider.fruit ==
                                                      Status.Google) {
                                                    url = WebUri(
                                                        "https://www.google.com/search?q=" +
                                                            provider.bookmark[
                                                                index]);
                                                  } else if (provider.fruit ==
                                                      Status.Yahoo) {
                                                    url = WebUri(
                                                        "https://in.search.yahoo.com/search?q=" +
                                                            provider.bookmark[
                                                                index]);
                                                  } else if (provider.fruit ==
                                                      Status.Bing) {
                                                    url = WebUri(
                                                        "https://www.bing.com/search?q=" +
                                                            provider.bookmark[
                                                                index]);
                                                  } else {
                                                    url = WebUri(
                                                        "https://duckduckgo.com/search?q=" +
                                                            provider.bookmark[
                                                                index]);
                                                  }
                                                }
                                                provider.webViewController
                                                    ?.loadUrl(
                                                        urlRequest: URLRequest(
                                                            url: url));
                                              },
                                              title: Text(
                                                  provider.bookmark[index]),
                                              trailing: InkWell(
                                                  onTap: () {
                                                    controller.setState!(() {
                                                      provider.bookmark.remove(
                                                          provider
                                                              .bookmark[index]);
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.close,
                                                  )),
                                            );
                                          },
                                        ),
                                )
                              ],
                            ),
                          );
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [Icon(Icons.bookmark), Text("All Bookmark")],
                      ),
                    ),
                    PopupMenuItem(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Search Engine"),
                              actions: [
                                Column(
                                  children: [
                                    RadioListTile<Status>(
                                      contentPadding: EdgeInsets.zero,
                                      title: const Text('Google'),
                                      value: Status.Google,
                                      groupValue: provider.fruit,
                                      onChanged: (Status? value) {
                                        setState(() {
                                          provider.fruit = value;
                                          print(provider.fruit);
                                          Navigator.of(context).pop();
                                          provider.webViewController?.loadUrl(
                                              urlRequest: URLRequest(
                                                  url: WebUri(
                                                      "https://www.google.com/search?q=" +
                                                          provider
                                                              .search.text)));
                                        });
                                      },
                                    ),
                                    RadioListTile<Status>(
                                      contentPadding: EdgeInsets.zero,
                                      title: const Text('Yahoo'),
                                      value: Status.Yahoo,
                                      groupValue: provider.fruit,
                                      onChanged: (Status? value) {
                                        setState(() {
                                          provider.fruit = value;
                                          print(provider.fruit);
                                          Navigator.of(context).pop();
                                          provider.webViewController?.loadUrl(
                                              urlRequest: URLRequest(
                                                  url: WebUri(
                                                      "https://in.search.yahoo.com/search?q=" +
                                                          provider
                                                              .search.text)));
                                        });
                                      },
                                    ),
                                    RadioListTile<Status>(
                                      contentPadding: EdgeInsets.zero,
                                      title: const Text('Bing'),
                                      value: Status.Bing,
                                      groupValue: provider.fruit,
                                      onChanged: (Status? value) {
                                        setState(() {
                                          provider.fruit = value;
                                          print(provider.fruit);
                                          Navigator.of(context).pop();
                                          provider.webViewController?.loadUrl(
                                              urlRequest: URLRequest(
                                                  url: WebUri(
                                                      "https://www.bing.com/search?q=" +
                                                          provider
                                                              .search.text)));
                                        });
                                      },
                                    ),
                                    RadioListTile<Status>(
                                      contentPadding: EdgeInsets.zero,
                                      title: const Text('Duck Duck Go'),
                                      value: Status.DuckGo,
                                      groupValue: provider.fruit,
                                      onChanged: (Status? value) {
                                        setState(() {
                                          provider.fruit = value;
                                          print(provider.fruit);
                                          Navigator.of(context).pop();
                                          provider.webViewController?.loadUrl(
                                              urlRequest: URLRequest(
                                                  url: WebUri(
                                                      "https://duckduckgo.com/search?q=" +
                                                          provider
                                                              .search.text)));
                                        });
                                      },
                                    ),
                                  ],
                                )
                              ],
                            );
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.screen_search_desktop_outlined),
                          Text("Search Engine")
                        ],
                      ),
                    )
                  ])
        ],
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: InAppWebView(
                /*onLoadStop: (controller, url) {
                pullToRefreshController!.endRefreshing();
              },*/
                onProgressChanged: (controller, progress) {
                  provider.pullToRefreshController!.endRefreshing();
                },
                pullToRefreshController: provider.pullToRefreshController,
                onWebViewCreated: (controller) {
                  provider.webViewController = controller;
                  if (provider.fruit == Status.Google) {
                    provider.webViewController!.loadUrl(
                        urlRequest:
                            URLRequest(url: WebUri("https://www.google.com/")));
                  } else if (provider.fruit == Status.Yahoo) {
                    provider.webViewController!.loadUrl(
                        urlRequest: URLRequest(
                            url: WebUri("https://in.search.yahoo.com/")));
                  } else if (provider.fruit == Status.Bing) {
                    provider.webViewController!.loadUrl(
                        urlRequest:
                            URLRequest(url: WebUri("https://www.bing.com/")));
                  } else {
                    provider.webViewController!.loadUrl(
                        urlRequest:
                            URLRequest(url: WebUri("https://duckduckgo.com/")));
                  }
                },
              ),
            ),
            TextField(
              decoration: InputDecoration(
                suffixIcon: Icon(Icons.search),
                hintText: "Search or type web address",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                var url = WebUri(value);
                print(url);
                if (url.scheme.isEmpty) {
                  if (provider.fruit == Status.Google) {
                    url = WebUri("https://www.google.com/search?q=" + value);
                  } else if (provider.fruit == Status.Yahoo) {
                    url =
                        WebUri("https://in.search.yahoo.com/search?q=" + value);
                  } else if (provider.fruit == Status.Bing) {
                    url = WebUri("https://www.bing.com/search?q=" + value);
                  } else {
                    url = WebUri("https://duckduckgo.com/search?q=" + value);
                  }
                }
                provider.webViewController
                    ?.loadUrl(urlRequest: URLRequest(url: url));
              },
              controller: provider.search,
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      var url;

                      if (provider.fruit == Status.Google) {
                        url = WebUri("https://www.google.com/");
                      } else if (provider.fruit == Status.Yahoo) {
                        url = WebUri("https://in.search.yahoo.com/");
                      } else if (provider.fruit == Status.Bing) {
                        url = WebUri("https://www.bing.com/");
                      } else {
                        url = WebUri("https://duckduckgo.com/");
                      }

                      provider.webViewController
                          ?.loadUrl(urlRequest: URLRequest(url: url));
                    },
                    icon: Icon(Icons.home)),
                IconButton(
                    onPressed: () {
                      provider.bookmark.add(provider.search.text);
                    },
                    icon: Icon(Icons.save_as)),
                IconButton(
                    onPressed: () {
                      provider.webViewController!.goBack();
                    },
                    icon: Icon(Icons.arrow_back_ios)),
                IconButton(
                    onPressed: () {
                      provider.webViewController!.reload();
                    },
                    icon: Icon(Icons.refresh)),
                IconButton(
                    onPressed: () {
                      provider.webViewController!.goForward();
                    },
                    icon: Icon(Icons.arrow_forward_ios)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
