enum SlideDirection {
  leftToRight,
  rightToLeft,
  none,
}

enum TransitionGoal {
  open,
  close,
}

enum UpdateType {
  dragging,
  doneDragging,
  animating,
  doneAnimating,
}

enum ReadType { cover, smooth }

class SlideUpdate {
  final UpdateType updateType;
  final SlideDirection direction;
  final double slidePercent;

  SlideUpdate(
    this.updateType,
    this.direction,
    this.slidePercent,
  );
}

class Section {
  int id;
  int novelId;
  String title;
  String content;
  int price;
  int index;
  int nextArticleId;
  int preArticleId;

  List<Map<String, int>> pageOffsets;

  Section.fromJson(Map data) {
    id = data['id'];
    novelId = data['novel_id'];
    title = data['title'];
    content = data['content'];
    content = '　　' + content;
    content = content.replaceAll('\n', '\n　　');
    price = data['welth'];
    index = data['index'];
    nextArticleId = data['next_id'];
    preArticleId = data['prev_id'];
  }

  String stringAtPageIndex(int index) {
    var offset = pageOffsets[index];
    var str = this.content.substring(offset['start'], offset['end']);
    return str;
  }

  int get pageCount {
    return pageOffsets.length;
  }
}
