//: [Previous](@previous)

import Foundation

let input = readFile(named: "input", withExtension: "txt")

typealias InstructionGroup = (mask: Substring, writes: [(loc: Int, val: Int)])

let instructionGroups: [InstructionGroup] = input
    .components(separatedBy: "mask = ")
    .dropFirst()
    .map {
        let lines = $0.split(separator: "\n")
        let mask = lines.first!
        let array = lines
            .dropFirst()
            .reduce(into: [(loc: Int, val: Int)]()) { array, instruction in
                let instruction = instruction.drop { !$0.isNumber }
                let loc = instruction.prefix { $0.isNumber }
                let val = instruction.dropFirst(loc.count + "] = ".count)
                array.append((Int(loc)!, Int(val)!))
            }
        return (mask: mask, writes: array)
    }

//  MARK: - Part One

func memorySum(from instructions: [InstructionGroup]) -> Int {
    instructions
        .reduce(into: [Int: Int]()) { dict, instructionSet in
            instructionSet.writes.forEach {
                let valString = String(repeating: "0", count: 36)
                    .appending(String($0.val, radix: 2))
                    .suffix(36)
                let string = zip(instructionSet.mask, valString)
                    .reduce(into: "") { (string, tuple) in
                        string.append(tuple.0 == "X" ? tuple.1 : tuple.0)
                    }
                dict[$0.loc] = Int(string, radix: 2)
            }
        }
        .reduce(0) { sum, tuple in
            sum + tuple.value
        }
}

print(memorySum(from: instructionGroups))

//  MARK: - Part Two

func modifiedMemorySum(from instructionGroups: [InstructionGroup]) -> Int {
    instructionGroups
        .reduce(into: [Int: Int]()) { (dictionary, instructionGroup) in
            instructionGroup.writes.forEach { instruction in
                let locString = String(repeating: "0", count: 36)
                    .appending(String(instruction.loc, radix: 2))
                    .suffix(36)
                zip(instructionGroup.mask, locString)
                    .reduce(into: "") { (string, tuple) in
                        switch  tuple.0 {
                            case "0": string.append(tuple.1)
                            case "1": string.append("1")
                            case "X": string.append("X")
                            default: break
                        }
                    }
                    .reversed()
                    .reduce(into: [Int]()) { (array, character) in
                        switch character {
                            case "0": array.isEmpty
                                ? array.append(0)
                                : array.indices.forEach { array[$0] *= 2 }
                            case "1": array.isEmpty
                                ? array.append(1)
                                : array.indices.forEach { array[$0] = 2 * array[$0] + 1 }
                            case "X": array = array.isEmpty
                                ? [0, 1]
                                : array.flatMap { [$0 * 2, $0 * 2 + 1] }
                            default: break
                        }
                    }
                    .forEach { mask in
                        dictionary[mask] = instruction.val
                    }
            }
        }
        .reduce(0) { sum, tuple in
            sum + tuple.value
        }

}

print(modifiedMemorySum(from: instructionGroups))

//: [Next](@next)
