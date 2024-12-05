import gleam/dict
import gleam/int
import gleam/io
import gleam/list
import gleam/set
import gleam/string

import shared

pub fn main() {
  let #(ordering, updates) =
    shared.read_input([])
    |> parse_input(dict.new(), [], False)
  io.println("Part 1: " <> int.to_string(part_1(ordering, updates)))
  io.println("Part 2: " <> int.to_string(part_2(ordering, updates)))
}

fn parse_input(
  lines: List(String),
  ordering: dict.Dict(Int, set.Set(Int)),
  updates: List(List(Int)),
  flip: Bool,
) -> #(dict.Dict(Int, set.Set(Int)), List(List(Int))) {
  case lines {
    ["", ..tail] -> parse_input(tail, ordering, updates, True)
    [head, ..tail] -> {
      case flip {
        True ->
          [
            string.split(head, ",")
              |> list.map(fn(u) {
                case int.parse(u) {
                  Ok(u) -> u
                  _ -> -1
                }
              }),
            ..updates
          ]
          |> parse_input(tail, ordering, _, flip)
        False -> {
          string.split(head, "|")
          |> list.map(int.parse)
          |> fn(uv) {
            case uv {
              [Ok(u), Ok(v)] -> {
                case dict.get(ordering, u) {
                  Ok(neigh) -> {
                    dict.insert(ordering, u, set.insert(neigh, v))
                    |> parse_input(tail, _, updates, flip)
                  }
                  Error(_) -> {
                    dict.insert(ordering, u, set.from_list([v]))
                    |> parse_input(tail, _, updates, flip)
                  }
                }
              }
              _ -> parse_input(tail, ordering, updates, flip)
            }
          }
        }
      }
    }
    [] -> #(ordering, updates)
  }
}

fn part_1(
  ordering: dict.Dict(Int, set.Set(Int)),
  updates: List(List(Int)),
) -> Int {
  list.fold(updates, 0, fn(acc, update) {
    case is_ordered(ordering, update) {
      True -> acc + get_middle(update)
      False -> acc
    }
  })
}

fn is_ordered(ordering: dict.Dict(Int, set.Set(Int)), update: List(Int)) -> Bool {
  list.window_by_2(update)
  |> list.all(fn(uv) {
    let #(u, v) = uv
    case dict.get(ordering, u) {
      Ok(neigh) -> set.contains(neigh, v)
      Error(_) -> False
    }
  })
}

fn get_middle(update: List(Int)) -> Int {
  case list.drop(update, list.length(update) / 2) {
    [m, ..] -> m
    [] -> -1
  }
}

fn part_2(
  ordering: dict.Dict(Int, set.Set(Int)),
  updates: List(List(Int)),
) -> Int {
  list.fold(updates, [], fn(acc, update) {
    case is_ordered(ordering, update) {
      False -> [reorder(update, [], ordering), ..acc]
      True -> acc
    }
  })
  |> list.fold(0, fn(acc, update) { acc + get_middle(update) })
}

fn reorder(
  update: List(Int),
  newpdate: List(Int),
  ordering: dict.Dict(Int, set.Set(Int)),
) -> List(Int) {
  case update {
    [u, v, ..update] -> {
      case dict.get(ordering, u) {
        Ok(neigh) -> {
          case set.contains(neigh, v) {
            True -> reorder([v, ..update], list.append(newpdate, [u]), ordering)
            False ->
              reorder(list.flatten([newpdate, [v, u], update]), [], ordering)
          }
        }
        Error(_) ->
          reorder(list.flatten([newpdate, [v, u], update]), [], ordering)
      }
    }
    [u, ..update] -> reorder(update, list.append(newpdate, [u]), ordering)
    [] -> newpdate
  }
}
