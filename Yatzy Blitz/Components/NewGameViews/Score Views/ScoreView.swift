import SwiftUI

struct ScoreView: View {
    @ObservedObject var gameData: GameData
    @ObservedObject var viewModel: MultiplayerModel
    let helpers = Helpers()
    var dataModel: GameFunctionality
//    var diceMethods = DiceMethods()
    var isLocal: Bool
    var data: String
    var index: Int
    var p1scoreChoice: String { gameData.p1Active ? gameData.scoreChoice[index] : "" }
    var p2scoreChoice: String { gameData.p1Active ? "" : gameData.scoreChoice[index]}
    
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    @AppStorage("isVibrationOn") private var isVibrationOn = true
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .frame(minHeight: 45, maxHeight: UIDevice.current.userInterfaceIdiom == .pad ? 100 : .infinity)
            .foregroundColor(gameData.selected.contains(data) ? .yellow : .white)
            .overlay(
                HStack {
                    Image(data)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .padding(.leading, 8)
                        .padding(.vertical, helpers.isSmallScreenHeightDevice() ? 5 : 0 )
                    ScoreRectangle(score: gameData.player1Score[index]?.description ?? p1scoreChoice, active: gameData.p1Active)
                        .padding(.horizontal, 4)
                        .padding(.vertical, helpers.isSmallScreenHeightDevice() ? 5 : 0 )
                    ScoreRectangle(score: gameData.player2Score[index]?.description ?? p2scoreChoice, active: !gameData.p1Active)
                        .padding(.trailing, 8)
                        .padding(.vertical, helpers.isSmallScreenHeightDevice() ? 5 : 0 )
                }
                    .padding(.vertical, UIDevice.current.userInterfaceIdiom == .pad ? 8 : 0)
            )
            .onTapGesture(perform: handleTap)
    }
    
    func handleTap() {
        if gameData.isRolling { return }
        guard viewModel.isMyTurn, gameData.currentRoll != [0,0,0,0,0], (gameData.p1Active && gameData.player1Score[index] == nil) || (!gameData.p1Active && gameData.player2Score[index] == nil) else { return }
        gameData.scoreChoice = Array(repeating: "", count: 13)
        if isVibrationOn{
            feedbackGenerator.impactOccurred()
        }
        if gameData.selected.contains(data) {
            gameData.playIsActive = false
            gameData.selected = []
        } else {
//            gameData.playIsActive = true
//            gameData.selected = [data]
//            var choice = diceMethods.resultCheck(roll: gameData.currentRoll, type: data)
//            if (gameData.p1Active ? gameData.player1Score[11] != nil && gameData.player1Score[11] != 0 : gameData.player2Score[11] != nil && gameData.player2Score[11] != 0){
//                choice = choice + 50
//            }
//            gameData.scoreChoice[index] = String(choice)
//            gameData.finalChoice = [index, Int(choice)]
            
            gameData.playIsActive = true
            gameData.selected = [data]
            let choice = dataModel.selectionCheck(selection: data, currentRoll: gameData.currentRoll, hasYahtzee: gameData.p1Active ? gameData.player1Score[11] != nil && gameData.player1Score[11] != 0 : gameData.player2Score[11] != nil && gameData.player2Score[11] != 0)
            gameData.scoreChoice[index] = choice
            gameData.finalChoice = [index, Int(choice)!]
            
        }
        if !isLocal { viewModel.sendCurrentGameState(endTurn: false) }
    }
}

struct ScoreRectangle: View {

    var score: String
    var active:Bool
    var dynamicFontSize: CGFloat {
        return UIDevice.current.userInterfaceIdiom == .pad ? 36 : 24
    }

    var body: some View {
        
        let bgColor = active ? Color.white : Color(UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.00))
        
        return RoundedRectangle(cornerRadius: 8)
            .strokeBorder(active ? .black : .gray, lineWidth: 4)
            .aspectRatio(1, contentMode: .fit)
            .background(RoundedRectangle(cornerRadius: 8).fill(bgColor))
            .overlay(
                Text(score)
                    .font(.custom("Inter-Black", size: dynamicFontSize))
                    .foregroundColor(active ? .black : .gray)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .padding(.horizontal, 2)
            )
    }
}
