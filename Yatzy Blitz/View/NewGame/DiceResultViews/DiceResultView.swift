import SwiftUI

struct DiceResultView: View {
    
    @ObservedObject var gameData: GameData
    @ObservedObject var viewModel: MultiplayerModel
    @State private var isPressed = [false, false, false, false, false]
    @Binding var landscape:Bool
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
    @AppStorage("isVibrationOn") private var isVibrationOn = true
    
    var isLocal: Bool
    let helper = Helpers()
    
    var body: some View {
        if landscape{
            VStack() { diceView() }
        }else{
            HStack() { diceView() }
                .padding(.vertical, helper.isSmallScreenHeightDevice() ? 8 : 16)
        }
    }
}

extension DiceResultView{
    func diceView() -> some View{
        ForEach(0..<5) { index in
            DiceButton(isPressed: $isPressed[index],selectedDice: gameData.selectedDice[index],result: gameData.currentRoll[index],isMyTurn: viewModel.isMyTurn, isLandscape: landscape) {
                if viewModel.isMyTurn && gameData.currentRoll[index] != 0 {
                    gameData.selectedDice[index].toggle()
                    SoundManager.shared.playSound("click")
                    if isVibrationOn{
                        feedbackGenerator.impactOccurred()
                    }
                    if !isLocal {
                        viewModel.sendCurrentGameState(endTurn: false)
                    }
                }
            }
        }
    }
}

struct DiceButton: View {
    @Binding var isPressed: Bool
    var selectedDice: Bool
    var result: Int
    var isMyTurn: Bool
    var isLandscape:Bool
    var action: () -> Void
    var body: some View {
        Button(action: action) {}
            .pressAction {
                isPressed = true
            } onRelease: {
                isPressed = false
            }
            .buttonStyle(DiceResultButtonStyle(selectedDice: selectedDice, result: result, isMyTurn: isMyTurn, isPressed: isPressed, style: isLandscape ? DiceButtonStyle.landScapeStyle : DiceButtonStyle.portraitStyle))
    }
}
