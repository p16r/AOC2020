//: [Previous](@previous)

import Foundation

extension String {

    static let color: Self = "color"
    static let list: Self = "list"
    static let count: Self = "count"

}

extension Substring {

    static let shinyGold: Self = "shiny gold"

}

extension NSTextCheckingResult {

    func string(withGroupName name: String, in string: String) -> Substring? {
        let nsRange = range(withName: name)
        guard let range = Range(nsRange, in: string) else { return nil }
        return string[range]
    }

}

extension NSRegularExpression {

    func matches(in string: String) -> [NSTextCheckingResult] {
        let range = NSRange(location: 0, length: string.utf16.count)
        return matches(in: string, range: range)
    }

}

let input = readFile(named: "input", withExtension: "txt")

let colorPattern = #"^(?<\#(String.color)>[a-z ]+) bags contain (?<\#(String.list)>.*)$"#
let colorRegex = try NSRegularExpression(pattern: colorPattern, options: .anchorsMatchLines)

let listPattern = #"(?<\#(String.count)>\d+) (?<\#(String.color)>[a-z ]+)(?= bag)"#
let listRegex = try NSRegularExpression(pattern: listPattern, options: .anchorsMatchLines)

let dictionary = colorRegex.matches(in: input)
    .reduce(into: [Substring: [Substring: Int]]()) { dictionary, match in
        guard
            let color = match.string(withGroupName: .color, in: input),
            let list = match.string(withGroupName: .list, in: input)
                .map(String.init)
        else { return }
        dictionary[color] = listRegex.matches(in: list)
            .reduce(into: [Substring: Int]()) { dictionary, match in
                guard
                    let color = match.string(withGroupName: .color, in: list),
                    let count = match.string(withGroupName: .count, in: list)
                        .map(String.init)
                        .flatMap(Int.init)
                else { return }
                dictionary[color] = count
            }
    }

//  MARK: - Part One

var queue: [String.SubSequence] = [.shinyGold]
var set = Set<String.SubSequence>()

while queue.isEmpty == false {
    let color = queue.removeLast()
    if set.insert(color).inserted { continue }
    let array = dictionary.reduce(into: [Substring]()) { (array, tuple) in
        if tuple.value.keys.contains(color) {
            array.append(tuple.key)
        }
    }
    queue.append(contentsOf: array)
}

set.remove(.shinyGold)
print(set.count)

//  MARK: - Part Two

func bagCount(for color: Substring) -> Int {
    dictionary[color, default: [:]].reduce(1) { (sum, tuple) in
        sum + tuple.value * bagCount(for: tuple.key)
    }
}

print(bagCount(for: .shinyGold) - 1)

//: [Next](@next)
