
import Foundation

enum CardValue:Equatable,Comparable {
    case _2, _3, _4, _5, _6, _7, _8, _9, T, J, Q, K, A, Unknown
    
    init(value: String) {
        switch value {
            case "2": self = ._2
            case "3":self = ._3
            case "4":self = ._4
            case "5":self = ._5
            case "6":self = ._6
            case "7":self = ._7
            case "8":self = ._8
            case "9":self = ._9
            case "T":self = .T
            case "J":self = .J
            case "Q":self = .Q
            case "K":self = .K
            case "A":self = .A
            default:
                self = .Unknown
         }
    }
    var value:Int {
        switch (self) {
        case ._2: return 2
        case ._3: return 3
        case ._4: return 4
        case ._5: return 5
        case ._6: return 6
        case ._7: return 7
        case ._8: return 8
        case ._9: return 9
        case .T: return 10
        case .J: return 11
        case .Q: return 12
        case .K: return 13
        case .A: return 14
        default:
            return -1
        }
    }
}
enum Suit:Equatable,Comparable {
    case Diamond, Heart, Club, Spade, Unknown
    
    init(value: String) {
        switch value {
            case "D": self = .Diamond
            case "H":self = .Heart
            case "C":self = .Club
            case "S":self = .Spade

            default:
                self = .Unknown
         }
    }
}

enum Rank:Equatable,Comparable {
    case highCard
    case pair(pairedValue:Int)
    case twoPairs(lowPairedValue:Int, highPairedValue:Int)
    case threeOfAKind(threeOfAkindValue:Int)
    case straight
    case flush
    case fullHouse(threeOfAkindValue:Int, pairedValue:Int)
    case fourOfAKind(fourCardOfAKindValue: Int, remains: Int)
    case straightFlush
    case royalFlush
    
    var value:Any {
        switch self {
            case .highCard:
                return Rank.highCard
            case .pair(let pairedValue):
                return pairedValue
            case .twoPairs(let lowPairedValue, let highPairedValue):
                return (lowPairedValue,highPairedValue)
            case .threeOfAKind(let threeOfAkindValue):
                return threeOfAkindValue
            case .straight:
                return Rank.straight
            case .flush:
                return Rank.flush
            case .fullHouse(let threeOfAkindValue, let pairedValue):
                return (threeOfAkindValue, pairedValue)
            case .fourOfAKind(let fourCardOfAKindValue, let remains):
                return (fourCardOfAKindValue,remains)
            case .straightFlush:
                return Rank.straightFlush
            case .royalFlush:
                return Rank.royalFlush
         }
    }
}
struct Card {
    var value: CardValue
    var suit: Suit
}

struct Player {
    var cards: [Card]
    var rank: Rank
}
