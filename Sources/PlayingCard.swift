//
//  PlayingCard.swift
//  Poker
//
//  Created by span on 8/19/18.
//

public struct PlayingCard {
    public let suit: Suit
    public let rank: Rank

    public init(suit: Suit, rank: Rank) {
        self.suit = suit
        self.rank = rank
    }

    public init?(_ description: String) {
        guard let suit = Suit(rawValue: String(description.last!)),
            let rank = Rank(character: String(description.dropLast())) else {
                return nil
        }
        self.suit = suit
        self.rank = rank
    }
}

extension PlayingCard: Equatable {
    public static func == (lhs: PlayingCard, rhs: PlayingCard) -> Bool {
        return lhs.suit == rhs.suit && lhs.rank == rhs.rank
    }
}

extension PlayingCard: Comparable {
    public static func < (lhs: PlayingCard, rhs: PlayingCard) -> Bool {
        switch (lhs, rhs) {
        case (_, _) where lhs.rank == rhs.rank:
            return lhs.suit < rhs.suit
        default:
            return lhs.rank < rhs.rank
        }
    }
}

extension PlayingCard: CustomStringConvertible {
    public var description: String {
        return rank.description + suit.description
    }
}
