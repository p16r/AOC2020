//: [Previous](@previous)

import Foundation

let input = readFile(named: "input", withExtension: "txt")

let rows = input.split(separator: "\n")

//  MARK: - Part One

let seatIDs = rows
    .map { row in
        row
            .reversed()
            .enumerated()
            .reduce(0) { (sum, tuple) in
                sum + ((tuple.element == "B" || tuple.element == "R") ? pow(2, tuple.offset) : 0)
            }
    }
    .sorted()

guard let maxID = seatIDs.last else {
    fatalError("Fetching last element of an empty array.")
}

print(maxID)

//  MARK: - Part Two

extension Array {

    subscript(after index: Index) -> Element {
        self[self.index(after: index)]
    }

}

let index = seatIDs
    .indices
    .dropLast()
    .first { index in
        seatIDs[after: index] == seatIDs[index] + 2
    }

guard let index = index else {
    fatalError("No matching index found.")
}

print(seatIDs[index] + 1)

//: [Next](@next)
