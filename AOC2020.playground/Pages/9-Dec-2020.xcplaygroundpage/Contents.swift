//: [Previous](@previous)

import Foundation

let input = readFile(named: "input", withExtension: "txt")
let preambleCount = 25

let numbers = input
    .split(separator: "\n")
    .compactMap { Int($0) }

//  MARK: - Part One

let index = numbers
    .indices
    .dropFirst(preambleCount)
    .first { index in
        let number = numbers[index]
        let prior = numbers
            .prefix(upTo: index)
            .suffix(preambleCount)
        let containsSum = prior
            .indices
            .contains { i in
                prior
                    .suffix(from: prior.index(after: i))
                    .indices
                    .contains { j in
                        prior[i] + prior[j] == number
                    }
            }
        return containsSum == false
    }

guard let number = index.map({ numbers[$0] }) else {
    preconditionFailure("All numbers valid.")
}

print(number)

//  MARK: - Part Two

let subset: [Int] = { numbers in
    var start = numbers.startIndex
    var end = numbers.startIndex
    var sum = numbers[start...end].reduce(0, +)

    while end < numbers.endIndex {
        if sum == number {
            return numbers[start...end].sorted()
        } else if sum < number {
            end = numbers.index(after: end)
            sum += numbers[end]
        } else if sum > number {
            sum -= numbers[start]
            start = numbers.index(after: start)
        }
    }
    preconditionFailure("No contiguous slice found.")
} (numbers)

guard let min = subset.first, let max = subset.last else {
    preconditionFailure("No min or max found.")
}
print(min + max)

//: [Next](@next)
