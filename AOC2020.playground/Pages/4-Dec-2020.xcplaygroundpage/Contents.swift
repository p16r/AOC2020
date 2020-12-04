//: [Previous](@previous)

import Foundation

let input = readFile(named: "input", withExtension: "txt")

let passports = input.components(separatedBy: "\n\n")

//  MARK: - Part One

func isValidPassportPartOne(string: String) -> Bool {
    string.contains("byr:") &&
    string.contains("iyr:") &&
    string.contains("eyr:") &&
    string.contains("hgt:") &&
    string.contains("hcl:") &&
    string.contains("ecl:") &&
    string.contains("pid:")
}

let validPassportsPartOne = passports
    .filter(isValidPassportPartOne)
    .count
print(validPassportsPartOne)

//  MARK: - Part Two

extension String {

    func matches(regexString regex: String) -> Bool {
        range(of: regex, options: .regularExpression) != nil
    }

}

func isValidPassportPartTwo(string: String) -> Bool {
    let regexStrings = [
        #"(?<=byr:)19[2-9]\d|200[0-3]"#,
        #"(?<=iyr:)20(1\d|20)"#,
        #"(?<=eyr:)20(2\d|30)"#,
        #"(?<=hgt:)(1[5-8]\d|19[0-3])(?=cm)|(59|6\d|7[0-6])(?=in)"#,
        #"(?<=hcl:)#[[:xdigit:]]{6}"#,
        #"(?<=ecl:)amb|blu|brn|gry|grn|hzl|oth"#,
        #"(?<=pid:)\d{9}\b"#,
    ]
    return regexStrings.allSatisfy(string.matches(regexString:))
}

let validPassportsParTwo = passports
    .filter(isValidPassportPartTwo)
    .count
print(validPassportsParTwo)

//: [Next](@next)
