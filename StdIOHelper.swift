//
//  StdIOHelper.swift
//  ArgentiChallenge
//
//  Created by Richard Wu on 10/3/2023.
//

import Foundation

class StdIOHelper {
    
    func printUsage() {
      let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
      
      print("usage:")
      print("Type \(executableName) without an argument to enter interactive mode.")
      print("or")
      print("\(executableName) testFileName to verify results")
    }
    
    func getInput() -> String? {
      let userEntered = FileHandle.standardInput
      let inputData = userEntered.availableData
      let strData = String(data: inputData, encoding: String.Encoding.utf8)
      return strData?.trimmingCharacters(in: CharacterSet.newlines)
    }
    
    func getCardsWithSorted(_ str: String) ->([Card], [Card])? {
        let array = str.components(separatedBy: " ")
        if array.count == 10 {
            let firstPart = array.prefix(5)
            let firstPartCards = firstPart.map { (str) -> Card in
                let val = String(str.prefix(1)) //Card Value
                let suit = String(str.suffix(1)) //Suit
                let card = Card(value: CardValue(value: val), suit: Suit(value: suit))
                return card
            }
            let firstPartCardsSorted = firstPartCards.sorted{ $0.value < $1.value } //Asecending
            let sndPart = array.suffix(5) 

            let sndPartCards = sndPart.map { (str) -> Card in
                let val = String(str.prefix(1)) //Card Value
                let suit = String(str.suffix(1)) //Suit
                let card = Card(value: CardValue(value: val), suit: Suit(value: suit))
                return card
            }
            let sndPartCardsSorted = sndPartCards.sorted{ $0.value < $1.value } //Asecending
            return (firstPartCardsSorted,sndPartCardsSorted)
        }
        return nil
    }
}
    

