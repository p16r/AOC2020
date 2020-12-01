//: [Previous](@previous)

import Foundation

let input = readFile(named: "input", withExtension: "txt")

//  MARK: - Part One

let numbers = input
    .split(separator: "\n")
    .compactMap { Int($0) }

func twoSum(in array: [Int], to sum: Int) -> (Int, Int)? {
    let array = array.sorted()
    var i = array.startIndex
    var j = array.index(before: array.endIndex)
    while i < j {
        switch array[i] + array[j] {
            case let number where number < sum:
                i = array.index(after: i)
            case let number where number > sum:
                j = array.index(before: j)
            default: return (array[i], array[j])
        }
    }
    return nil
}

if let pair = twoSum(in: numbers, to: 2020) {
    print(pair.0 * pair.1)
}

//  MARK: - Part Two

func threeSum(in array: [Int], to sum: Int) -> (Int, Int, Int)? {
    let array = array.sorted()
    var i = array.startIndex
    while i < array.endIndex {
        let slice = array.suffix(from: array.index(after: i))
        let subSum = sum - array[i]
        if let (x, y) = twoSum(in: Array(slice), to: subSum) {
            return (array[i], x, y)
        }
        i = array.index(after: i)
    }
    return nil
}

if let tuple = threeSum(in: numbers, to: 2020) {
    print(tuple.0 * tuple.1 * tuple.2)
}

//: [Next](@next)
