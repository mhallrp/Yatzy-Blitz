import SwiftUI

struct RematchRequestView: View {
    
    @ObservedObject var multiplayerModel: MultiplayerModel
    @ObservedObject var gameData: GameData
    @ObservedObject var endGameViewModel: EndGameViewModel
    @Binding var backToLanding:Bool
    @Binding var showEndScreen:Bool
    
    var body: some View {
        let names = multiplayerModel.getPlayerNames()
        ZStack{
            Color.black.opacity(0.2)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                Text("\(names.opponent ?? "Opponent") has requested a rematch")
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                ActivityIndicator()
                    .scaleEffect(1.5)
                HStack{
                    Button(action: {
                        multiplayerModel.sendRematchConfirmation(response: false)
                        gameData.resetToDefault()
                        endGameViewModel.requestReceived = false
                        backToLanding = true
                        showEndScreen = false
                    }) {
                        Text("Decline")
                            .foregroundColor(.black)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                    }
                    Button(action: {
                        multiplayerModel.sendRematchConfirmation(response: true)
                        gameData.resetToDefault()
                        showEndScreen = false
                    }) {
                        Text("Confirm")
                            .foregroundColor(.black)
                            .padding(.horizontal, 30)
                            .padding(.vertical, 10)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(10)
                    }
                }
            }
            .padding(30)
            .background(Color.white)
            .cornerRadius(20)
        }
    }
}
