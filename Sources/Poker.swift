//
//  Rank.swift
//  Poker
//
//  Created by span on 8/19/18.
//

public struct PokerHand {

    fileprivate let cards: [PlayingCard]

    public let rankedCatagory: RankingCategory
    public let structedCards: [PlayingCard]
    public let singleCards: [PlayingCard]

    public init?(_ cards: [PlayingCard]) {
        guard let ranking = RankingCategory.calculate(from: cards) else {
            return nil
        }
        self.cards = cards
        self.rankedCatagory = ranking.0
        self.structedCards = ranking.1
        self.singleCards = ranking.2
    }
}

extension PokerHand: Collection {
    public typealias Index = Array<PlayingCard>.Index
    public typealias Element = Array<PlayingCard>.Element

    public var startIndex: Index {
        return cards.startIndex
    }

    public var endIndex: Index {
        return cards.endIndex
    }

    public subscript(position: Index) -> Element {
        return cards[position]
    }

    public func index(after i: Index) -> Index {
        return cards.index(after: i)
    }
}

extension PokerHand: Equatable {
    public static func == (lhs: PokerHand, rhs: PokerHand) -> Bool {
        guard lhs.rankedCatagory == rhs.rankedCatagory,
            lhs.structedCards == rhs.structedCards,
            lhs.singleCards == rhs.singleCards else {
                return false
        }
        return true
    }
}

extension PokerHand: Comparable {
    public static func < (lhs: PokerHand, rhs: PokerHand) -> Bool {
        if lhs.rankedCatagory != rhs.rankedCatagory {
            return lhs.rankedCatagory < rhs.rankedCatagory
        }

        var zipped = zip(lhs.structedCards + lhs.singleCards, rhs.structedCards + rhs.singleCards)

        for (l, r) in zipped where l.rank != r.rank {
            return l.rank < r.rank
        }

        zipped = zip(lhs.sorted().reversed(), rhs.sorted().reversed())

        for (l, r) in zipped where l.suit != r.suit {
            return l.suit < r.suit
        }

        return false
    }
}

extension PokerHand: CustomStringConvertible {
    public var description: String {
        return String(cards.reduce("", { return "\($0) \($1.description)" }).dropFirst())
    }
}


// MARK: -
public protocol PokerHandConvertiable {

    func asPokerHand() -> PokerHand?
}

extension PokerHand {

    public init?(_ cards: PokerHandConvertiable) {
        guard let instance = cards.asPokerHand() else { return nil }
        self = instance
    }
}

extension String: PokerHandConvertiable {
    public func asPokerHand() -> PokerHand? {
        let cards = split(separator: " ").compactMap { PlayingCard(String($0)) }
        return PokerHand(cards)
    }
}

public func bestHand<T: PokerHandConvertiable>(_ hands: [T]) -> T? {
    var best: (Int, PokerHand?) = (-1, nil)

    best = hands.enumerated().reduce(best) { result, element -> (Int, PokerHand?) in
        guard let hand = element.1.asPokerHand() else { return result }
        if result.1 == nil || hand > result.1! {
            return (element.0, hand)
        }
        return result
    }

    return best.0 == -1 ? nil : hands[best.0]
}
