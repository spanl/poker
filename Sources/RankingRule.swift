//
//  RankingRule.swift
//  Poker
//
//  Created by span on 8/19/18.
//

public enum RankingCategory: Int {
    case highCard
    case onePair
    case twoPairs
    case threeOfaKind
    case straight
    case flush
    case fullHouse
    case fourOfaKind
    case straightFlush

    static func calculate(from cards: [PlayingCard]) -> (RankingCategory, [PlayingCard], [PlayingCard])? {
        guard cards.count == 5 else { return nil }

        var sorted = Array(cards.sorted().reversed())
        var structured = [Int]()
        var ranking: RankingCategory = .highCard

        var isStraight = true
        var isFlush = true

        for i in 1..<sorted.count {
            let prev = sorted[i - 1]
            let card = sorted[i]

            if prev.rank == card.rank {
                isStraight = false
                switch ranking {
                case .highCard:
                    ranking = .onePair
                    structured.append(contentsOf: [i - 1, i])
                case .onePair:
                    if sorted[structured.last!] == prev {
                        ranking = .threeOfaKind
                        structured.append(i)
                    } else {
                        ranking = .twoPairs
                        structured.append(contentsOf: [i - 1, i])
                    }
                case .twoPairs:
                    ranking = .fullHouse
                    structured.append(i)
                case .threeOfaKind:
                    if sorted[structured.last!] == prev {
                        ranking = .fourOfaKind
                        structured.append(i)
                    } else {
                        ranking = .fullHouse
                        structured.append(contentsOf: [i - 1, i])
                    }
                default:
                    break
                }
            } else if isStraight, prev.rank.rawValue - card.rank.rawValue != 1 {
                isStraight = false
            }

            if isFlush, prev.suit != card.suit {
                isFlush = false
            }
        }

        if !isStraight, sorted.first!.rank == .ace, sorted.last!.rank == .two {
            var aceStraight = true
            for i in Array(1..<sorted.count - 1).reversed() {
                let prev = sorted[i + 1]
                let card = sorted[i]
                if prev.rank.rawValue != card.rank.rawValue - 1 {
                    aceStraight = false
                    break
                }
            }
            isStraight = aceStraight
        }

        if isStraight {
            ranking = .straight
            structured = Array(0..<sorted.count)
        }

        if isFlush, ranking <= .flush {
            ranking = isStraight ? .straightFlush : .flush
            structured = Array(0..<sorted.count)
        }

        if ranking == .fullHouse, sorted.filter({ $0.rank == sorted[structured.first!].rank }).count == 2 {
            structured = Array(structured[3..<5] + structured[..<3])
        }

        let singles = sorted.enumerated().filter { !structured.contains($0.offset) }.map { $0.element }

        return (ranking, structured.map({sorted[$0]}), singles)
    }
}

extension RankingCategory: Comparable {
    public static func < (lhs: RankingCategory, rhs: RankingCategory) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

