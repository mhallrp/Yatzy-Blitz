import SwiftUI
import GameKit
import UserMessagingPlatform

struct LandingView: View {
    
    var isMatchStarted: Bool { viewModel.match != nil || gcManager.receivedInvite != nil }
    @StateObject var viewModel = MultiplayerModel()
    @StateObject var gameData = GameData()
    @ObservedObject var gcManager = GameCenterManager.shared
    @State private var showMultiplayerOptions = false
    @State private var navigationPath: [NavigationDestination] = []
    
    enum NavigationDestination {
        case onlineMatch
        case newAIGame
        case localMultiplayer
        case settings
        case profile
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            NavigationView {
                ZStack {
                    UMPWrapper(canLoadAdsCallback: {
                        debugPrint("Can load ads now")
                    })
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
                        .navigationBarItems(trailing:
                                                HStack(spacing: 16) {
                            Button(action: {
                                self.navigationPath = [.settings]
                            }) {
                                Image(systemName: "gear")
                                    .resizable()
                                    .foregroundColor(.black)
                                    .frame(width: 22, height: 22)
                            }
                            
                            Button(action: {
                                self.navigationPath = [.profile]
                            }) {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .foregroundColor(.black)
                                    .frame(width: 22, height: 22)
                            }
                        }
                        )
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
                case .newAIGame: NewGameView(multiplayerModel: viewModel, gameData: gameData, isLocal: true, isAIMatch: true)
                case .localMultiplayer: NewGameView(multiplayerModel: viewModel, gameData: gameData, isLocal: true, isAIMatch: false)
                case .onlineMatch: NewGameView(multiplayerModel: viewModel, gameData: gameData, isLocal: false, isAIMatch: false)
                        .onAppear { viewModel.gameData = gameData }
                case .settings:SettingsView()
                case .profile:ProfileView()
                }
            }
        }
        .accentColor(.black)
    }
}
