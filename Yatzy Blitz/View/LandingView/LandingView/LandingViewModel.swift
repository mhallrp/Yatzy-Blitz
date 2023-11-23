import SwiftUI
import GameKit

extension LandingView{
    
    func presentMatchmaker() {
        let matchRequest = GKMatchRequest()
        matchRequest.minPlayers = 2
        matchRequest.maxPlayers = 2
        if let matchmakerVC = GKMatchmakerViewController(matchRequest: matchRequest) {
            let delegate = MatchmakerDelegate(viewModel: viewModel)
            matchmakerVC.matchmakerDelegate = delegate
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                objc_setAssociatedObject(matchmakerVC, &MatchmakerDelegateAssociationKey, delegate, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                rootVC.present(matchmakerVC, animated: true, completion: nil)
            }
        }
    }
    
}

private var MatchmakerDelegateAssociationKey: UInt8 = 0
