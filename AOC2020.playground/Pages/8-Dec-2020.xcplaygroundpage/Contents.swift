//: [Previous](@previous)

import Foundation

let input = readFile(named: "input", withExtension: "txt")

enum Instruction {

    case acc(Int)
    case jmp(Int)
    case nop(Int)

    init<S: StringProtocol>(string: S) {
        let substring = string
            .drop { !$0.isWhitespace }
            .dropFirst()
        guard let number = Int(substring) else { fatalError("Missing number.") }
        switch string.prefix(3) {
            case "acc": self = .acc(number)
            case "jmp": self = .jmp(number)
            case "nop": self = .nop(number)
            default: fatalError("Unexpected Instruction.")
        }
    }

    mutating func swapJmpNop() {
        switch self {
            case .jmp(let number): self = .nop(number)
            case .nop(let number): self = .jmp(number)
            default: return
        }
    }

    var isJmpNop: Bool {
        if case .jmp = self { return true }
        if case .nop = self { return true }
        return false
    }

    var isJmp: Bool {
        if case .jmp = self { return true }
        return false
    }

    var isNop: Bool {
        if case .nop = self { return true }
        return false
    }

}

let instructions = input
    .split(separator: "\n")
    .map(Instruction.init)

//  MARK: - Part One

func terminalValue(with instructions: [Instruction], returnAccOnInfiniteLoop: Bool = false) -> Int? {
    var instructionLog = instructions
        .map { (instruction: $0, isExecuted: false) }
    var index = instructions.startIndex
    var acc = 0
    while index < instructionLog.endIndex {
        if instructionLog[index].isExecuted {
            return returnAccOnInfiniteLoop ? acc : nil
        }
        let nextIndex: Int
        switch instructionLog[index].instruction {
            case .acc(let number):
                acc += number
                nextIndex = instructionLog.index(after: index)
            case .jmp(let number):
                nextIndex = instructionLog.index(index, offsetBy: number)
            case .nop:
                nextIndex = instructionLog.index(after: index)
        }
        instructionLog[index].isExecuted = true
        index = nextIndex
    }
    return acc
}

print(terminalValue(with: instructions, returnAccOnInfiniteLoop: true)!)

//  MARK: - Part Two

var instructionsCopy = instructions
var index: Int? = nil

repeat {
    //  Find value of current instructions:
    if let value = terminalValue(with: instructionsCopy) {
        print(value)
        break
    }

    //  Unswap any previous swap because it didn't work:
    index.map { instructionsCopy[$0].swapJmpNop() }

    //  Find index of next swap:
    index = instructionsCopy
        .suffix(from: instructionsCopy.index(after: index ?? instructionsCopy.startIndex))
        .firstIndex(where: \.isJmpNop)

    //  Swap at given index if found:
    index.map { instructionsCopy[$0].swapJmpNop() }
} while (index ?? instructionsCopy.endIndex) < instructionsCopy.endIndex

//: [Next](@next)
