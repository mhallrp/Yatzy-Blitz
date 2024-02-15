import SwiftUI

struct PortraitGameLayout: View {
    var gameData: GameData
    var viewModel: MultiplayerModel
    var isLocal: Bool
    var isAIMatch: Bool
    @Binding var emoteView:Bool
    var body: some View {
        VStack {
            PointsView(landscape: .constant(false), gameData: gameData, viewModel: viewModel)
            Spacer()
            ScoreCardView(gameData: gameData, viewModel: viewModel, landscape: .constant(false), isLocal: isLocal)
            Spacer()
            DiceResultView(gameData: gameData, viewModel: viewModel, landscape: .constant(false), isLocal: isLocal)
            Spacer()
            RollPlayView(rollPlayViewModel: RollPlayViewModel(), gameData: gameData, multiplayerModel: viewModel, landscape: .constant(true), emoteView: $emoteView, isLocal: isLocal, isAIMatch: isAIMatch)
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct LandscapeGameLayout: View {
    var gameData: GameData
    var viewModel: MultiplayerModel
    var isLocal: Bool
    var isAIMatch: Bool
    @Binding var emoteView:Bool
    var body: some View {
        HStack {
            VStack {
                PointsView(landscape: .constant(true), gameData: gameData, viewModel: viewModel)
                Spacer()
                ScoreCardView(gameData: gameData, viewModel: viewModel, landscape: .constant(true), isLocal: isLocal)
                Spacer()
                RollPlayView(rollPlayViewModel: RollPlayViewModel(), gameData: gameData, multiplayerModel: viewModel, landscape: .constant(true), emoteView: $emoteView, isLocal: isLocal, isAIMatch: isAIMatch)
                Spacer()
            }
            .layoutPriority(1)
            Spacer()
            DiceResultView(gameData: gameData, viewModel: viewModel, landscape: .constant(true), isLocal: isLocal)
                .padding()
        }
        .padding()
    }
}
