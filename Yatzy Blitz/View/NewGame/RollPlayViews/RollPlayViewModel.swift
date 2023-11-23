import SwiftUI

class RollPlayViewModel:ObservableObject {

    let gameFunctions = GameFunctionality()
    @AppStorage("rollAnimationOn") private var rollAnimationOn = true
    @AppStorage("isVibrationOn") private var isVibrationOn = true
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    
    func performDiceRoll(gameData: GameData, multiplayerModel: MultiplayerModel, isLocal: Bool) {
        
        if !rollAnimationOn && isVibrationOn{
            feedbackGenerator.impactOccurred()
        }
            SoundManager.shared.playRandomRollSound()
            if rollAnimationOn{
                gameData.isRolling = true
                let totalIterations = 5
                for i in 0..<totalIterations {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1 * Double(i)) { [self] in
                        if isVibrationOn {
                            feedbackGenerator.impactOccurred()
                        }
                        gameData.currentRoll = gameFunctions.rollDice(currentRoll: gameData.currentRoll, selectedDice: gameData.selectedDice)
                        if !isLocal { multiplayerModel.sendCurrentGameState(endTurn: false) }
                        if i == totalIterations - 1 {
                            gameData.isRolling = false
                        }
                    }
                }
            } else {
                gameData.isRolling = false
                gameData.currentRoll = gameFunctions.rollDice(currentRoll: gameData.currentRoll, selectedDice: gameData.selectedDice)
                if !isLocal { multiplayerModel.sendCurrentGameState(endTurn: false) }
            }

            gameData.rollCount -= 1
            gameData.selected = []
            gameData.scoreChoice = ["","","","","","","","","","","","",""]
            if !isLocal { multiplayerModel.sendCurrentGameState(endTurn: false) }
    }
    
    func handlePlayAction(gameData: GameData, multiplayerModel: MultiplayerModel, isAIMatch: Bool, isLocal:Bool) {
        if multiplayerModel.isMyTurn && gameData.playIsActive {
            if isVibrationOn{
                feedbackGenerator.impactOccurred()
            }
            if gameData.p1Active {
                gameData.player1Score[gameData.finalChoice[0]] = gameData.finalChoice[1]
                gameData.player1BonusScore = gameData.player1Score.prefix(6).map { $0 ?? 0 }.reduce(0, +) > 62 ? 35 : 0
            } else {
                gameData.player2Score[gameData.finalChoice[0]] = gameData.finalChoice[1]
                gameData.player2BonusScore = gameData.player2Score.prefix(6).map { $0 ?? 0 }.reduce(0, +) > 62 ? 35 : 0
            }
            gameData.winner = gameData.checkWinner(
                p1score: gameData.player1Score.compactMap { $0 }.reduce(0, +) + gameData.player1BonusScore,
                p2score: gameData.player2Score.compactMap { $0 }.reduce(0, +) + gameData.player2BonusScore
            )
            gameData.resetRound()
            if isAIMatch {
                multiplayerModel.isMyTurn.toggle()
            }
            if !isLocal { multiplayerModel.sendCurrentGameState(endTurn: true) }
        }
    }
}

