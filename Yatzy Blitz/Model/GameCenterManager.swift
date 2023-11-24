import GameKit

class GameCenterManager: NSObject, ObservableObject, GKLocalPlayerListener {

    static let shared = GameCenterManager()
    
    @Published var isAuthenticated = false
    @Published var receivedInvite: GKInvite?
    private var viewController: UIViewController?

    private override init() {
        super.init()
    }
    
    func authenticateLocalPlayer(presentingVC: UIViewController?) {
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = { [weak self] vc, error in
            if let vc = vc {
                presentingVC?.present(vc, animated: true)
            } else if localPlayer.isAuthenticated {
                self?.isAuthenticated = true
            } else {
                if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func player(_ player: GKPlayer, didAccept invite: GKInvite) {
        self.receivedInvite = invite
        self.receivedInvite = nil
    }

    func post(score: Int, to leaderboardID: String) {
        guard isAuthenticated else {
            print("User is not authenticated with Game Center.")
            return
        }
        let localPlayer = GKLocalPlayer.local
        GKLeaderboard.submitScore(score, context: 0, player: localPlayer, leaderboardIDs: [leaderboardID]) { error in
            if let error = error {
                print("Failed to report score: \(error.localizedDescription)")
            }
        }
    }
}
