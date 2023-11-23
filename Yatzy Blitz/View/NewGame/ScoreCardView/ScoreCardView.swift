import SwiftUI

struct ScoreCardView: View {
    
    @ObservedObject var gameData: GameData
    @ObservedObject var viewModel: MultiplayerModel
    @Binding var landscape:Bool
    let helpers = Helpers()
    let dataModel = GameFunctionality()
    var isLocal: Bool
    
    var body: some View {
        let mainContent = Group {
            if landscape {
                let firstColumn = helpers.scoreTypes.prefix(4)
                let secondColumn = helpers.scoreTypes.dropFirst(4).prefix(2)
                let thirdColumn = helpers.scoreTypes.dropFirst(6).prefix(4)
                let fourthColumn = helpers.scoreTypes.dropFirst(10)
                HStack {
                    generateScoreColumn(using: Array(firstColumn), isBonus: false, addBlank: false)
                    generateScoreColumn(using: Array(secondColumn), isBonus: true, addBlank: true)
                    generateScoreColumn(using: Array(thirdColumn), isBonus: false, addBlank: false)
                    generateScoreColumn(using: Array(fourthColumn), isBonus: false, addBlank: true)
                }
            } else {
                HStack {
                    generateScoreColumn(using: Array(helpers.scoreTypes.prefix(6)), isBonus: true, addBlank: false)
                    generateScoreColumn(using: Array(helpers.scoreTypes.suffix(7)), isBonus: false, addBlank: false)
                }
            }
        }
        return Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                mainContent
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.height * 0.60)
            } else {
                mainContent
            }
        }
    }
    
    func generateScoreColumn(using columnData: [String], isBonus:Bool, addBlank:Bool) -> some View {
        VStack {
            ForEach(columnData, id: \.self) { data in
                let index = helpers.scoreTypes.firstIndex(of: data) ?? 0
                ScoreView(gameData: gameData, viewModel: viewModel, dataModel: dataModel, isLocal: isLocal, data: data, index: index)
                    .padding(UIDevice.current.userInterfaceIdiom == .pad ? 4 : 0)
                    .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 400 : .infinity)
            }
            if isBonus{
                BonusScoreView(bonusScores1: Array(gameData.player1Score.prefix(6)), bonusScores2: Array(gameData.player2Score.prefix(6)), active: gameData.p1Active)
                    .padding(UIDevice.current.userInterfaceIdiom == .pad ? 4 : 0)
                    .frame(maxWidth: UIDevice.current.userInterfaceIdiom == .pad ? 400 : .infinity)
            }
            if addBlank{
                RoundedRectangle(cornerRadius: 8)
                    .padding(UIDevice.current.userInterfaceIdiom == .pad ? 4 : 0)
                    .frame(minHeight: 45, maxHeight: UIDevice.current.userInterfaceIdiom == .pad ? 100 : .infinity)
                    .foregroundColor(.clear)
            }
        }
    }
}
