//: [Previous](@previous)

import Foundation

let input = readFile(named: "input", withExtension: "txt")

let groups = input.components(separatedBy: "\n\n")

//  MARK: - Part One

let sum = groups
    .map { $0.replacingOccurrences(of: "\n", with: "") }
    .map(Set.init)
    .map(\.count)
    .reduce(0, +)
print(sum)

//  MARK: - Part Two

let correctedSum = groups
    .map { group in
        group
            .split(separator: "\n")
            .map(Set.init)
            .reduce(Set("abcdefghijklmnopqrstuvwxyz")) { $0.intersection($1) }
            .count
    }
    .reduce(0, +)
print(correctedSum)

//: [Next](@next)
