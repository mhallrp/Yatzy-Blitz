import Foundation
import SwiftUI

class GameData: ObservableObject {
    
    private let numberOfDice = 5
    private let maxRollCount = 3
    private let scoreCategories = 13
    @AppStorage("aiOpposerSpeed") private var aiOpposerSpeed: Double = 0.8
    @Published var cancelled: Bool = false
    @Published var paused: Bool = false
    @Published var playIsActive = false
    @Published var roundNumber = 0
    @Published var currentRoll: [Int]
    @Published var selectedDice: [Bool]
    @Published var rollCount = 3
    @Published var p1Active = true
    @Published var player1Score: [Int?]
    @Published var player2Score: [Int?]
    @Published var player1BonusScore = 0
    @Published var player2BonusScore = 0
    @Published var selected = [String]()
    @Published var finalChoice = [0,0]
    @Published var scoreChoice = [String]()
    @Published var winner: Bool?
    @Published var draw: Bool?
    @Published var isRolling = false
    var winnerName = ""
    
    init() {
        self.currentRoll = Array(repeating: 0, count: numberOfDice)
        self.selectedDice = Array(repeating: false, count: numberOfDice)
        self.player1Score = Array(repeating: nil, count: scoreCategories)
        self.player2Score = Array(repeating: nil, count: scoreCategories)
        self.winner = nil
        self.draw = nil
        self.scoreChoice = Array(repeating: "", count: scoreCategories)
    }
}

extension GameData{
    func cancel() {
        cancelled = true
    }
}

extension GameData {
    func getCurrentGameState(isSenderTurn: Bool,endTurn: Bool) -> GameState {
        return GameState(
            senderUUIDKey: "",
            isSenderTurn: isSenderTurn,
            endTurn: endTurn,
            currentRoll: self.currentRoll,
            player1Score: self.player1Score,
            player2Score: self.player2Score,
            player1BonusScore: self.player1BonusScore,
            player2BonusScore: self.player2BonusScore,
            selectedDice: self.selectedDice,
            rollCount: self.rollCount,
            selected: self.selected,
            playIsActive: self.playIsActive,
            p1Active: self.p1Active,
            finalChoice: self.finalChoice,
            scoreChoice: self.scoreChoice,
            roundNumber: self.roundNumber,
            winner: self.winner,
            draw: self.draw
        )
    }
}

extension GameData {
    func resetToDefault() {
        playIsActive = false
        roundNumber = 0
        currentRoll = Array(repeating: 0, count: numberOfDice)
        selectedDice = Array(repeating: false, count: numberOfDice)
        rollCount = maxRollCount
        p1Active = true
        player1Score = Array(repeating: nil, count: scoreCategories)
        player2Score = Array(repeating: nil, count: scoreCategories)
        player1BonusScore = 0
        player2BonusScore = 0
        selected = []
        finalChoice = [0,0]
        scoreChoice = Array(repeating: "", count: scoreCategories)
        winner = nil
        winnerName = ""
        draw = nil
    }
}

extension GameData {
    func resetRound() {
        currentRoll = [0,0,0,0,0]
        rollCount = 3
        selected = []
        scoreChoice = Array(repeating: "", count: scoreCategories)
        p1Active.toggle()
        playIsActive = false
        selectedDice = Array(repeating: false, count: numberOfDice)
    }
}

extension GameData {
    func checkWinner(p1score: Int, p2score:Int) -> Bool? {
        if !self.player1Score.contains(where: { $0 == nil }) && !self.player2Score.contains(where: { $0 == nil }){
            if p1score == p2score{
                draw = true
                winnerName = "Player 1"
                return true
            }
            if p1Active && p1score > p2score{
                winnerName = "Player 1"
                return true
            } else if p1Active && p1score < p2score {
                winnerName = "Player 2"
                return false
            } else if !p1Active && p1score > p2score {
                winnerName = "Player 1"
                return false
            } else {
                winnerName = "Player 2"
                return true
            }
        }
        return nil
    }
}

extension GameData {

    func initiateAITurn(completion: (() -> Void)? = nil) {
        let helpers = Helpers()
        let dataModel = GameFunctionality()
        if paused {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.initiateAITurn(completion: completion)
            }
            return
        }
        if cancelled == true { return }
        if rollCount > 0 {
            currentRoll = dataModel.rollDice(currentRoll: currentRoll, selectedDice: selectedDice)
            selectedDice = [false, false, false, false, false]
            rollCount -= 1
            let decision = ComputerPlayer(currentScores: player2Score).decidePlayOrRoll(roll: currentRoll, rollCount: rollCount)
            switch decision {
            case .play(let category):
                DispatchQueue.main.asyncAfter(deadline: .now() + aiOpposerSpeed) { [self] in
                    selected = [category]
                    DispatchQueue.main.asyncAfter(deadline: .now() + aiOpposerSpeed) { [self] in
                        if cancelled { return }
                        player2Score[Int(helpers.scoreTypes.firstIndex(of: category)!)] = Int(dataModel.selectionCheck(selection: category, currentRoll: currentRoll, hasYahtzee: player2Score[11] != nil && player2Score[11] != 0))
                        player2BonusScore = player2Score.prefix(6).map { $0 ?? 0 }.reduce(0, +) > 62 ? 35 : 0
                        resetRound()
                        winner = checkWinner(p1score: player1Score.compactMap { $0 }.reduce(0, +) + player1BonusScore, p2score: player2Score.compactMap { $0 }.reduce(0, +) + player2BonusScore)
                        completion?()
                    }
                }
            case .reRoll(let diceToReroll):
                DispatchQueue.main.asyncAfter(deadline: .now() + aiOpposerSpeed) { [self] in
                    selectedDice = diceToReroll
                    DispatchQueue.main.asyncAfter(deadline: .now() + aiOpposerSpeed) { [self] in
                        initiateAITurn(completion: completion)
                    }
                }
            }
        }
    }
}
