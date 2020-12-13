//: [Previous](@previous)

import Foundation

let input = readFile(named: "input", withExtension: "txt")

let rows = input.split(separator: "\n")
let timeStamp = Double(rows.first!)!
let busIDs = rows.last!.split(separator: ",").map { Double($0) }
let compactBusIDs = busIDs.compactMap { $0 }

//  MARK: - Part One

let departureTimestamps = compactBusIDs.map { ceil(timeStamp / $0) * $0 }
let nearestDepartureTimestamp = departureTimestamps.min()!
let busID = compactBusIDs[departureTimestamps.firstIndex(of: nearestDepartureTimestamp)!]

print((nearestDepartureTimestamp - timeStamp) * busID)

//  MARK: - Part Two

let busIntervalPairs: [(Int, Int)] = busIDs
    .enumerated()
    .filter { $0.element != nil }
    .compactMap {
        switch $0.element.map({ Int($0) }) {
            case .none: return nil
            case .some(let int): return (int, int - $0.offset % int)
        }
    }

func crt(pairs: [(n: Int, a: Int)]) -> Int {

    func modInverse(of a: Int, under m: Int) -> Int {
        if m == 1 { return 0 }
        var _m = m, y = 0, x = 1, _a = a
        while _a > 1 {
            let quotient = _a / _m
            var temp = _m
            _m = _a % _m
            _a = temp
            temp = y
            y = x - quotient * y
            x = temp
        }
        if x < 0 {
            x += m
        }
        return x
    }

    let product = pairs.reduce(1) { product, tuple in
        product * tuple.n
    }
    let x = pairs.reduce(0) { sum, pair in
        let reducedProduct = product / pair.n
        return sum + pair.a * modInverse(of: reducedProduct, under: pair.n) * reducedProduct
    }
    return x % product
}

print(crt(pairs: busIntervalPairs))

//: [Next](@next)
