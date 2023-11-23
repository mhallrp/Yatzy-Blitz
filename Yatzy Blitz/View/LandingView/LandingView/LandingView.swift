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
struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}



class UMPViewController: UIViewController {
    var canLoadAdsCallback: (() -> Void)?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        // Perform any initialization logic here
        let parameters = UMPRequestParameters()
        // Set tag for under age of consent. Here false means users are not under age.
        parameters.tagForUnderAgeOfConsent = false
        
        // Request an update to the consent information.
        UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(
            with: parameters,
            completionHandler: { error in
                if error != nil {
                    // Handle the error.
                } else {
                    // The consent information state was updated.
                    // You are now ready to check if a form is
                    // available.
                    let formStatus = UMPConsentInformation.sharedInstance.formStatus
                    if formStatus == UMPFormStatus.available {
                        self.loadForm()
                    }
                }
            })
        
    }
    
    func loadForm() {
        UMPConsentForm.load(completionHandler: { form, loadError in
            if loadError != nil {
                // Handle the error.
            } else {
                // Present the form. You can also hold on to the reference to present
                // later.
                if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.required {
                    form?.present(
                        from: self,
                        completionHandler: { dismissError in
                            if UMPConsentInformation.sharedInstance.consentStatus == UMPConsentStatus.obtained {
                                // App can start requesting ads.
                                if let callback = self.canLoadAdsCallback {
                                    callback()
                                }
                            }
                            // Handle dismissal by reloading form.
                            self.loadForm();
                        })
                } else {
                    // Keep the form available for changes to user consent.
                }
            }
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Your existing code and UI setup here
}

struct UMPWrapper: UIViewControllerRepresentable {
    var canLoadAdsCallback: (() -> Void)?
    
    func makeUIViewController(context: Context) -> UMPViewController {
        let umpViewController = UMPViewController()
        umpViewController.canLoadAdsCallback = canLoadAdsCallback
        return umpViewController
    }
    
    func updateUIViewController(_ uiViewController: UMPViewController, context: Context) {
        
    }
}
