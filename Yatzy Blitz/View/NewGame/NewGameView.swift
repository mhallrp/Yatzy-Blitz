import SwiftUI

struct NewGameView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var multiplayerModel: MultiplayerModel
    @ObservedObject var gameData: GameData
    @StateObject var emoticonAnimator = EmoticonAnimator()
    @State var showExitAlert = false
    @State var landscape = false
    @State var showEndScreen = false
    @State var backToLanding = false
    @State var orientation = UIDeviceOrientation.unknown
    @State var emoteView = false
    var isLocal: Bool
    var isAIMatch: Bool

    var gameLayout: some View {
        if landscape {
            return AnyView(LandscapeGameLayout(gameData: gameData, viewModel: multiplayerModel, isLocal: isLocal, isAIMatch: isAIMatch, emoteView:$emoteView))
        } else {
            return AnyView(PortraitGameLayout(gameData: gameData, viewModel: multiplayerModel, isLocal: isLocal, isAIMatch: isAIMatch,  emoteView:$emoteView))
        }
    }
    
    var body: some View {
        ZStack {
            BackgroundView()
            if showEndScreen {
                EndGameView(gameData: gameData,multiplayerModel: multiplayerModel,backToLanding: $backToLanding,showEndScreen: $showEndScreen, landscape: $landscape,isLocal: isLocal,isAIMatch: isAIMatch)
                    .edgesIgnoringSafeArea(.all)
            } else {
                gameLayout
                emoteView ? EmoteView(emoteView: $emoteView, animateEmoticon: emoticonAnimator.startEmoticonAnimation) : nil
            }
            ForEach(emoticonAnimator.floatingEmoticons, id: \.id) { emote in
                EmoticonView(emote: emote)
            }
        }
        .onChange(of: showEndScreen) { newValue in
            withAnimation(.none) {
                showEndScreen = newValue
            }
        }
        .navigationBarTitle("Yatzy")
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(showEndScreen)
        .navigationBarItems(leading: AlertButton(showAlert: $showExitAlert, gameData: gameData))
        .gesture(DragGesture(minimumDistance: 30, coordinateSpace: .local)
            .onEnded { value in
                if value.startLocation.x < 20 && value.translation.width > 100 {
                    showExitAlert = true
                }
            }
        )
        .onAppear {
            gameData.cancelled = false
            gameData.paused = false
            if isLocal{
                multiplayerModel.isMyTurn = true
                multiplayerModel.firstPLayer = true
            }
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
            AppDelegate.orientationLock = .all
        }
        .onDisappear {
            if !showEndScreen{
                gameData.cancel()
                gameData.resetToDefault()
                multiplayerModel.resetMultiplayerModel()
            }
        }
        .onRotate { newOrientation in
            if newOrientation.isFlat != true{
                landscape = newOrientation.isLandscape
            }
        }
        .onChange(of: gameData.winner){ newValue in
            if newValue != nil{
                showEndScreen = true
            }
        }
        .onChange(of: backToLanding){ value in
            if value == true{
                backToLanding = false
                presentationMode.wrappedValue.dismiss()
            }
        }
        .onChange(of: multiplayerModel.isMyTurn) { newValue in
            if !newValue && isAIMatch {
                gameData.initiateAITurn() {
                    multiplayerModel.isMyTurn.toggle()
                }
            }
        }
        .alert(isPresented: $multiplayerModel.showDisconnectAlert) {
            Alert(title: Text("Player Disconnected"),
                  message: Text("\(multiplayerModel.disconnectedPlayerName) has left the game."),
                  dismissButton: .default(Text("OK")) {
                gameData.resetToDefault()
                presentationMode.wrappedValue.dismiss()
                multiplayerModel.match = nil
            })
        }
    }
}

