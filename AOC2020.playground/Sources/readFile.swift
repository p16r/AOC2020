import Foundation

public func readFile(named name: String, withExtension extensionName: String) -> String {
    guard let url = Bundle.main.url(forResource: name, withExtension: extensionName) else {
        fatalError("Could not locate file.")
    }
    do {
        return try String(contentsOf: url, encoding: .utf8)
    } catch {
        fatalError(error.localizedDescription)
    }
}
