//
//  Suit.swift
//  Poker
//
//  Created by span on 8/19/18.
//

public enum Suit: String {
    case spades = "♤"
    case hearts = "♡"
    case clubs = "♧"
    case diamonds = "♢"
}

extension Suit: Comparable {
    public static func < (lhs: Suit, rhs: Suit) -> Bool {
        switch (lhs, rhs) {
        case (_, _) where lhs == rhs:
            return false
        case (.spades, _), (.hearts, .clubs), (.hearts, .diamonds), (.clubs, .diamonds):
            return false
        default:
            return true
        }
    }
}

extension Suit: CustomStringConvertible {
    public var description: String {
        return rawValue
    }
}
