//: [Previous](@previous)

import Foundation

let input = readFile(named: "input", withExtension: "txt")

let trees = input
    .split(whereSeparator: \.isNewline)
    .map { $0.map { $0 == "#" } }

func countOfTrees(in trees: [[Bool]], right: Int, down: Int) -> Int {
    var i = trees.startIndex
    var j = trees[i].startIndex
    var count = 0
    while i < trees.endIndex {
        let line = trees[i]
        if line[j] { count += 1 }
        j = (j + right) % line.count
        i += down
    }
    return count
}

//  MARK: - Part One

let r3d1 = countOfTrees(in: trees, right: 3, down: 1)
print(r3d1)

//  MARK: - Part Two

let r1d1 = countOfTrees(in: trees, right: 1, down: 1)

let r5d1 = countOfTrees(in: trees, right: 5, down: 1)
let r7d1 = countOfTrees(in: trees, right: 7, down: 1)
let r1d2 = countOfTrees(in: trees, right: 1, down: 2)

print(r1d1 * r3d1 * r5d1 * r7d1 * r1d2)

//: [Next](@next)
