//: [Previous](@previous)

import Foundation

let input = readFile(named: "input", withExtension: "txt")

let numbers: [Int] = { input in
    var array = [0]
    input
        .split(separator: "\n")
        .compactMap { Int($0) }
        .sorted()
        .forEach { array.append($0) }
    array.append(array.last! + 3)
    return array
} (input)

extension Array {

    subscript(after index: Index) -> Element {
        self[self.index(after: index)]
    }

}

//  MARK: - Part One

func productOfDifferences(in numbers: [Int]) -> Int {
    let tuple = numbers
        .indices
        .dropLast()
        .reduce(into: (ones: 0, threes: 0)) { (tuple, index) in
            let difference = numbers[numbers.index(after: index)] - numbers[index]
            if difference == 1 { tuple.ones += 1 }
            else if difference == 3 { tuple.threes += 1 }
        }
    return tuple.ones * tuple.threes
}

print(productOfDifferences(in: numbers))

//  MARK: - Part Two

func adapterCombinationCount(in array: [Int]) -> Int {
    var cache = [Int: Int]()

    func adapterCombinationCount(in slice: ArraySlice<Int>) -> Int {
        if let cachedNumber = cache[slice.startIndex] { return cachedNumber }
        let number: Int
        if slice.count == 1 {
            number = 1
        } else {
            number = slice
                .dropFirst()
                .prefix { $0 - slice[slice.startIndex] <= 3 }
                .indices
                .reduce(0) { sum, index in
                    sum + adapterCombinationCount(in: slice.suffix(from: index))
                }
        }
        cache[slice.startIndex] = number
        return number
    }

    return adapterCombinationCount(in: array[array.startIndex...])
}

print(adapterCombinationCount(in: numbers))

//: [Next](@next)
