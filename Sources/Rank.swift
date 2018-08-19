//
//  Rank.swift
//  Poker
//
//  Created by span on 8/19/18.
//

public enum Rank: Int {
    case two = 2, three, four, five, six, seven, eight, nine, ten
    case jack, queen, king
    case ace

    init?(character: String) {
        switch character {
        case "A": self = .ace
        case "J": self = .jack
        case "Q": self = .queen
        case "K": self = .king
        default:
            if let value = Int(character), value > 1, value <= 10, let rank = Rank(rawValue: value) {
                self = rank
            } else {
                return nil
            }
        }
    }
}

extension Rank: Comparable {
    public static func < (lhs: Rank, rhs: Rank) -> Bool {
        switch (lhs, rhs) {
        case (_, _) where lhs == rhs:
            return false
        case (.ace, _), (_, .ace):
            return rhs == .ace
        default:
            return lhs.rawValue < rhs.rawValue
        }
    }
}

extension Rank: CustomStringConvertible {
    public var description: String {
        switch self {
        case .ace: return "A"
        case .jack: return "J"
        case .queen: return "Q"
        case .king: return "K"
        default:
            return "\(rawValue)"
        }
    }
}
