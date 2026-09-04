import Foundation
import Security

enum PasswordGenerationError: Error, Equatable {
    case invalidLength
    case noEnabledCategories
    case secureRandomFailure
}

enum PasswordCategory: CaseIterable, Identifiable {
    case lowercase
    case uppercase
    case numbers
    case symbols

    var id: Self { self }

    var characters: [Character] {
        switch self {
        case .lowercase:
            Array("abcdefghijklmnopqrstuvwxyz")
        case .uppercase:
            Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        case .numbers:
            Array("0123456789")
        case .symbols:
            Array("!@#$%^&*()_-+=<>?/|")
        }
    }
}

struct PasswordOptions: Equatable {
    var includeLowercase = true
    var includeUppercase = true
    var includeNumbers = true
    var includeSymbols = true

    var enabledCategories: [PasswordCategory] {
        var categories: [PasswordCategory] = []
        if includeLowercase { categories.append(.lowercase) }
        if includeUppercase { categories.append(.uppercase) }
        if includeNumbers { categories.append(.numbers) }
        if includeSymbols { categories.append(.symbols) }
        return categories
    }

    var isValid: Bool {
        !enabledCategories.isEmpty
    }
}

enum PasswordStrength: String {
    case basic = "Básica"
    case good = "Buena"
    case strong = "Fuerte"
    case excellent = "Excelente"

    init(length: Int, options: PasswordOptions) {
        let categoryCount = options.enabledCategories.count
        let score = length + (categoryCount * 4)

        switch score {
        case 28...:
            self = .excellent
        case 20...:
            self = .strong
        case 12...:
            self = .good
        default:
            self = .basic
        }
    }
}

struct PasswordGenerator {
    static let allowedLengthRange = 4...32

    func generate(length: Int, options: PasswordOptions) throws -> String {
        guard Self.allowedLengthRange.contains(length) else {
            throw PasswordGenerationError.invalidLength
        }

        let categories = options.enabledCategories
        guard !categories.isEmpty else {
            throw PasswordGenerationError.noEnabledCategories
        }

        let requiredCharacters = try categories.map { try secureRandomCharacter(from: $0.characters) }
        let remainingCharacters = try (0..<(length - requiredCharacters.count)).map { _ in
            try secureRandomCharacter(from: categories.flatMap(\.characters))
        }

        return String(try secureShuffle(requiredCharacters + remainingCharacters))
    }

    private func secureRandomCharacter(from characters: [Character]) throws -> Character {
        let index = try secureRandomIndex(upperBound: characters.count)
        return characters[index]
    }

    private func secureShuffle(_ characters: [Character]) throws -> [Character] {
        var shuffled = characters

        guard shuffled.count > 1 else {
            return shuffled
        }

        for index in stride(from: shuffled.count - 1, through: 1, by: -1) {
            let randomIndex = try secureRandomIndex(upperBound: index + 1)
            shuffled.swapAt(index, randomIndex)
        }

        return shuffled
    }

    private func secureRandomIndex(upperBound: Int) throws -> Int {
        guard upperBound > 0 else {
            throw PasswordGenerationError.invalidLength
        }

        let limit = UInt8.max - (UInt8.max % UInt8(upperBound))
        var randomByte: UInt8 = 0

        repeat {
            let status = SecRandomCopyBytes(kSecRandomDefault, 1, &randomByte)
            guard status == errSecSuccess else {
                throw PasswordGenerationError.secureRandomFailure
            }
        } while randomByte >= limit

        return Int(randomByte % UInt8(upperBound))
    }
}
