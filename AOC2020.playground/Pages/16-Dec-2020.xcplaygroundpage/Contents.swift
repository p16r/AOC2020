//: [Previous](@previous)

import Foundation

let input = readFile(named: "input", withExtension: "txt")

let components = input.components(separatedBy: "\n\n")

struct Field: Equatable {

    let string: Substring
    let lowerRange: ClosedRange<Int>
    let upperRange: ClosedRange<Int>

    init(_ substring: Substring) {
        let numbers = substring
            .split { "0123456789".contains($0) == false }
            .compactMap { Int($0) }
        self.string = substring.prefix { $0 != ":" }
        self.lowerRange = numbers[0]...numbers[1]
        self.upperRange = numbers[2]...numbers[3]
    }

    func contains(_ number: Int) -> Bool {
        lowerRange.contains(number) || upperRange.contains(number)
    }

}

let fields = components[0]
    .split(separator: "\n")
    .map(Field.init)

let yourTicket = components[1]
    .split(separator: "\n")
    .last!
    .split(separator: ",")
    .compactMap { Int($0) }

let nearbyTickets = components[2]
    .split(separator: "\n")
    .dropFirst()
    .map { ticket in
        ticket
            .split(separator: ",")
            .compactMap { Int($0) }
    }

//  MARK: - Part One

let errorRate = nearbyTickets
    .flatMap { $0 }
    .filter { number in
        fields.allSatisfy { $0.contains(number) == false }
    }
    .reduce(0, +)
print(errorRate)

//  MARK: - Part Two

let validTickets = nearbyTickets.filter { ticket in
    ticket.contains { number in
        fields.allSatisfy { $0.contains(number) == false }
    } == false
}

let product = yourTicket
    .indices
    .reduce(into: [Int: [Field]]()) { (dict, index) in
        dict[index] = fields.filter {
            validTickets
                .map { $0[index] }
                .allSatisfy($0.contains)
            }
    }
    .sorted { $0.value.count < $1.value.count }
    .reduce(into: [(index: Int, field: Field)]()) { (array, tuple) in
        let index = tuple.key
        let field = tuple.value
            .filter { array.map(\.field).contains($0) == false }
            .first!
        array.append((index: index, field: field))
    }
    .filter { $0.field.string.hasPrefix("departure") }
    .reduce(1) { product, tuple in
        product * yourTicket[tuple.index]
    }

print(product)

//: [Next](@next)
