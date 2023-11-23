import SwiftUI

struct EndGameView: View {
    
    @Environment(\.dismiss) var dismiss
    @ObservedObject var endGameViewModel = EndGameViewModel()
    @ObservedObject var gameData: GameData
    @ObservedObject var multiplayerModel: MultiplayerModel
    @StateObject var adCoordinator = AdCoordinator()
    @Binding var backToLanding:Bool
    @Binding var showEndScreen:Bool
    @Binding var landscape:Bool
    @State var rr: Bool = false
    
    var isLocal:Bool
    var isAIMatch:Bool
    private let adViewControllerRepresentable = AdViewControllerRepresentable()
    
    
    func backToHome(){
        endGameViewModel.resetValues(multiplayerModel: multiplayerModel, gameData: gameData)
        backToLanding = true
        showEndScreen = false
    }
    
    func handleRematchConfirmationChange(_ newValue: Bool?) {
        guard let response = newValue else { return }
        endGameViewModel.resetValues(multiplayerModel: multiplayerModel, gameData: gameData)
        if !response {
            backToLanding = true
        }
        showEndScreen = false
    }
    
    var body: some View {
        ZStack{
            if adCoordinator.adShown || adCoordinator.adFailed{
                if endGameViewModel.shouldDisplayLottieView(gameData: gameData, isLocal: isLocal, isAIMatch: isAIMatch) {
                    ConfettiAnimationView();
                }
                VStack{
                    Image(endGameViewModel.playerStatusImageName(gameData: gameData,isLocal: isLocal,isAIMatch: isAIMatch))
                    Text(endGameViewModel.localWinnerResult(gameData: gameData,isLocal: isLocal,isAIMatch: isAIMatch))
                        .font(.custom("Inter-Bold", size: 30))
                        .foregroundColor(.white)
                    PointsView(landscape: $landscape, gameData: gameData,viewModel: multiplayerModel)
                        .padding(.horizontal)
                    Button(action: {
                        endGameViewModel.handleFirstButtonAction(isLocal: isLocal, multiplayerModel: multiplayerModel, gameData: gameData)
                        if isLocal { showEndScreen = false }
                    }, label: {} )
                    .pressAction { endGameViewModel.isPressed[0] = true} onRelease: { endGameViewModel.isPressed[0] = false }
                    .buttonStyle(MainButtonView(text: "Rematch", isPressed: endGameViewModel.isPressed[0]))
                    
                    Button(action: backToHome, label: {})
                        .pressAction { endGameViewModel.isPressed[1] = true } onRelease: { endGameViewModel.isPressed[1] = false }
                        .buttonStyle(MainButtonView(text: "Back to home", isPressed: endGameViewModel.isPressed[1]))
                }
            } else {
                DiceAnimationView()
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
        .overlay{
            if endGameViewModel.waitingForRematchConfirmation {
                WaitingForRematchView(waitingForRematchConfirmation: $endGameViewModel.waitingForRematchConfirmation, customAlertMessage: $endGameViewModel.customAlertMessage)
            }
        }
        .overlay{
            if rr {
                RematchRequestView(multiplayerModel: multiplayerModel, gameData: gameData, endGameViewModel: endGameViewModel, backToLanding: $backToLanding, showEndScreen: $showEndScreen)
            }
        }
        .background {
            adViewControllerRepresentable
                .frame(width: .zero, height: .zero)
        }
        .onChange(of: adCoordinator.adShown, perform: { newValue in
            endGameViewModel.updateStats(adCoordinator: adCoordinator, gameData: gameData, isLocal: isLocal, isAIMatch: isAIMatch)
        })
        .onChange(of: adCoordinator.adFailed, perform: { newValue in
            endGameViewModel.updateStats(adCoordinator: adCoordinator, gameData: gameData, isLocal: isLocal, isAIMatch: isAIMatch)
        })
        .onAppear(){
            adCoordinator.loadAd()
        }
        .onDisappear(){
            multiplayerModel.rematchConfirmation = nil
            multiplayerModel.receiviedRematchRequest = nil
        }
        .onChange(of: adCoordinator.adReady, perform: { newValue in
            adCoordinator.presentAd(from: adViewControllerRepresentable.viewController)
        })
        .onChange(of: multiplayerModel.rematchConfirmation) { newValue in
            handleRematchConfirmationChange(newValue)
        }
        .onChange(of: multiplayerModel.receiviedRematchRequest, perform: { newValue in
            if newValue == nil { return }
            rr = true
            
        })
    }
}
