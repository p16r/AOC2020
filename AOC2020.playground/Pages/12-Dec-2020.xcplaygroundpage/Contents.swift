//: [Previous](@previous)

import Foundation

extension Int {

    var toRadians: Double { Double(self) / 180.0 * .pi }

}

let input = readFile(named: "input", withExtension: "txt")

let instructions = input
    .split(separator: "\n")

//  MARK: - Part One

let ship = instructions
    .reduce(into: (x: 0, y: 0, heading: 0)) { (point, instruction) in

        guard
            let letter = instruction.first,
            let magnitude = Int(instruction.dropFirst())
        else { fatalError("Unexpected instruction: \(instruction)") }

        switch letter {
            case "N": point.y += magnitude
            case "E": point.x += magnitude
            case "S": point.y -= magnitude
            case "W": point.x -= magnitude
            case "L": point.heading += magnitude
            case "R": point.heading -= magnitude
            case "F":
                point.x += magnitude * Int(cos(point.heading.toRadians))
                point.y += magnitude * Int(sin(point.heading.toRadians))
            default: fatalError("Unexpected instruction: \(instruction)")
        }
    }

print(abs(ship.x) + abs(ship.y))

//  MARK: - Part Two

let points = instructions
    .reduce(into: (way: (x: 10, y: 1), ship: (x: 0, y: 0))) { (points, instruction) in

        guard
            let letter = instruction.first,
            let magnitude = Int(instruction.dropFirst())
        else { fatalError("Unexpected instruction: \(instruction)") }

        switch letter {
            case "N": points.way.y += magnitude
            case "E": points.way.x += magnitude
            case "S": points.way.y -= magnitude
            case "W": points.way.x -= magnitude
            case "L":
                let c = Int(cos(magnitude.toRadians))
                let s = Int(sin(magnitude.toRadians))
                let x = points.way.x * c - points.way.y * s
                let y = points.way.x * s + points.way.y * c
                points.way = (x, y)
            case "R":
                let c = Int(cos(-magnitude.toRadians))
                let s = Int(sin(-magnitude.toRadians))
                let x = points.way.x * c - points.way.y * s
                let y = points.way.x * s + points.way.y * c
                points.way = (x, y)
            case "F":
                points.ship.x += points.way.x * magnitude
                points.ship.y += points.way.y * magnitude
            default: fatalError("Unexpected instruction: \(instruction)")
        }
    }

print(abs(points.ship.x) + abs(points.ship.y))

//: [Next](@next)
