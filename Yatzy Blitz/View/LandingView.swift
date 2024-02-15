import SwiftUI
import GameKit

struct LandingView: View {
    var isMatchStarted: Bool { viewModel.match != nil || gcManager.receivedInvite != nil }
    @ObservedObject var gcManager = GameCenterManager.shared
    @StateObject var viewModel = MultiplayerModel()
    @StateObject var gameData = GameData()
    @StateObject var emoticonAnimator = EmojiAnimator()
    @State private var showMultiplayerOptions = false
    @State private var navigationPath: [NavigationDestination] = []
    var body: some View {
        NavigationStack(path: $navigationPath) {
            NavigationView {
                ZStack {
                    UMPWrapper(canLoadAdsCallback: {})
                    BackgroundView()
                        .onAppear { viewModel.match = nil }
                    if !isMatchStarted {
                        VStack{
                            Image("Logo")
                                .padding(.bottom, 50)
                            if showMultiplayerOptions {
                                MultiplayerHeaderView(showMultiplayerOptions:$showMultiplayerOptions)
                            }
                            LandingButtonsStack(showMultiplayerOptions: $showMultiplayerOptions, navigationPath: $navigationPath, presentMatchmakerAction: presentMatchmaker)
                            BackgroundPickerView()
                        }
                        .navigationBarItems(trailing: LandingNavButtons(navigationPath: $navigationPath))
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .onAppear {
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                AppDelegate.orientationLock = .portrait
            }
            .onChange(of: isMatchStarted) { started in
                if started {
                    self.navigationPath = [.onlineMatch]
                }
            }
            .onReceive(gcManager.$receivedInvite) { invite in
                if let invite = invite {
                    GKMatchmaker.shared().match(for: invite, completionHandler: { (match, error) in
                        if let error = error {
                            print("Error getting match for invite: \(error.localizedDescription)")
                        } else if let match = match {
                            viewModel.setup(match: match)
                            self.navigationPath = [.onlineMatch]
                        }
                    })
                }
            }
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .newAIGame: NewGameView(multiplayerModel: viewModel, gameData: gameData, emojiAnimator: emoticonAnimator, isLocal: true, isAIMatch: true)
                case .localMultiplayer: NewGameView(multiplayerModel: viewModel, gameData: gameData, emojiAnimator: emoticonAnimator, isLocal: true, isAIMatch: false)
                case .onlineMatch: NewGameView(multiplayerModel: viewModel, gameData: gameData, emojiAnimator: emoticonAnimator, isLocal: false, isAIMatch: false)
                        .onAppear { viewModel.gameData = gameData; viewModel.animate = emoticonAnimator }
                case .settings:SettingsView()
                case .profile:ProfileView()
                }
            }
        }
        .accentColor(.black)
    }
}
//
//#Preview {
//    LandingView()
//}
