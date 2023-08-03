import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'continuous_list_reversed_provider.dart';

class ContinuousListReversed extends StatefulWidget {
  ContinuousListReversed({Key? key}) : super(key: key);

  final ScrollController scrollControllers = ScrollController();

  @override
  State<ContinuousListReversed> createState() => _ContinuousListReversedState();
}

class _ContinuousListReversedState extends State<ContinuousListReversed> {
  @override
  void initState() {
    widget.scrollControllers.addListener(
      () {
        if (widget.scrollControllers.offset >= widget.scrollControllers.position.maxScrollExtent) {
          context.read<ContinuousListReversedProvider>().loadMore();
        }
      },
    );
    context.read<ContinuousListReversedProvider>().clean();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Continuous List Reversed'),
        actions: [
          TextButton(
            onPressed: () => context.read<ContinuousListReversedProvider>().loadMore(),
            child: Text(
              "+${context.read<ContinuousListReversedProvider>().loadMoreMax}",
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: Selector<ContinuousListReversedProvider, List>(
        selector: (context, continuousListReversedProvider) => continuousListReversedProvider.dataList,
        builder: (context, selectedList, child) {
          return AnimatedList(
            reverse: true,
            padding: const EdgeInsets.all(16.0),
            physics: const AlwaysScrollableScrollPhysics(),
            key: context.read<ContinuousListReversedProvider>().listKey,
            controller: widget.scrollControllers,
            initialItemCount: selectedList.length + 1,
            itemBuilder: (context, index, animation) {
              if (selectedList.length == index && selectedList.isEmpty) {
                return FadeTransition(
                  opacity: animation,
                  child: const AspectRatio(
                    aspectRatio: 1,
                    child: Center(
                      child: Text('Empty'),
                    ),
                  ),
                );
              }
              if (selectedList.length == index) {
                return Selector<ContinuousListReversedProvider, bool>(
                  selector: (context, orderProvider) {
                    return orderProvider.isLoading;
                  },
                  builder: (context, isLoading, child) {
                    if (isLoading) {
                      return FadeTransition(
                        opacity: animation,
                        child: const SizedBox(),
                      );
                    }
                    return FadeTransition(
                      opacity: animation,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0, bottom: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.cloud_download),
                              label: const Text("Load More"),
                              onPressed: () => context.read<ContinuousListReversedProvider>().loadMore(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              if (selectedList.length - 1 == index) {
                return SizeTransition(
                  sizeFactor: animation,
                  child: const Center(
                    child: Icon(
                      Icons.refresh,
                      color: Colors.blue,
                    ),
                  ),
                );
              }
              return SizeTransition(
                sizeFactor: animation,
                child: ListTile(
                  title: Text(
                    selectedList[index],
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                  onTap: () {},
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: IntrinsicHeight(
          child: SizedBox(
            height: 96,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Nothing',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: InkWell(
                      onTap: () => context.read<ContinuousListReversedProvider>().addNew(),
                      child: const CircleAvatar(
                        child: Icon(Icons.send),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
