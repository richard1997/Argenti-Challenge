//
//  PlayCards.swift
//  ArgentiChallenge
//
//  Created by Richard Wu on 10/3/2023.
//

import Foundation

class PlayCards {
    let stdIOHelper = StdIOHelper()
    let rankHelper = RankHelper()
    
    func interactiveMode() {
        var player1WinCount = 0, player2WinCount = 0

        var shouldQuit = false
        while !shouldQuit {
            print("\nEnter card details to proceed. Enter 'stop' to quit.")
            let userEntered = stdIOHelper.getInput() ?? ""
            
            if userEntered == "stop" {
                shouldQuit = true
            } else {
                let (player1Cards, player2Cards) = stdIOHelper.getCardsWithSorted(userEntered) ?? ([],[])
                let player1Rank = rankHelper.getPlayerCardsRank(player1Cards)
                let player2Rank = rankHelper.getPlayerCardsRank(player2Cards)
                let player1 = Player(cards: player1Cards, rank: player1Rank)
                let player2 = Player(cards: player2Cards, rank: player2Rank)
                
                let (player1Win,player2Win) = rankHelper.playersMatchResult(player1, player2: player2)
                player1WinCount += player1Win
                player2WinCount += player2Win
            }
        }
        print("\n\n")
        print("Player 1: \(player1WinCount) hands \n")
        print("Player 2: \(player2WinCount) hands")
    }
    func testMode() {
        if CommandLine.argc < 2 {
            print("Error", CommandLine.arguments[0], " No arguments are passed.")
            exit(1)
        }
        let fileName = CommandLine.arguments[1]
        let filePath = FileManager.default.currentDirectoryPath + "/" + fileName
        do {
            // Read the contents of the poker hands file
            let contents = try String(contentsOfFile: filePath)
            // Split the file into separate lines
            let lines = contents.components(separatedBy: "\r\n")
            var player1WinCount = 0, player2WinCount = 0
            for line in lines {
                let (player1Cards, player2Cards) = stdIOHelper.getCardsWithSorted(line) ?? ([],[])
                let player1Rank = rankHelper.getPlayerCardsRank(player1Cards)
                let player2Rank = rankHelper.getPlayerCardsRank(player2Cards)
                let player1 = Player(cards: player1Cards, rank: player1Rank)
                let player2 = Player(cards: player2Cards, rank: player2Rank)
                
                let (player1Win,player2Win) = rankHelper.playersMatchResult(player1, player2: player2)
                player1WinCount += player1Win
                player2WinCount += player2Win
            }
            print("Player 1: \(player1WinCount)\r\n")
            print("Player 2: \(player2WinCount)")
        } catch (let error as NSError) {
            print(error.debugDescription)
        }
    }
}
