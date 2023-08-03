import 'package:demo/continuous_list/continuous_list_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContinuousList extends StatefulWidget {
  ContinuousList({Key? key}) : super(key: key);

  final ScrollController scrollControllers = ScrollController();

  @override
  State<ContinuousList> createState() => _ContinuousListState();
}

class _ContinuousListState extends State<ContinuousList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Continuous List'),
        actions: [
          TextButton(
            onPressed: () => context.read<ContinuousListProvider>().loadMore(),
            child: Text(
              '+${context.read<ContinuousListProvider>().loadMoreMax}',
              style: const TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.read<ContinuousListProvider>().addNew(),
        child: Icon(Icons.add),
      ),
      body: Selector<ContinuousListProvider, List>(
        selector: (context, continuousListProvider) => continuousListProvider.dataList,
        builder: (context, selectedList, child) {
          return AnimatedList(
            padding: const EdgeInsets.all(16.0),
            physics: const AlwaysScrollableScrollPhysics(),
            key: context.read<ContinuousListProvider>().listKey,
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
                return Selector<ContinuousListProvider, bool>(
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
                              onPressed: () => context.read<ContinuousListProvider>().loadMore(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return SizeTransition(
                sizeFactor: animation,
                child: ListTile(
                  title: Text(
                    selectedList[index],
                    style: TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                  onTap: () {},
                ),
              );
            },
          );
        },
      ),
    );
  }
}
