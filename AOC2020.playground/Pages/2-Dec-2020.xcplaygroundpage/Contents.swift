//: [Previous](@previous)

import Foundation

let input = readFile(named: "input", withExtension: "txt")

//  MARK: - Part One

struct PasswordPolicy {

    let lower: Int
    let upper: Int
    let letter: Character
    let password: String

    private static let regex: NSRegularExpression = {
        let pattern = #"^(?<lower>\d+)-(?<upper>\d+) (?<letter>\w+): (?<password>\w+)$"#
        do { return try NSRegularExpression(pattern: pattern) }
        catch { preconditionFailure("Illegal regular expression: \(pattern).") }
    } ()

    init(string: String) {
        let nsRange = NSRange(location: 0, length: string.utf16.count)
        guard let result = Self.regex.matches(in: string, range: nsRange).first else {
            preconditionFailure("Illegal string pattern: \(string).")
        }

        func regexMatch(named name: String) -> Substring? {
            let nsRange = result.range(withName: name)
            let range = Range(nsRange, in: string)
            return range.map { string[$0] }
        }

        guard
            let lower = regexMatch(named: "lower").flatMap({ Int($0) }),
            let upper = regexMatch(named: "upper").flatMap({ Int($0) }),
            let letter = regexMatch(named: "letter").map({ Character(String($0)) }),
            let password = regexMatch(named: "password")
        else {
            preconditionFailure("Illegal string pattern: \(string).")
        }

        self.password = String(password)
        self.lower = lower
        self.upper = upper
        self.letter = letter
    }

}

//  MARK: - Part One

let policies = input
    .split(separator: "\n")
    .map(String.init)
    .map(PasswordPolicy.init)

let hasCorrectLetterCount: (PasswordPolicy) -> Bool = { policy in
    var count = 0
    for character in policy.password {
        if character == policy.letter { count += 1 }
        if count > policy.upper { return false }
    }
    return policy.lower <= count
}

let correctLetterCountPasswords = policies
    .filter(hasCorrectLetterCount)
    .count
print(correctLetterCountPasswords)

//  MARK: - Part Two

extension String {

    subscript(_ count: Int) -> Character { self[index(startIndex, offsetBy: count)] }

}

let hasCorrectLettersAtIndices: (PasswordPolicy) -> Bool = { policy in
    let password = policy.password
    let letter = policy.letter
    return (password[policy.lower - 1] == letter) != (password[policy.upper - 1] == letter)
}

let correctLettersAtIndicesPasswords = policies
    .filter(hasCorrectLettersAtIndices)
    .count
print(correctLettersAtIndicesPasswords)

//: [Next](@next)
