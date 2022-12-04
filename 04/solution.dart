import 'dart:io';
import 'dart:core';

typedef Range = Iterable<int>;
typedef RangePair = Iterable<Range>;

Future<void> main() async {
  var input = parseInput(await File("04/data").readAsLines());

  print("First: ${reduceRanges(input, isWithin)}");
  print("Second: ${reduceRanges(input, isPartiallyWithin)}");
}

bool isWithin(Range a, Range b) {
  return a.first >= b.first && a.last <= b.last ||
      b.first >= a.first && b.last <= a.last;
}

bool isPartiallyWithin(Range a, Range b) {
  return (a.first <= b.last) && (a.last >= b.first);
}

int reduceRanges(Iterable<RangePair> ranges, bool fn(Range a, Range b)) {
  return ranges.map((e) => fn(e.first, e.last) ? 1 : 0).reduce((a, b) => a + b);
}

Iterable<RangePair> parseInput(List<String> input) {
  return input.map(
      (e) => e.split(",").map((e) => e.split("-").map((e) => int.parse(e))));
}
