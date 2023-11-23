import SwiftUI
import Foundation

class EndGameViewModel: ObservableObject{

    @Published var requestSent: Bool = false
    @Published var isPressed = [false,false]
    @Published var waitingForRematchConfirmation = false
    @Published var requestReceived:Bool = false
    @Published var waitingForRematchResponse = false
    @Published var customAlertMessage: String = "Waiting for opponent"
    
    func shouldDisplayLottieView(gameData:GameData, isLocal:Bool, isAIMatch:Bool) -> Bool {
        if gameData.draw != nil{
            return false
        } else {
            return gameData.winner ?? true || (isLocal && !isAIMatch)
        }
    }
    
    func updateStats(adCoordinator:AdCoordinator, gameData:GameData, isLocal:Bool, isAIMatch:Bool){
        if adCoordinator.adShown || adCoordinator.adFailed{
            let p1Score = gameData.player1Score.compactMap { $0 }.reduce(0, +) + gameData.player1BonusScore
            let p2Score = gameData.player2Score.compactMap { $0 }.reduce(0, +) + gameData.player2BonusScore
            if isLocal || playerStatusImageName(gameData: gameData,isLocal: isLocal, isAIMatch: isAIMatch) == "Draw" {
                GameCenterManager.shared.post(score: p1Score, to: "global")
            }
            StatsModel.shared.setStats(cat: "games", value: StatsModel.shared.retrieveStat(value: "games") + 1)
            switch playerStatusImageName(gameData: gameData,isLocal: isLocal, isAIMatch: isAIMatch){
            case "YouWon":
                if p1Score > p2Score{
                    GameCenterManager.shared.post(score: p1Score, to: "global")
                } else {
                    GameCenterManager.shared.post(score: p2Score, to: "global")
                }
                StatsModel.shared.setStats(cat: "won", value: StatsModel.shared.retrieveStat(value: "won") + 1)
                SoundManager.shared.playSound("celebrate")
            case "YouLost":
                if p1Score < p2Score{
                    GameCenterManager.shared.post(score: p1Score, to: "global")
                } else {
                    GameCenterManager.shared.post(score: p2Score, to: "global")
                }
                StatsModel.shared.setStats(cat: "lost", value: StatsModel.shared.retrieveStat(value: "lost") + 1)
            case "Winner":
                SoundManager.shared.playSound("celebrate")
                if localWinnerResult(gameData: gameData,isLocal: isLocal,isAIMatch: isAIMatch) != "Player 2"{
                    StatsModel.shared.setStats(cat: "won", value: StatsModel.shared.retrieveStat(value: "won") + 1)
                } else {
                    StatsModel.shared.setStats(cat: "lost", value: StatsModel.shared.retrieveStat(value: "lost") + 1)
                }
            case "Draw": StatsModel.shared.setStats(cat: "draw", value: StatsModel.shared.retrieveStat(value: "draw") + 1)
            default:return
            }
        }
    }
    
    
    func playerStatusImageName(gameData:GameData, isLocal:Bool, isAIMatch:Bool) -> String {
        if gameData.draw == true { return "Draw" }
        let winImage = "YouWon"
        let loseImage = "YouLost"
        if isLocal {
            return isAIMatch ? (gameData.winner ?? true ? winImage : loseImage) : "Winner"
        } else {
            return gameData.winner ?? true ? winImage : loseImage
        }
    }
    func resetValues(multiplayerModel:MultiplayerModel, gameData:GameData){
        multiplayerModel.rematchConfirmation = nil
        multiplayerModel.receiviedRematchRequest = nil
        gameData.resetToDefault()
    }
    
    func localWinnerResult(gameData:GameData, isLocal:Bool, isAIMatch:Bool) -> String {
        if isLocal && !isAIMatch && gameData.draw != true {
            return gameData.winnerName
        } else {
            return ""
        }
    }
    
    func handleFirstButtonAction(isLocal: Bool, multiplayerModel: MultiplayerModel, gameData: GameData) {
        if !isLocal {
            if !self.requestSent {
                self.waitingForRematchConfirmation = true
                self.requestSent = true
                multiplayerModel.sendRematchRequest()
                
            } else {
                customAlertMessage = "Request already sent, waiting for opponent"
                self.waitingForRematchConfirmation = true
            }
        } else {
            gameData.resetToDefault()
            print("Reset to default")
        }
    }
}
