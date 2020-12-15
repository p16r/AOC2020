//: [Previous](@previous)

import Foundation

let input = [20, 0, 1, 11, 6, 3]

//  MARK: - Part One

func memoryGame(startingArray: [Int], turns: Int) -> Int {
    guard var number = startingArray.last else {
        preconditionFailure("Can't play the memory game with an empty array.")
    }
    var memory = startingArray
        .enumerated()
        .reduce(into: [Int: Int]()) { (dict, tuple) in
            dict[tuple.element] = tuple.offset
        }
    for i in startingArray.count ..< turns  {
        let i = i - 1
        if let index = memory[number] {
            memory[number] = i
            number = i - index
        } else {
            memory[number] = i
            number = 0
        }
    }
    return number
}

print(memoryGame(startingArray: input, turns: 2020))

//  MARK: - Part Two

print(memoryGame(startingArray: input, turns: 30000000))

//: [Next](@next)
