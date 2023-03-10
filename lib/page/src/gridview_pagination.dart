
import 'package:flutter/material.dart';

typedef OnNextPage = Future<bool> Function(int nextPage);

class GridViewPagination extends StatefulWidget {
  final int itemCount;
  final double childAspectRatio;
  final OnNextPage onNextPage;
  final Widget Function(BuildContext context, int) itemBuilder;
  final Widget Function(BuildContext context)? progressBuilder;

  const GridViewPagination({super.key,
    required this.itemCount,
    required this.childAspectRatio,
    required this.itemBuilder,
     required this.onNextPage,
     this.progressBuilder,
  });

  @override
  GridViewPaginationState createState() => GridViewPaginationState();
}

class GridViewPaginationState extends State<GridViewPagination> {
  int currentPage = 1;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification sn) {
        if (!isLoading && sn is ScrollUpdateNotification && sn.metrics.pixels == sn.metrics.maxScrollExtent) {
          setState(() {
            isLoading = true;
          });
          widget.onNextPage.call(currentPage++).then((bool isLoaded) {
            setState(() {
              isLoading = false;
            });
          });
        }
        return true;
      },
      child: CustomScrollView(
        slivers: <Widget>[
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 1,
              mainAxisSpacing: 1,
              crossAxisCount: 2,
              childAspectRatio: widget.childAspectRatio,
            ),
            delegate: SliverChildBuilderDelegate(
              widget.itemBuilder,
              childCount: widget.itemCount,
              addAutomaticKeepAlives: true,
              addRepaintBoundaries: true,
              addSemanticIndexes: true,
            ),
          ),
          if (isLoading)
            SliverToBoxAdapter(
              child: widget.progressBuilder?.call(context),
            ),
        ],
      ),
    );
  }

  Widget defaultLoading() {
    return Container(
      padding: const EdgeInsets.all(15),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(),
    );
  }
}