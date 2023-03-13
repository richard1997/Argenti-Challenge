//
//  RankHelper.swift
//  ArgentiChallenge
//
//  Created by Richard Wu on 10/3/2023.
//

import Foundation

class RankHelper {
    /*
     All parameters cards are sorted ascending
     */
    let allSuits:[Suit] = [.Spade,.Heart,.Club,.Diamond]
    /*
     Get low, high card values
     return (lowValue, highValue)
     */
    func getLowHighValues( _ cards:[Card]) -> (Int, Int) {
        return (cards.first?.value.value ?? 2, cards.last?.value.value ?? 14)
    }
    func LowCard(_ cards:[Card]) ->Int {
        return cards.first?.value.value ?? 2
    }
    func HighCard(_ cards:[Card]) ->Int {
        return cards.last?.value.value ?? 2
    }
    /*
     Two cards of same value
     Return (isPair, pairedValue)
     if not found, (false, -1)
     */
    func isPair(_ cards:[Card], high: Int, low: Int) ->(Bool, Int) {
        for val in low ... high {
            let pairCards = cards.filter{ $0.value.value == val }
            if pairCards.count == 2 {
                //Found
                return (true, val)
            }
        }
        
        
        return (false, -1)
    }
    /*
     Two different pairs
     return: (isTwoPairs, lowPairedValue, highPairedValue)
     if not, (false, -1, -1)
     */
    func isTwoPairs(_ cards:[Card],high: Int, low: Int) ->(Bool,Int, Int) {
        let (firstPaired, lowPairedVal) = isPair(cards, high: high, low: low)
        
        if firstPaired && lowPairedVal < high{
            let (sndPaired, highPairedVal) = isPair(cards, high: high, low: lowPairedVal + 1)
            if sndPaired {
                return (true, lowPairedVal, highPairedVal)
            }
        }
        
        return (false, -1, -1)
    }
    /*
     Three cards of the same value
     return (isThreeOfAKind, threeOfAkindValue)
     if not, (false, -1)
     */
    func isThreeOfAKind(_ cards:[Card],high: Int, low: Int) ->(Bool, Int) {
        for val in low ... high {
            let threeCards = cards.filter{ $0.value.value == val }
            if threeCards.count == 3 {
                //Found
                return (true, val)
            }
        }
        
        return (false, -1)
    }
    /*
     All five cards in consecutive value order
     */
    func isStraight(_ cards:[Card],high: Int, low: Int) ->Bool {
        let sndToFirstVal = cards[1].value.value - cards[0].value.value
        let thrdToSndVal = cards[2].value.value - cards[1].value.value
        let fourToThirdVal = cards[3].value.value - cards[2].value.value
        let fifthToFourVal = cards[4].value.value - cards[3].value.value
        return (sndToFirstVal == 1) && (thrdToSndVal == 1) && (fourToThirdVal == 1) && (fifthToFourVal == 1)
    }
    /*
     All five cards having the same suit
     */
    func isFlush(_ cards:[Card]) ->Bool {
        for suit in allSuits {
            let sameSuitCards = cards.filter { $0.suit == suit }
            if sameSuitCards.count == 5 {
                return true
            }
        }
        
        return false
    }
    /*
     Three of a kind and a Pair
     return (isFullHouse,threeOfAkindValue,pairedValue)
     if not, (false, -1, -1)
     */
    func isFullHouse(_ cards:[Card],high: Int, low: Int) ->(Bool,Int,Int) {
        let (isThreeOfAKind, threeOfAkindValue) = isThreeOfAKind(cards, high: high, low: low)
        if isThreeOfAKind {
            let (isPair, pairedValue) = isPair(cards, high: high, low: low)
            if isPair {
                return (true, threeOfAkindValue,pairedValue)
            }
        }
        return (false, -1,-1)
    }
    /*
     Four cards of the same value
     return (isFourCardOfAKind, fourCardOfAKindValue,remains)
     if not, (false, -1)
     */
    func isFourOfAKind(_ cards:[Card],high: Int, low: Int) ->(Bool, Int, Int) {
        for val in low ... high {
            let fourCards = cards.filter{ $0.value.value == val }
            if fourCards.count == 4 {
                //find the other card
                let remainsCards = cards.filter{ $0.value.value != val }
                var remainVal = -1
                if remainsCards.count > 0 {
                    remainVal = remainsCards.first?.value.value ?? -1
                }
                return (true, val,remainVal)
            }
        }
        
        return (false, -1,-1)
    }
    /*
     All five cards in consecutive value order, with the same suit
     return  true/false
     */
    func isStraightFlush(_ cards:[Card],high: Int, low: Int) ->Bool {
        return isStraight(cards, high: high, low: low) && isFlush(cards)
    }
    /*
     Ten, Jack, Queen, King and Ace in the same suit
     return true/false
     */
    func isRoyalFlush(_ cards:[Card],high: Int, low: Int) ->Bool {
        return (low == 10) && isStraightFlush(cards, high: high, low: low)
    }
    /*
     Get player card rank
     */
    func getPlayerCardsRank(_ cards:[Card]) -> Rank {
        let (low, high) = getLowHighValues(cards)
        //Check Royal Flush first
        if isRoyalFlush(cards, high: high, low: low){
            return Rank.royalFlush
        }
        //Then Stright Flush
        if isStraightFlush(cards, high: high, low: low) {
            return Rank.straightFlush
        }
        //Four of a kind
        let (isFourCardOfAKind, fourCardOfAKindValue, remain) = isFourOfAKind(cards, high: high, low: low)
        if isFourCardOfAKind {
            return Rank.fourOfAKind(fourCardOfAKindValue: fourCardOfAKindValue,remains: remain)
        }
        //Full house
        let (isFullHouse,threeOfAkindValue,pairedValue) = isFullHouse(cards, high: high, low: low)
        if isFullHouse {
            return Rank.fullHouse(threeOfAkindValue: threeOfAkindValue, pairedValue: pairedValue)
        }
        //Flush
        if isFlush(cards) {
            return Rank.flush
        }
        //Straight
        if isStraight(cards, high: high, low: low) {
            return Rank.straight
        }
        //Three of a kind
        let (isThreeOfAKind, threeOfAkindValue2) = isThreeOfAKind(cards, high: high, low: low)
        if isThreeOfAKind {
            return Rank.threeOfAKind(threeOfAkindValue: threeOfAkindValue2)
        }
        //Two pairs
        let (isTwoPairs, lowPairedValue, highPairedValue) = isTwoPairs(cards, high: high, low: low)
        if isTwoPairs {
            return Rank.twoPairs(lowPairedValue: lowPairedValue, highPairedValue: highPairedValue)
        }
        //Pair
        let (isPair, pairedValue2) = isPair(cards, high: high, low: low)
        if isPair {
            return Rank.pair(pairedValue: pairedValue2)
        }
        //If all are not matched, it's high card
        return Rank.highCard
    }
    
    /*
     Compare two cards which sorted with descending
     Return (1,0) if card1Value higher than card2Value
     (0, 1) if card1 lower than card2
     otherwise, (0,0)
     */
    func compareCards(_ cards1: [Card], cards2: [Card]) -> (Int, Int) {
        for index in 0 ..< cards1.count {
            let card1Value = cards1[index].value.value
            let card2Value = cards2[index].value.value
            if card1Value > card2Value {
                return (1,0)
            } else if card1Value < card2Value {
                return (0,1)
            }
        }
        return (0,0)
    }
    /*
     player1 & player2
     return (player1Win, player2Win)
     if player1 wins,(1,0)
     if player2 wins,(0,1)
     if tie, (0,0)
     */
    func playersMatchResult(_ player1: Player, player2: Player) -> (Int,Int) {
        if player1.rank < player2.rank {
            return (0,1)
        }
        if player1.rank > player2.rank {
            return (1,0)
        }
        //rank equals
        let (_, player1High) = getLowHighValues(player1.cards)
        let (_, player2High) = getLowHighValues(player2.cards)
        switch player1.rank {
        case .royalFlush:
            return (0,0)
        case .straightFlush:
            if player1High == player2High {
                return (0,0)
            } else if player1High < player2High {
                return (0,1)
            } else {
                return (1,0)
            }
        case .fourOfAKind(let fourCardOfAKindValue,let remains):
            let (player2FourCardOfAKindValue,player2Remain) = player2.rank.value as? (Int, Int) ?? (-1,-1)
            if fourCardOfAKindValue < player2FourCardOfAKindValue {
                return (0, 1)
            } else if fourCardOfAKindValue > player2FourCardOfAKindValue {
                return (1, 0)
            } else {
                //equals
                if remains > player2Remain {
                    return (1,0)
                } else if remains < player2Remain {
                    return (0,1)
                } else {
                    return (0,0)
                }
             }
        case .fullHouse(let threeOfAkindValue, let pairedValue):
            let (player2ThreeOfAkindValue,player2PairedValue) = player2.rank.value as? (Int, Int) ?? (-1,-1)
            if threeOfAkindValue == player2ThreeOfAkindValue {
                if pairedValue > player2PairedValue {
                    return (1,0)
                } else if (pairedValue < player2PairedValue) {
                    return (0,1)
                } else {
                    return (0,0)
                }
            } else if threeOfAkindValue > player2ThreeOfAkindValue {
                return (1,0)
            } else {
                return (0,1)
            }
        case .flush:
            
            for index in (0 ... 4).reversed() {
                let player1CardValue = player1.cards[index].value.value
                let player2CardValue = player2.cards[index].value.value
                if player1CardValue < player2CardValue {
                    return (0,1)
                } else if player1CardValue > player2CardValue {
                    return (1,0)
                }
            }
            return (0,0)
        case .straight:
            if player1High > player2High {
                return (1,0)
            } else if player1High < player2High {
                return (0,1)
            } else {
                return (0,0)
            }
        case .threeOfAKind(let threeOfAkindValue):
            let player2ThreeOfAkindValue = player2.rank.value as? Int ?? 0
            if threeOfAkindValue < player2ThreeOfAkindValue {
                return (0,1)
            } else if threeOfAkindValue > player2ThreeOfAkindValue {
                return (1,0)
            } else {
                //Equal
                let player1OtherCards = player1.cards.filter { $0.value.value != threeOfAkindValue }.sorted{ $0.value.value > $1.value.value } //Descending
                let player2OtherCards = player2.cards.filter { $0.value.value != threeOfAkindValue }.sorted{ $0.value.value > $1.value.value } //Descending

                return compareCards(player1OtherCards, cards2: player2OtherCards)
            }
        case .twoPairs(let lowPairedValue, let highPairedValue):
            let (player2LowPairedValue, player2HighPairedValue) = player2.rank.value as? (Int, Int) ?? (0,0)
            if highPairedValue == player2HighPairedValue {
                if lowPairedValue < player2LowPairedValue {
                    return (0,1)
                } else if lowPairedValue > player2LowPairedValue {
                    return (1,0)
                } else {
                    //Equals
                    let player1RemainCardVal = player1.cards.filter { $0.value.value != lowPairedValue && $0.value.value != highPairedValue}.first?.value.value ?? 0
                    let player2RemainCardVal = player2.cards.filter { $0.value.value != lowPairedValue && $0.value.value != highPairedValue}.first?.value.value ?? 0
                    if player1RemainCardVal > player2RemainCardVal {
                        return (1,0)
                    } else if player1RemainCardVal < player2RemainCardVal {
                        return (0,1)
                    } else {
                        return (0,0)
                    }
                }
            } else if highPairedValue < player2HighPairedValue {
                return (0,1)
            } else {
                return (1,0)
            }
            
        case .pair(let pairedValue):
            let player2PairedValue = player2.rank.value as? Int ?? 0
            if pairedValue < player2PairedValue {
                return (0,1)
            } else if pairedValue > player2PairedValue {
                return (1,0)
            } else {
                //Equal
                let player1OtherCards = player1.cards.filter { $0.value.value != pairedValue }.sorted{ $0.value.value > $1.value.value } //Descending
                let player2OtherCards = player2.cards.filter { $0.value.value != pairedValue }.sorted{ $0.value.value > $1.value.value } //Descending

                return compareCards(player1OtherCards, cards2: player2OtherCards)
            }
            
        case .highCard:
            let player1CardsReversed = player1.cards.sorted { $0.value.value > $1.value.value}
            let player2CardsReversed = player2.cards.sorted { $0.value.value > $1.value.value}
            
            return compareCards(player1CardsReversed, cards2: player2CardsReversed)
        }
    }
    
        
}
