import SwiftUI

struct RollPlayView: View {
    
    @ObservedObject var rollPlayViewModel: RollPlayViewModel
    @ObservedObject var gameData: GameData
    @ObservedObject var multiplayerModel: MultiplayerModel
    @State private var isPressed = [false, false, false]
    @Binding var landscape:Bool
    @Binding var emoteView:Bool
    var isLocal: Bool
    var isAIMatch: Bool
    
    var body: some View {
        HStack(alignment: .top){
            Button(action:{
                if multiplayerModel.isMyTurn && gameData.rollCount > 0 {
                    gameData.isRolling = true
                    rollPlayViewModel.performDiceRoll(gameData: gameData, multiplayerModel: multiplayerModel, isLocal: isLocal)
                }
            }){}
                .transaction { t in t.animation = nil }
                .pressAction { isPressed[0] = true } onRelease: { isPressed[0] = false }
                .buttonStyle(RollButtonStyling(active: gameData.rollCount != 0 ? true : false, roll: true, text:"Roll", rollCount: gameData.rollCount, isMyTurn: multiplayerModel.isMyTurn, isPressed: isPressed[0]))
            Button(action:{
                rollPlayViewModel.handlePlayAction(gameData: gameData, multiplayerModel: multiplayerModel, isAIMatch: isAIMatch, isLocal: isLocal)
            }){
            }
            .transaction { t in t.animation = nil }
            .pressAction { isPressed[1] = true } onRelease: { isPressed[1] = false }
            .buttonStyle(RollButtonStyling(active: gameData.playIsActive ? true : false, roll: false, text:"Play", rollCount: gameData.rollCount, isMyTurn: multiplayerModel.isMyTurn, isPressed: isPressed[1]))
            Button(action:{
                emoteView = true
            }){}
                .transaction { t in t.animation = nil }
                .pressAction{ isPressed [2] = true} onRelease: { isPressed[2] = false }
                .buttonStyle(EmoteButtonStyling(isPressed: isPressed[2]))
        }
        .padding(.bottom, 8)
        .customHeightForRollPlayView(landscape: landscape)
    }
}
