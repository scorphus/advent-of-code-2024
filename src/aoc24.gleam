import gleam/erlang
import gleam/int
import gleam/io
import gleam/list
import gleam/string

pub fn main() {
  let lines = read_input([])
  let reports = extract_reports(lines)
  io.println("Part 1: " <> int.to_string(part_1(reports)))
  io.println("Part 2: " <> int.to_string(part_2(reports)))
}

fn read_input(lines: List(String)) -> List(String) {
  let line = erlang.get_line("")
  case line {
    Ok(line) -> {
      let line = string.trim(line)
      [line, ..lines]
      |> read_input()
    }
    Error(_) -> lines
  }
}

fn extract_reports(lines: List(String)) -> List(List(Int)) {
  case lines {
    [head, ..tail] -> {
      let head =
        head
        |> string.split(" ")
        |> list.map(parse_int)
      [head, ..extract_reports(tail)]
    }
    [] -> []
  }
}

fn parse_int(s: String) -> Int {
  case int.parse(s) {
    Ok(i) -> i
    Error(_) -> -1
  }
}

fn part_1(reports: List(List(Int))) -> Int {
  get_diffs_list(reports)
  |> list.fold(0, fn(acc, diffs) {
    acc
    + case diffs_are_safe(diffs) {
      True -> 1
      False -> 0
    }
  })
}

fn get_diffs_list(reports: List(List(Int))) -> List(List(Int)) {
  list.fold(reports, [], fn(acc, report) { [get_diffs(report), ..acc] })
}

fn get_diffs(report: List(Int)) -> List(Int) {
  list.drop(report, 1)
  |> list.zip(report)
  |> list.map(fn(x) { x.0 - x.1 })
}

fn diffs_are_safe(diffs: List(Int)) -> Bool {
  list.all(diffs, fn(x) { x >= 1 && x <= 3 })
  || list.all(diffs, fn(x) { x >= -3 && x <= -1 })
}

fn part_2(reports: List(List(Int))) -> Int {
  list.fold(reports, 0, fn(acc, report) {
    let diffs = get_diffs(report)
    case diffs_are_safe(diffs) {
      True -> acc + 1
      False -> acc + iter_for_safeness(report, [])
    }
  })
}

fn iter_for_safeness(report: List(Int), head_report: List(Int)) -> Int {
  case report {
    [head, ..tail] -> {
      let diffs =
        list.flatten([head_report, tail])
        |> get_diffs()
      case diffs_are_safe(diffs) {
        True -> 1
        False -> iter_for_safeness(tail, list.flatten([head_report, [head]]))
      }
    }
    [] -> 0
  }
}
